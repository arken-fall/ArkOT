// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "appearances.h"
#include "condition.h"
#include "items.h"

#include "testregistry.h"

#include <fmt/format.h>

using namespace BlackTek::Tests;

// GATE B: server id <-> 15.25 appearance id round-trip for representative
// items, with the client-side flags (which drive the wire format of an item)
// agreeing with what the item actually is.
//
// Expected ids are hardcoded from two independent sources: the TFS 10.98
// items.otb server/client pairs, cross-checked against canary's 15.25
// items.xml names. If loadModernClientIds() or the generated table drifts,
// these break loudly. Run from the repo root (needs data/items/).
//
// One planned representative is missing by design: podiums do not exist in
// the 10.98-derived item space, so there is no server item to round-trip.
// Podium handling gets its coverage in Phase E when the system lands.

namespace
{
	enum class WireClass : uint8_t
	{
		Plain,
		Stackable,
		Container,
		LiquidContainer,
		LiquidPool,
		Ground,
	};

	struct GoldenItem
	{
		uint16_t serverId;
		uint32_t appearanceId;
		WireClass wireClass;
		const char* name;
	};

	constexpr GoldenItem goldenItems[] = {
		{ 2148, 3031, WireClass::Stackable, "gold coin" },
		{ 2152, 3035, WireClass::Stackable, "platinum coin" },
		{ 2160, 3043, WireClass::Stackable, "crystal coin" },
		{ 2260, 3147, WireClass::Stackable, "blank rune" },
		{ 1988, 2854, WireClass::Container, "backpack" },
		{ 1987, 2853, WireClass::Container, "bag" },
		{ 2006, 2874, WireClass::LiquidContainer, "vial" },
		{ 2016, 2886, WireClass::LiquidPool, "pool" },
		{ 2017, 2887, WireClass::LiquidPool, "pool" },
		{ 103, 103, WireClass::Ground, "dirt" },
		{ 493, 622, WireClass::Ground, "water" },
		{ 2554, 3457, WireClass::Plain, "shovel" },
		{ 2120, 3003, WireClass::Plain, "rope" },
		// food became stackable client-side in 12.x - the modern client's
		// view is what drives the wire, so these expect Stackable even
		// though the 10.98 server types are not
		{ 2674, 3585, WireClass::Stackable, "red apple" },
		{ 2789, 3725, WireClass::Stackable, "brown mushroom" },
		{ 2050, 2920, WireClass::Plain, "torch" },
		{ 2400, 3288, WireClass::Plain, "magic sword" },
		{ 2463, 3357, WireClass::Plain, "plate armor" },
		{ 2593, 3501, WireClass::Plain, "mailbox" },
		{ 1386, 1948, WireClass::Plain, "ladder" },
		{ 2580, 3483, WireClass::Plain, "fishing rod" },
	};

	BlackTek::Assets::Appearances& loadedAppearances()
	{
		auto& appearances = BlackTek::Assets::Appearances::getInstance();
		if (not appearances.isLoaded() and not appearances.load("data/items/appearances.dat"))
		{
			throw TestFailure{ "could not load data/items/appearances.dat (run tests from the repo root)" };
		}
		return appearances;
	}

	Items& mappedItems()
	{
		loadedAppearances(); // appearances first so stale mappings get pruned
		static Items instance;
		static bool loaded = instance.loadModernClientIds("data/items/modern_client_ids.tsv");
		if (not loaded)
		{
			throw TestFailure{ "could not load data/items/modern_client_ids.tsv (run tests from the repo root)" };
		}
		return instance;
	}
}

BT_TEST(modernIdsRoundTripGoldenItems)
{
	auto& items = mappedItems();

	for (const auto& golden : goldenItems)
	{
		uint32_t mapped = items.getModernClientId(golden.serverId);
		if (mapped != golden.appearanceId)
		{
			throw TestFailure{ fmt::format("{} (sid {}): mapped to {} but expected appearance {}", golden.name, golden.serverId, mapped, golden.appearanceId) };
		}

		uint16_t reversed = items.getItemIdByModernClientId(golden.appearanceId);
		if (reversed != golden.serverId)
		{
			throw TestFailure{ fmt::format("{} (appearance {}): reverse-mapped to {} but expected sid {}", golden.name, golden.appearanceId, reversed, golden.serverId) };
		}
	}
}

BT_TEST(modernIdsAppearanceFlagsMatchWireClass)
{
	auto& appearances = loadedAppearances();

	for (const auto& golden : goldenItems)
	{
		const auto* info = appearances.getObject(golden.appearanceId);
		if (not info)
		{
			throw TestFailure{ fmt::format("{}: appearance {} missing from appearances.dat", golden.name, golden.appearanceId) };
		}

		auto expect = [&golden](bool condition, const char* what)
		{
			if (not condition)
			{
				throw TestFailure{ fmt::format("{} (appearance {}): flag mismatch, expected {}", golden.name, golden.appearanceId, what) };
			}
		};

		switch (golden.wireClass)
		{
			case WireClass::Stackable:
				expect(info->stackable, "stackable");
				break;
			case WireClass::Container:
				expect(info->container, "container");
				break;
			case WireClass::LiquidContainer:
				expect(info->liquidContainer, "liquid container");
				break;
			case WireClass::LiquidPool:
				expect(info->liquidPool, "liquid pool");
				break;
			case WireClass::Ground:
				expect(info->ground, "ground");
				break;
			case WireClass::Plain:
				expect(not info->stackable and not info->container and not info->liquidContainer and not info->liquidPool, "no special wire class");
				break;
		}
	}
}

BT_TEST(modernIdsFullTableIsAppearanceBacked)
{
	auto& items = mappedItems();
	auto& appearances = loadedAppearances();

	// Every mapping must point at an appearance the client actually has;
	// a stale row here would put an unrenderable id on the wire.
	size_t missing = 0;
	uint32_t firstMissing = 0;
	for (uint32_t serverId = 100; serverId <= std::numeric_limits<uint16_t>::max(); ++serverId)
	{
		uint32_t mapped = items.getModernClientId(static_cast<uint16_t>(serverId));
		if (mapped == 0)
		{
			continue;
		}

		if (not appearances.getObject(mapped))
		{
			if (missing == 0)
			{
				firstMissing = mapped;
			}
			++missing;
		}
	}

	if (missing != 0)
	{
		throw TestFailure{ fmt::format("{} mapped appearance ids missing from appearances.dat (first: {})", missing, firstMissing) };
	}
}
