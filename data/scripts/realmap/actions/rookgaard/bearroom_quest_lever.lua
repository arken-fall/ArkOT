local stonePosition = Position(32145, 32101, 11)
local relocatePosition = Position(32145, 32102, 11)
local STONE_ID = 1304

-- A tile cannot hold an unbounded pile of these, and a removal that keeps
-- failing must not spin the game thread, so the sweep is bounded and reports
-- what it managed rather than looping until the tile is clear.
local MAX_STONES = 8

-- Removes the stones blocking the passage and says whether the tile actually
-- ended up clear. The result matters: the lever must not flip to its "open"
-- state while the stone is still standing, and that desync is exactly what left
-- the lever reading 1946 with the passage still blocked.
local function clearStones()
	local tile = Tile(stonePosition)
	if not tile then
		return false
	end

	for _ = 1, MAX_STONES do
		local stone = tile:getItemById(STONE_ID)
		if not stone then
			return true
		end

		if not stone:remove() then
			-- Item:remove() returns the result of internalRemoveItem, which the
			-- old script discarded. Saying so is the difference between a quest
			-- that is broken and a quest that is broken for a known reason.
			print(string.format("[bearroom] stone %d at %d,%d,%d refused removal",
				STONE_ID, stonePosition.x, stonePosition.y, stonePosition.z))
			return false
		end
	end

	return tile:getItemById(STONE_ID) == nil
end

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		if clearStones() then
			item:transform(1946)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The lever grinds, but nothing moves.")
		end
	else
		local tile = Tile(stonePosition)
		tile:relocateTo(relocatePosition)

		-- Only place a stone if the passage is actually open. Creating one
		-- unconditionally stacks a second stone whenever the lever and the world
		-- have drifted apart, which makes the drift worse on every pull.
		if not tile:getItemById(STONE_ID) then
			Game.createItem(STONE_ID, 1, stonePosition)
		end

		item:transform(1945)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5638)
-- The map gives this lever no action id, so the aid above never matches and
-- the quest simply did nothing. Registering the bear room lever's tile as
-- well makes it work without a map edit; the aid stays so that setting it
-- later also works, and nothing else on the map uses 5638.
realmapEvent1:position(Position(32148, 32105, 11))
realmapEvent1:register()
