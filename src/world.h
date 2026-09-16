// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include <cstddef>
#include <cstdint>
#include <expected>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace BlackTek::World
{
	// the world-id byte the login protocol puts on the wire
	using Id = uint8_t;

	// one row of config/worlds.toml; a plain aggregate with no invariant of its own
	struct Entry
	{
		std::string	name;		// exactly what the client echoes back in its preamble
		std::string	address;	// what the client dials
		std::string	schema;		// that world's MySQL database
		uint16_t	port = 0;	// that world's game_port_modern
		Id			id = 0;
	};

	// Loaded once in mainLoader, immutable afterwards. Boot refuses on any
	// error, so a Registry that is reachable is always non-empty and always
	// knows which entry is this process.
	class Registry
	{
		public:
			enum class Error : uint8_t
			{
				ParseFailed,
				NoWorlds,
				EmptyField,
				DuplicateId,
				DuplicateName,
				SelfMissing,
				SelfAddressMismatch,
				SelfPortMismatch,
				SelfSchemaMismatch,
			};

			// what this process believes it is, handed in from config
			struct Identity
			{
				std::string	name;		// only used when no worlds.toml exists; see Load()
				std::string	address;
				std::string	schema;
				uint16_t	port = 0;
				Id			id = 0;
			};

			// non-copyable
			Registry(const Registry&) = delete;
			Registry& operator=(const Registry&) = delete;

			static Registry& GetInstance() noexcept
			{
				static Registry instance;
				return instance;
			}

			// Reads config/worlds.toml when present, otherwise synthesises the
			// single world described by `self`. Cross-checks `self` against its
			// own row so a mis-provisioned world can never boot. This is the only
			// mutator; on failure the registry is left empty and boot must refuse.
			std::expected<void, Error> Load(const Identity& self);

			[[nodiscard]] std::span<const Entry>	All() const noexcept	{ return entries; }
			[[nodiscard]] const Entry&				Self() const noexcept;
			[[nodiscard]] const Entry*				Find(Id id) const noexcept;
			[[nodiscard]] const Entry*				Find(std::string_view name) const noexcept;
			[[nodiscard]] bool						IsSelf(std::string_view name) const noexcept;

			[[nodiscard]] static std::string_view	Describe(Error error) noexcept;

		private:
			Registry() = default;

			std::vector<Entry>	entries;
			size_t				self_index = 0;
	};

	// callers outside the subsystem never need the registry's shape
	[[nodiscard]] bool IsLocalWorld(std::string_view name) noexcept;
	[[nodiscard]] const Entry& Local() noexcept;
}
