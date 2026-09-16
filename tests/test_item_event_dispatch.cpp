// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "item.h"
#include "itemevents.h"
#include "tile.h"

#include "testregistry.h"

// A script may register a use event against a tile rather than an item, which is
// how a map's own levers and statues are reached: they carry no id worth naming,
// only a place. These check that such an event is found for an item lying on that
// tile, is not found for one carried over it, and never takes an item a more
// specific registration already claims.

using namespace BlackTek::Tests;

namespace
{
	constexpr uint16_t LeverId = 2772;
	constexpr Position LeverTile{ 33349, 31123, 5 };

	ItemEvent* positionEvent(const Position& position)
	{
		auto* event = new ItemEvent(nullptr);
		event->hook = BlackTek::ItemEvents::HookType::OnUse;
		event->positions.push_back(position);
		return event;
	}

	// CreateItem reads the item table, which only the server binary loads on boot
	void loadItems()
	{
		static const bool loaded = Item::items.loadFromDat("data/items/assets.dat") and Item::items.loadFromToml();
		if (not loaded)
		{
			throw TestFailure{ "could not load the item table (run tests from the repo root)" };
		}
	}

	ItemPtr leverOn(const TilePtr& tile)
	{
		auto item = Item::CreateItem(LeverId);
		item->setTileParent(tile);
		return item;
	}
}

BT_TEST(itemEventUseFoundByTilePosition)
{
	loadItems();
	ItemEvents events;
	BT_CHECK(events.registerLuaEvent(positionEvent(LeverTile)));

	auto tile = std::make_shared<Tile>(LeverTile.x, LeverTile.y, LeverTile.z);

	BT_CHECK(events.hasEvent(leverOn(tile), BlackTek::ItemEvents::HookType::OnUse));
}

BT_TEST(itemEventUseIgnoresPositionForCarriedItem)
{
	loadItems();
	ItemEvents events;
	BT_CHECK(events.registerLuaEvent(positionEvent(LeverTile)));

	// no tile parent: the item is in a bag or a hand, wherever its holder stands
	const auto carried = Item::CreateItem(LeverId);
	BT_CHECK(not events.hasEvent(carried, BlackTek::ItemEvents::HookType::OnUse));
}

BT_TEST(itemEventUseFindsNothingOnAnotherTile)
{
	loadItems();
	ItemEvents events;
	BT_CHECK(events.registerLuaEvent(positionEvent(LeverTile)));

	auto elsewhere = std::make_shared<Tile>(LeverTile.x + 1, LeverTile.y, LeverTile.z);

	BT_CHECK(not events.hasEvent(leverOn(elsewhere), BlackTek::ItemEvents::HookType::OnUse));
}
