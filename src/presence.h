// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "world.h"

#include <chrono>
#include <cstdint>
#include <expected>
#include <optional>
#include <string>
#include <string_view>

namespace BlackTek::Tests
{
	// tests/test_presence.cpp only: builds a held claim without a database
	struct PresenceClaimAccess;
}

namespace BlackTek::World
{
	// One account's deployment-wide login slot. Move-only; a default-constructed
	// claim holds nothing. Destroying a held claim queues its release, so every
	// early return between claiming and entering the world frees the account.
	class PresenceClaim
	{
		public:
			PresenceClaim() noexcept = default;
			~PresenceClaim();

			PresenceClaim(PresenceClaim&& other) noexcept;
			PresenceClaim& operator=(PresenceClaim&& other) noexcept;	// releases a held claim first

			// non-copyable
			PresenceClaim(const PresenceClaim&) = delete;
			PresenceClaim& operator=(const PresenceClaim&) = delete;

			// synchronous, dispatcher only: the logout path
			void Release() noexcept;

			[[nodiscard]] bool		IsHeld() const noexcept		{ return token != 0; }
			[[nodiscard]] uint64_t	Token() const noexcept		{ return token; }

		private:
			friend class Presence;
			friend struct BlackTek::Tests::PresenceClaimAccess;

			PresenceClaim(std::string releaseQuery, uint64_t claimToken) noexcept;

			// hands the release to g_databaseTasks and leaves this claim empty
			void QueueRelease() noexcept;

			std::string	release_query;	// prebuilt: the destructor must never read g_config
			uint64_t	token = 0;
	};

	class Presence
	{
		public:
			static constexpr std::chrono::seconds BeatInterval{ 10 };
			// longer than the connection's 30 s read/write timeout (database.cpp:35-37)
			// plus one interval, so one timed-out beat never expires a live world
			static constexpr std::chrono::seconds Lease{ 45 };

			enum class Refusal : uint8_t
			{
				AlreadyOnline,
				Unavailable,
			};

			enum class Holder : uint8_t
			{
				Ours,		// our own token: a resent write already landed
				Abandoned,	// this world's leftover row, or the holder world stopped beating
				Live,
			};

			struct Refused
			{
				std::string	character_name;
				Refusal		reason = Refusal::Unavailable;
				Id			world = 0;
			};

			// what one beat does about takeovers that landed while this world was unreachable
			struct ReconcilePlan
			{
				bool reconcile = false;		// run Reconcile() in this beat
				bool follow_up = false;		// whether a later landed beat must still run it, if this beat's Reconcile() read its claims
				bool stall_pending = false;	// a stall seen on a beat that did not land; the next landed beat reconciles it
			};

			using ClaimResult = std::expected<PresenceClaim, Refused>;

			Presence(const Presence&) = delete;
			Presence& operator=(const Presence&) = delete;

			static Presence& GetInstance() noexcept
			{
				static Presence instance;
				return instance;
			}

			// mainLoader, once, after every listener is bound. Refuses a schema name
			// containing '`'; deletes this world's rows; writes the first beat; arms Beat().
			// An empty schema name is a single-world install: presence stays disabled.
			std::expected<void, std::string> Start(std::string_view authSchema);

			// Game::setGameState(SHUTDOWN), after the kick loop
			void Retire() noexcept;

			[[nodiscard]] bool			IsEnabled() const noexcept	{ return not auth_schema.empty() and not retired; }

			// dispatcher; only after the local one-session check passed in the same task.
			// [[nodiscard]]: discarding the claim releases it immediately.
			[[nodiscard]] ClaimResult	Claim(uint32_t accountId, uint32_t playerId, std::string_view characterName);

			[[nodiscard]] static Holder	Classify(uint64_t holderToken, Id holderWorld, bool holderExpired, uint64_t ourToken, Id ourWorld) noexcept;

			// Pure; whether this beat must treat this world as possibly expired to
			// other worlds. Beat() feeds it to PlanReconcile.
			//
			// databaseAge: UNIX_TIMESTAMP() - beat_at, read before this beat's upsert, on
			// the same clock other worlds judge expiry by; nullopt when the read failed
			// or found no row, which counts as a stall. readSpan: process time from
			// before that read until the upsert returned; the database clock cannot
			// have advanced further between the read and the upsert's commit, so
			// databaseAge + readSpan bounds the age this world's heartbeat reached
			// before it was renewed, however late any reply arrived. sinceLastBeat:
			// process time since the last landed beat's reply, a second trigger for a
			// long local pause; zero when no beat has landed yet.
			//
			// Other worlds take over once that age, in whole seconds, exceeds Lease.
			// Whole seconds keep the bound: floor(read + span) <= floor(read) + ceil(span),
			// so databaseAge + ceil(readSpan) is never below the age any takeover saw
			// before the upsert committed, and reaching Lease + 1 would be exact. That
			// holds only while the database's wall clock runs no faster than this
			// process's steady clock; the threshold is Lease - BeatInterval instead, so
			// a database clock stepped or slewed forward by up to BeatInterval within
			// one check is still caught. On a healthy cadence the age is about one
			// BeatInterval, so the margin only reconciles after a delay of more than
			// Lease - 2 * BeatInterval, and a spare Reconcile kicks nobody.
			[[nodiscard]] static constexpr bool IsStall(std::optional<std::chrono::seconds> databaseAge, std::chrono::steady_clock::duration readSpan, std::chrono::steady_clock::duration sinceLastBeat) noexcept
			{
				if (not databaseAge)
					return true;

				const auto threshold = Lease - BeatInterval;
				return *databaseAge + std::chrono::ceil<std::chrono::seconds>(readSpan) >= threshold or sinceLastBeat >= threshold;
			}

			// Pure; Beat() applies it to every beat. A stall reconciles and arms one
			// follow-up. The takeover re-checks the holder world's heartbeat when it
			// executes, so none can land once this beat's upsert committed; the
			// follow-up is a second layer for a takeover whose check ran before the
			// upsert but whose commit is seen after Reconcile's read. The next landed
			// beat runs that follow-up. A failed beat proves nothing (other worlds may
			// still see this one as expired, and a write reported failed may still have
			// committed), so it neither reconciles nor consumes the follow-up, and a
			// stall it saw, or one already carried, is carried to the next landed beat.
			// Never more than one Reconcile per beat.
			// follow_up assumes a Reconcile this plan runs reads its claims; a failed
			// read is settled by FollowUpAfter.
			[[nodiscard]] static constexpr ReconcilePlan PlanReconcile(bool beatLanded, bool stalled, bool followUpPending, bool stallPending) noexcept
			{
				const bool stall = stalled or stallPending;

				if (not beatLanded)
					return ReconcilePlan{ .reconcile = false, .follow_up = followUpPending, .stall_pending = stall };

				else if (stall)
					return ReconcilePlan{ .reconcile = true, .follow_up = true };

				else
					return ReconcilePlan{ .reconcile = followUpPending, .follow_up = false };
			}

			// Pure; the follow-up flag a beat leaves behind once its plan ran.
			// readFailed: the plan's Reconcile() could not read this world's claims, so
			// it checked nothing and a later landed beat must read them again. Ignored
			// when the plan did not reconcile.
			[[nodiscard]] static constexpr bool FollowUpAfter(ReconcilePlan plan, bool readFailed) noexcept
			{
				return plan.follow_up or (plan.reconcile and readFailed);
			}

		private:
			Presence() = default;

			void	Beat();
			// false when this world's claims could not be read; nothing was checked or kicked
			bool	Reconcile();

			std::string								auth_schema;
			std::chrono::steady_clock::time_point	last_beat{};
			std::chrono::steady_clock::time_point	next_beat{};	// Beat()'s drift-free re-arm point
			bool									follow_up_reconcile = false;	// a stall reconciled, or a reconcile could not read; the next landed beat reconciles again
			bool									stall_pending = false;	// a stall seen on beats that did not land; the next landed beat reconciles it
			bool									retired = false;
	};
}
