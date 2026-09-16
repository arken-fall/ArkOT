// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "world.h"
#include "console.h"
#include "tools.h"

#include <algorithm>
#include <cassert>
#include <filesystem>
#include <system_error>
#include <toml++/toml.hpp>

namespace BlackTek::World
{
	namespace
	{
		constexpr std::string_view WorldsFile = "config/worlds.toml";

		// The world name reaches us from the wire as "<name>\n"; the terminator is
		// stripped before we see it, but a client sending CRLF leaves the '\r'
		// behind. Trimming here costs one pass over a handful of bytes, once per
		// login, and a false rejection would be a total outage.
		[[nodiscard]] std::string_view Trimmed(std::string_view text) noexcept
		{
			constexpr std::string_view whitespace = " \t\r\n";

			const auto first = text.find_first_not_of(whitespace);
			if (first == std::string_view::npos)
				return {};

			return text.substr(first, text.find_last_not_of(whitespace) - first + 1);
		}

		// The wire name travels through the login webservice's SERVER_NAME, where
		// case drift is plausible, so world names compare case-insensitively.
		[[nodiscard]] bool NameMatches(std::string_view declared, std::string_view candidate) noexcept
		{
			return caseInsensitiveEqual(Trimmed(declared), Trimmed(candidate));
		}
	}

	std::expected<void, Registry::Error> Registry::Load(const Identity& self)
	{
		entries.clear();
		self_index = 0;

		// Nothing partially built may survive a failure: boot refuses on any error,
		// and an empty registry is the honest representation of "never loaded".
		const auto fail = [this](Error error) noexcept
		{
			entries.clear();
			self_index = 0;
			return std::unexpected(error);
		};

		std::error_code existsError;
		if (not std::filesystem::exists(WorldsFile, existsError))
		{
			// Single-world deployment: there is no list to validate against, so the
			// process's own configuration is the whole world list. This is what keeps
			// an existing install booting unchanged with no new config file.
			entries.push_back(Entry{
				.name    = std::string{Trimmed(self.name)},
				.address = self.address,
				.schema  = self.schema,
				.port    = self.port,
				.id      = self.id });

			Console::Info("World::Registry::Load: no {:s}; serving the single world '{:s}' (id {:d}).", WorldsFile, entries.front().name, entries.front().id);
			return {};
		}

		toml::table table;
		try
		{
			table = toml::parse_file(WorldsFile);
		}
		catch (const toml::parse_error& err)
		{
			Console::Error("World::Registry::Load: failed to parse {:s}: {:s}", WorldsFile, err.description());
			return fail(Error::ParseFailed);
		}

		const auto* worlds = table["world"].as_array();
		if (not worlds or worlds->empty())
		{
			Console::Error("World::Registry::Load: {:s} declares no [[world]] entries.", WorldsFile);
			return fail(Error::NoWorlds);
		}

		entries.reserve(worlds->size());

		for (const auto& worldNode : *worlds)
		{
			const auto* row = worldNode.as_table();
			if (not row)
			{
				Console::Error("World::Registry::Load: {:s} contains a [[world]] element that is not a table.", WorldsFile);
				return fail(Error::ParseFailed);
			}

			auto name    = (*row)["name"].value_or<std::string>("");
			auto address = (*row)["address"].value_or<std::string>("");
			auto schema  = (*row)["schema"].value_or<std::string>("");

			name    = std::string{Trimmed(name)};
			address = std::string{Trimmed(address)};
			schema  = std::string{Trimmed(schema)};

			const auto declaredId   = (*row)["id"].value_or(int64_t{-1});
			const auto declaredPort = (*row)["port"].value_or(int64_t{0});

			if (name.empty() or address.empty() or schema.empty() or declaredId < 0 or declaredId > 255 or declaredPort <= 0 or declaredPort > 65535)
			{
				Console::Error("World::Registry::Load: a [[world]] entry in {:s} is missing or out of range on a required field (id, name, address, port, schema); id = {:d}, name = '{:s}'.", WorldsFile, declaredId, name);
				return fail(Error::EmptyField);
			}

			const auto declared = static_cast<Id>(declaredId);

			if (Find(declared))
			{
				Console::Error("World::Registry::Load: {:s} declares world id {:d} more than once.", WorldsFile, declared);
				return fail(Error::DuplicateId);
			}

			if (Find(std::string_view{name}))
			{
				Console::Error("World::Registry::Load: {:s} declares the world name '{:s}' more than once.", WorldsFile, name);
				return fail(Error::DuplicateName);
			}

			entries.push_back(Entry{
				.name    = std::move(name),
				.address = std::move(address),
				.schema  = std::move(schema),
				.port    = static_cast<uint16_t>(declaredPort),
				.id      = declared });
		}

		const auto selfPosition = std::ranges::find(entries, self.id, &Entry::id);
		if (selfPosition == entries.end())
		{
			Console::Error("World::Registry::Load: this process is [world].id {:d}, which {:s} does not declare.", self.id, WorldsFile);
			return fail(Error::SelfMissing);
		}

		// A world advertising another world's address, port or schema is the fault
		// class this registry exists to make impossible; catch it at boot, where it
		// costs a refusal, rather than at login, where it costs a misrouted player.
		if (selfPosition->address != self.address)
		{
			Console::Error("World::Registry::Load: world id {:d} is declared at address '{:s}' but this process binds '{:s}'.", self.id, selfPosition->address, self.address);
			return fail(Error::SelfAddressMismatch);
		}

		if (selfPosition->port != self.port)
		{
			Console::Error("World::Registry::Load: world id {:d} is declared on port {:d} but this process listens on {:d}.", self.id, selfPosition->port, self.port);
			return fail(Error::SelfPortMismatch);
		}

		if (selfPosition->schema != self.schema)
		{
			Console::Error("World::Registry::Load: world id {:d} is declared against schema '{:s}' but this process is connected to '{:s}'.", self.id, selfPosition->schema, self.schema);
			return fail(Error::SelfSchemaMismatch);
		}

		self_index = static_cast<size_t>(std::distance(entries.begin(), selfPosition));

		Console::Info("World::Registry::Load: {:d} world(s) from {:s}; this process is '{:s}' (id {:d}).", entries.size(), WorldsFile, selfPosition->name, selfPosition->id);
		return {};
	}

	const Entry& Registry::Self() const noexcept
	{
		// Load() is the only mutator and boot refuses on every error it can report,
		// so a reachable registry always has a self row. The fallback keeps misuse
		// (reading Self() before Load()) a visible blank rather than a crash.
		assert(self_index < entries.size());

		if (self_index >= entries.size()) [[unlikely]]
		{
			static const Entry unloaded{};
			return unloaded;
		}

		return entries[self_index];
	}

	const Entry* Registry::Find(Id id) const noexcept
	{
		const auto match = std::ranges::find(entries, id, &Entry::id);
		return match == entries.end() ? nullptr : &*match;
	}

	const Entry* Registry::Find(std::string_view name) const noexcept
	{
		const auto match = std::ranges::find_if(entries, [name](const Entry& entry) noexcept { return NameMatches(entry.name, name); });
		return match == entries.end() ? nullptr : &*match;
	}

	bool Registry::IsSelf(std::string_view name) const noexcept
	{
		return self_index < entries.size() and NameMatches(entries[self_index].name, name);
	}

	std::string_view Registry::Describe(Error error) noexcept
	{
		switch (error)
		{
			case Error::ParseFailed:			return "config/worlds.toml could not be parsed";
			case Error::NoWorlds:				return "config/worlds.toml declares no [[world]] entries";
			case Error::EmptyField:				return "a [[world]] entry is missing a required field (id, name, address, port or schema)";
			case Error::DuplicateId:			return "two [[world]] entries share the same id";
			case Error::DuplicateName:			return "two [[world]] entries share the same name";
			case Error::SelfMissing:			return "no [[world]] entry matches this process's [world].id";
			case Error::SelfAddressMismatch:	return "this world's declared address does not match [network].ip";
			case Error::SelfPortMismatch:		return "this world's declared port does not match [network].game_port_modern";
			case Error::SelfSchemaMismatch:		return "this world's declared schema does not match [mysql].database";
		}

		return "unknown world registry error";
	}

	bool IsLocalWorld(std::string_view name) noexcept
	{
		return Registry::GetInstance().IsSelf(name);
	}

	const Entry& Local() noexcept
	{
		return Registry::GetInstance().Self();
	}
}
