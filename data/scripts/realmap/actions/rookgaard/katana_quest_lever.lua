local doorPosition = Position(32177, 32148, 11)
local relocatePosition = Position(32178, 32148, 11)

local CLOSED_DOOR = 5108
local OPEN_DOOR = 5109

-- Action ids the door carries once the lever has moved it. They are what the
-- door's own scripts key off afterwards, so they travel with the transform.
local OPEN_ACTION_ID = 1002
local CLOSED_ACTION_ID = 1001

-- The lever's own two states. Which one means "open" is not fixed: the map
-- ships this lever as 1945 with the door closed, so reading the lever to decide
-- what to do gets it backwards from the very first pull. It is only a handle --
-- the door is the thing with a state worth trusting.
local function flipLever(item)
	item:transform(item:getId() == 1945 and 1946 or 1945)
end

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(doorPosition)
	if not tile then
		return true
	end

	local closed = tile:getItemById(CLOSED_DOOR)
	if closed then
		closed:transform(OPEN_DOOR)
		closed:setActionId(OPEN_ACTION_ID)
		flipLever(item)
		return true
	end

	local open = tile:getItemById(OPEN_DOOR)
	if open then
		-- Anything standing in the doorway is moved aside first; closing a door
		-- onto a creature leaves it inside the wall.
		tile:relocateTo(relocatePosition, true)
		open:transform(CLOSED_DOOR)
		open:setActionId(CLOSED_ACTION_ID)
		flipLever(item)
		return true
	end

	-- The door is neither open nor closed, so it is not there at all. Say so:
	-- silence here is indistinguishable from the lever not being wired up.
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The lever turns, but nothing answers.")
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5637)
-- The map now carries aid 5637 on this lever. The position registration stays
-- as well: it costs nothing, and transforms.lua claims item ids 1945 and 1946
-- for its generic flip, so without one of these two the quest never runs.
realmapEvent1:position(Position(32182, 32145, 11))
realmapEvent1:register()
