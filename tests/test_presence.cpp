// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "presence.h"

#include "testregistry.h"

#include <chrono>
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <limits>
#include <optional>
#include <span>
#include <string>
#include <type_traits>
#include <utility>

// Classify is the whole decision a login makes about somebody else's claim, so
// every branch and every precedence between branches is pinned here: answering
// Live where Abandoned was right locks an account out for good, and answering
// Abandoned where Live was right lets one account play on two worlds at once.
// Nothing here touches a database. A held claim built by PresenceClaimAccess is
// destroyed against the test binary's never-started g_databaseTasks, which drops
// the queued release (databasetasks.cpp:41-44), so these cases stay DB-free.

namespace BlackTek::Tests
{
	struct PresenceClaimAccess
	{
		[[nodiscard]] static World::PresenceClaim Held(uint64_t token)
		{
			return World::PresenceClaim{ std::string{ "DO 0" }, token };
		}
	};
}

using namespace BlackTek::Tests;

namespace
{
	using BlackTek::World::Id;
	using BlackTek::World::Presence;
	using BlackTek::World::PresenceClaim;

	using Holder = Presence::Holder;

	constexpr Id OurWorld		= Id{ 0 };
	constexpr Id OtherWorld		= Id{ 1 };

	constexpr uint64_t OurToken		= 0x0123456789ABCDEFull;
	constexpr uint64_t TheirToken	= 0xFEDCBA9876543210ull;

	constexpr bool Expired	= true;
	constexpr bool Beating	= false;

	// the claim's contract is a move-only value: a copy would release twice
	static_assert(not std::is_copy_constructible_v<PresenceClaim>);
	static_assert(not std::is_copy_assignable_v<PresenceClaim>);
	static_assert(std::is_nothrow_move_constructible_v<PresenceClaim>);
	static_assert(std::is_nothrow_move_assignable_v<PresenceClaim>);
}

BT_TEST(presenceClassifiesOurOwnTokenAsOurs)
{
	// a resent INSERT or takeover that already landed: the row is ours on a live foreign world
	BT_CHECK(Presence::Classify(OurToken, OtherWorld, Beating, OurToken, OurWorld) == Holder::Ours);
}

BT_TEST(presenceClassifiesThisWorldsLeftoverRowAsAbandoned)
{
	// fact 2: a foreign token naming this world is leftover even while this world beats
	BT_CHECK(Presence::Classify(TheirToken, OurWorld, Beating, OurToken, OurWorld) == Holder::Abandoned);
}

BT_TEST(presenceClassifiesAnExpiredForeignWorldAsAbandoned)
{
	BT_CHECK(Presence::Classify(TheirToken, OtherWorld, Expired, OurToken, OurWorld) == Holder::Abandoned);
}

BT_TEST(presenceClassifiesABeatingForeignWorldAsLive)
{
	BT_CHECK(Presence::Classify(TheirToken, OtherWorld, Beating, OurToken, OurWorld) == Holder::Live);
}

BT_TEST(presenceOursTakesPrecedenceOverAbandoned)
{
	// Ours must win: answering Abandoned would issue a takeover whose SET changes
	// nothing, rows-changed would read 0, and the login would burn every attempt.
	BT_CHECK(Presence::Classify(OurToken, OurWorld, Beating, OurToken, OurWorld) == Holder::Ours);
	BT_CHECK(Presence::Classify(OurToken, OtherWorld, Expired, OurToken, OurWorld) == Holder::Ours);
	BT_CHECK(Presence::Classify(OurToken, OurWorld, Expired, OurToken, OurWorld) == Holder::Ours);
}

BT_TEST(presenceSameWorldIsAbandonedWhateverItsHeartbeat)
{
	// this world's own heartbeat is current while it runs, so expiry cannot be what frees its leftovers
	BT_CHECK(Presence::Classify(TheirToken, OurWorld, Beating, OurToken, OurWorld) == Holder::Abandoned);
	BT_CHECK(Presence::Classify(TheirToken, OurWorld, Expired, OurToken, OurWorld) == Holder::Abandoned);
}

BT_TEST(presenceComparesTokensAndWorldsExactly)
{
	constexpr uint64_t maxToken = std::numeric_limits<uint64_t>::max();
	constexpr Id maxWorld = std::numeric_limits<Id>::max();

	// tokens one apart, and the largest BIGINT UNSIGNED the gate round-tripped, are distinct holders
	BT_CHECK(Presence::Classify(maxToken - 1, OtherWorld, Beating, maxToken, OurWorld) == Holder::Live);
	BT_CHECK(Presence::Classify(maxToken, OtherWorld, Beating, maxToken, OurWorld) == Holder::Ours);

	// the world comparison is by id, at both ends of the tinyint range
	BT_CHECK(Presence::Classify(TheirToken, maxWorld, Beating, OurToken, Id{ 0 }) == Holder::Live);
	BT_CHECK(Presence::Classify(TheirToken, Id{ 0 }, Beating, OurToken, maxWorld) == Holder::Live);
	BT_CHECK(Presence::Classify(TheirToken, maxWorld, Beating, OurToken, maxWorld) == Holder::Abandoned);
}

BT_TEST(presenceDefaultClaimHoldsNothing)
{
	const PresenceClaim claim;

	BT_CHECK(not claim.IsHeld());
	BT_CHECK(claim.Token() == 0);
}

BT_TEST(presenceMovedFromClaimHoldsNothing)
{
	auto source = PresenceClaimAccess::Held(OurToken);
	BT_CHECK(source.IsHeld());
	BT_CHECK(source.Token() == OurToken);

	// the moved-from claim must not release the account the new owner holds
	PresenceClaim moved{ std::move(source) };
	BT_CHECK(moved.IsHeld());
	BT_CHECK(moved.Token() == OurToken);
	BT_CHECK(not source.IsHeld());
	BT_CHECK(source.Token() == 0);
}

BT_TEST(presenceMoveAssignmentTransfersTheClaim)
{
	auto source = PresenceClaimAccess::Held(TheirToken);

	// over an empty claim
	PresenceClaim target;
	target = std::move(source);
	BT_CHECK(target.IsHeld());
	BT_CHECK(target.Token() == TheirToken);
	BT_CHECK(not source.IsHeld());

	// over a held claim: the old claim is released and the new one takes its place
	auto replacement = PresenceClaimAccess::Held(OurToken);
	target = std::move(replacement);
	BT_CHECK(target.IsHeld());
	BT_CHECK(target.Token() == OurToken);
	BT_CHECK(not replacement.IsHeld());

	// an empty claim moved in leaves the target empty too
	PresenceClaim empty;
	target = std::move(empty);
	BT_CHECK(not target.IsHeld());
	BT_CHECK(target.Token() == 0);
}

namespace
{
	constexpr bool Landed		= true;
	constexpr bool Failed		= false;
	constexpr bool Stalled		= true;
	constexpr bool OnTime		= false;
	constexpr bool Pending		= true;
	constexpr bool NotPending	= false;
	constexpr bool ReadFailed	= true;
	constexpr bool ReadOk		= false;
	constexpr bool Carried		= true;
	constexpr bool NotCarried	= false;

	// a plan that carries no stall unless the case says so
	[[nodiscard]] constexpr bool Matches(Presence::ReconcilePlan plan, bool reconcile, bool followUp, bool stallPending = false) noexcept
	{
		return plan.reconcile == reconcile and plan.follow_up == followUp and plan.stall_pending == stallPending;
	}

	// the plan is a compile-time function: its core cases are pinned before the binary even runs
	static_assert(Matches(Presence::PlanReconcile(Landed, OnTime, NotPending, NotCarried), false, false));
	static_assert(Matches(Presence::PlanReconcile(Landed, Stalled, NotPending, NotCarried), true, true));
	static_assert(Matches(Presence::PlanReconcile(Failed, Stalled, NotPending, NotCarried), false, false, Carried));

	// a follow-up whose read failed checked nothing, so it stays pending
	static_assert(Presence::FollowUpAfter(Presence::PlanReconcile(Landed, OnTime, Pending, NotCarried), ReadFailed));
}

BT_TEST(presenceOnTimeBeatWithoutAStallNeverReconciles)
{
	// the behaviour before any stall is unchanged: no Reconcile, nothing armed
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, OnTime, NotPending, NotCarried), false, false));
}

BT_TEST(presenceStallReconcilesAndArmsOneFollowUp)
{
	// a takeover whose lookup ran before the recovery upsert can still land after Reconcile's read
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, Stalled, NotPending, NotCarried), true, true));
}

BT_TEST(presenceLandedBeatConsumesThePendingFollowUp)
{
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, OnTime, Pending, NotCarried), true, false));
}

BT_TEST(presenceFailedBeatNeitherReconcilesNorConsumesTheFollowUp)
{
	// the heartbeat did not land, so other worlds may still see this world as expired
	BT_CHECK(Matches(Presence::PlanReconcile(Failed, OnTime, Pending, NotCarried), false, true));
	BT_CHECK(Matches(Presence::PlanReconcile(Failed, OnTime, NotPending, NotCarried), false, false));

	// a stall cannot be reconciled from a beat that never landed, so it is carried
	BT_CHECK(Matches(Presence::PlanReconcile(Failed, Stalled, Pending, NotCarried), false, true, Carried));
	BT_CHECK(Matches(Presence::PlanReconcile(Failed, Stalled, NotPending, NotCarried), false, false, Carried));
}

BT_TEST(presenceFailedBeatKeepsACarriedStall)
{
	// a later failed beat that looks on time does not drop a stall an earlier failed beat saw
	BT_CHECK(Matches(Presence::PlanReconcile(Failed, OnTime, NotPending, Carried), false, false, Carried));
	BT_CHECK(Matches(Presence::PlanReconcile(Failed, OnTime, Pending, Carried), false, true, Carried));
}

BT_TEST(presenceLandedBeatReconcilesACarriedStall)
{
	// a write reported failed may still have committed, so the next landed beat's
	// own age read can look fresh: the carried stall reconciles and arms its follow-up
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, OnTime, NotPending, Carried), true, true));
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, OnTime, Pending, Carried), true, true));
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, Stalled, NotPending, Carried), true, true));
}

BT_TEST(presenceStallDuringAPendingFollowUpReconcilesOnceAndRearms)
{
	// one Reconcile for the beat, and the new stall needs its own follow-up
	BT_CHECK(Matches(Presence::PlanReconcile(Landed, Stalled, Pending, NotCarried), true, true));
}

BT_TEST(presenceSuccessfulReadSettlesThePlansFollowUp)
{
	// a read that succeeded leaves exactly what the plan said
	BT_CHECK(not Presence::FollowUpAfter(Presence::PlanReconcile(Landed, OnTime, Pending, NotCarried), ReadOk));
	BT_CHECK(Presence::FollowUpAfter(Presence::PlanReconcile(Landed, Stalled, NotPending, NotCarried), ReadOk));
	BT_CHECK(not Presence::FollowUpAfter(Presence::PlanReconcile(Landed, OnTime, NotPending, NotCarried), ReadOk));
}

BT_TEST(presenceFailedFollowUpReadKeepsTheFollowUpPending)
{
	// the follow-up checked nothing, so the next landed beat must read again
	BT_CHECK(Presence::FollowUpAfter(Presence::PlanReconcile(Landed, OnTime, Pending, NotCarried), ReadFailed));
}

BT_TEST(presenceFailedStallReadLeavesAFollowUpPending)
{
	BT_CHECK(Presence::FollowUpAfter(Presence::PlanReconcile(Landed, Stalled, NotPending, NotCarried), ReadFailed));
	BT_CHECK(Presence::FollowUpAfter(Presence::PlanReconcile(Landed, Stalled, Pending, NotCarried), ReadFailed));
}

BT_TEST(presenceReadFailureWithoutAReconcileChangesNothing)
{
	// no Reconcile ran, so there is no read to have failed: the plan's flag stands
	BT_CHECK(not Presence::FollowUpAfter(Presence::PlanReconcile(Landed, OnTime, NotPending, NotCarried), ReadFailed));
	BT_CHECK(Presence::FollowUpAfter(Presence::PlanReconcile(Failed, OnTime, Pending, NotCarried), ReadFailed));
	BT_CHECK(not Presence::FollowUpAfter(Presence::PlanReconcile(Failed, Stalled, NotPending, NotCarried), ReadFailed));
}

namespace
{
	struct BeatStep
	{
		bool landed = false;
		bool stalled = false;
		bool read_failed = false;	// only meaningful on a step that reconciles
	};

	struct BeatRun
	{
		int		reconciles = 0;
		bool	pending = false;
		bool	stall_pending = false;
		bool	matched = true;
	};

	// drives the flag the way Beat() does: plan, reconcile if planned, then settle
	[[nodiscard]] BeatRun DriveBeats(std::span<const BeatStep> steps, std::span<const bool> expectedReconcile) noexcept
	{
		BeatRun run;
		for (size_t index = 0; index < steps.size(); ++index)
		{
			const auto plan = Presence::PlanReconcile(steps[index].landed, steps[index].stalled, run.pending, run.stall_pending);
			run.matched = run.matched and plan.reconcile == expectedReconcile[index];

			run.pending = Presence::FollowUpAfter(plan, plan.reconcile and steps[index].read_failed);
			run.stall_pending = plan.stall_pending;
			run.reconciles += plan.reconcile ? 1 : 0;
		}

		return run;
	}
}

BT_TEST(presenceFollowUpRunsExactlyOnceAcrossFailedBeats)
{
	// stall, two failed beats, then landed beats
	constexpr BeatStep steps[] =
	{
		{ .landed = Landed, .stalled = Stalled },
		{ .landed = Failed, .stalled = OnTime },
		{ .landed = Failed, .stalled = OnTime },
		{ .landed = Landed, .stalled = OnTime },
		{ .landed = Landed, .stalled = OnTime },
		{ .landed = Landed, .stalled = OnTime },
	};

	constexpr bool expectedReconcile[] = { true, false, false, true, false, false };

	const BeatRun run = DriveBeats(steps, expectedReconcile);
	BT_CHECK(run.matched);
	BT_CHECK(run.reconciles == 2);
	BT_CHECK(not run.pending);
	BT_CHECK(not run.stall_pending);
}

BT_TEST(presenceFailedReadsRetryUntilOneSucceeds)
{
	// stall read fails, follow-up read fails, a heartbeat fails, then a read succeeds
	constexpr BeatStep steps[] =
	{
		{ .landed = Landed, .stalled = Stalled, .read_failed = ReadFailed },
		{ .landed = Landed, .stalled = OnTime, .read_failed = ReadFailed },
		{ .landed = Failed, .stalled = OnTime },
		{ .landed = Landed, .stalled = OnTime, .read_failed = ReadOk },
		{ .landed = Landed, .stalled = OnTime },
	};

	constexpr bool expectedReconcile[] = { true, true, false, true, false };

	const BeatRun run = DriveBeats(steps, expectedReconcile);
	BT_CHECK(run.matched);
	BT_CHECK(run.reconciles == 3);
	BT_CHECK(not run.pending);
	BT_CHECK(not run.stall_pending);
}

BT_TEST(presenceSuccessfulStallReadStillRunsItsFollowUp)
{
	// the stall's own read succeeding does not replace the follow-up, whose read then fails once
	constexpr BeatStep steps[] =
	{
		{ .landed = Landed, .stalled = Stalled, .read_failed = ReadOk },
		{ .landed = Landed, .stalled = OnTime, .read_failed = ReadFailed },
		{ .landed = Landed, .stalled = OnTime, .read_failed = ReadOk },
		{ .landed = Landed, .stalled = OnTime },
	};

	constexpr bool expectedReconcile[] = { true, true, true, false };

	const BeatRun run = DriveBeats(steps, expectedReconcile);
	BT_CHECK(run.matched);
	BT_CHECK(run.reconciles == 3);
	BT_CHECK(not run.pending);
	BT_CHECK(not run.stall_pending);
}

BT_TEST(presenceStallSeenOnFailedBeatsReconcilesOnTheNextLandedBeat)
{
	// the upsert fails on the beat that sees the stall and on the next, then beats land on time
	constexpr BeatStep steps[] =
	{
		{ .landed = Failed, .stalled = Stalled },
		{ .landed = Failed, .stalled = OnTime },
		{ .landed = Landed, .stalled = OnTime, .read_failed = ReadOk },
		{ .landed = Landed, .stalled = OnTime, .read_failed = ReadOk },
		{ .landed = Landed, .stalled = OnTime },
	};

	// the carried stall reconciles and arms its follow-up, which runs once
	constexpr bool expectedReconcile[] = { false, false, true, true, false };

	const BeatRun run = DriveBeats(steps, expectedReconcile);
	BT_CHECK(run.matched);
	BT_CHECK(run.reconciles == 2);
	BT_CHECK(not run.pending);
	BT_CHECK(not run.stall_pending);
}

namespace
{
	using namespace std::chrono_literals;

	constexpr std::optional<std::chrono::seconds> ReadFailedOrMissing = std::nullopt;
	constexpr std::chrono::seconds StallThreshold = Presence::Lease - Presence::BeatInterval;

	// the case the database clock exists for: the last beat's reply came 15 s late,
	// so the process clock saw only 33 s of the database's 48
	static_assert(Presence::IsStall(48s, 50ms, 33s));
	static_assert(not Presence::IsStall(10s, 50ms, 10s));
}

BT_TEST(presenceHealthyCadenceIsNoStall)
{
	BT_CHECK(not Presence::IsStall(10s, 20ms, 10s));
	BT_CHECK(not Presence::IsStall(11s, 900ms, 11s));

	// the first beat after Start(): Start() wrote the heartbeat one interval ago
	BT_CHECK(not Presence::IsStall(Presence::BeatInterval, 0ms, 0s));
}

BT_TEST(presenceDatabaseAgeDetectsAStallTheProcessClockMisses)
{
	// reply delays shorten the process gap; the database age does not shrink with them
	BT_CHECK(Presence::IsStall(48s, 50ms, 33s));
	BT_CHECK(Presence::IsStall(Presence::Lease + 1s, 0ms, 0s));
}

BT_TEST(presenceStallThresholdSitsOneIntervalInsideTheLease)
{
	BT_CHECK(Presence::IsStall(StallThreshold, 0ms, 0s));
	BT_CHECK(not Presence::IsStall(StallThreshold - 1s, 0ms, 0s));

	// another world takes over at Lease + 1 s at the earliest, so the threshold is well before it
	BT_CHECK(StallThreshold + Presence::BeatInterval == Presence::Lease);
}

BT_TEST(presenceReadSpanCountsTowardTheDatabaseAge)
{
	// any fraction of a second between the read and the upsert's reply rounds up
	BT_CHECK(Presence::IsStall(StallThreshold - 1s, 1ms, 0s));
	BT_CHECK(not Presence::IsStall(StallThreshold - 2s, 1ms, 0s));

	// a fresh-looking age still stalls when the upsert itself took long to land
	BT_CHECK(Presence::IsStall(10s, 25s, 0s));
	BT_CHECK(not Presence::IsStall(10s, 24s, 0s));
}

BT_TEST(presenceFailedOrEmptyAgeReadIsAStall)
{
	BT_CHECK(Presence::IsStall(ReadFailedOrMissing, 0ms, 0s));
	BT_CHECK(Presence::IsStall(ReadFailedOrMissing, 20ms, 10s));
}

BT_TEST(presenceProcessClockStillTriggersAStall)
{
	// a long local pause is caught even when the database age reads fresh
	BT_CHECK(Presence::IsStall(10s, 0ms, StallThreshold));
	BT_CHECK(not Presence::IsStall(10s, 0ms, StallThreshold - 1ms));
}

BT_TEST(presenceClockSteppedBackIsNoStallByItself)
{
	// a negative age means beat_at is ahead of the database clock, which every world's expiry check also reads
	BT_CHECK(not Presence::IsStall(-5s, 20ms, 10s));
}

BT_TEST(presenceReleasingAnEmptyClaimDoesNothing)
{
	// must return before reaching Database, which this binary never connects
	PresenceClaim claim;
	claim.Release();
	BT_CHECK(not claim.IsHeld());
}
