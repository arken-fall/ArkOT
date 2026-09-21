-- /tile -- everything the server knows about a tile.
--
-- Written for map work. The look description already shows item id, action id
-- and unique id for staff, but only for the one thing you looked at; a lever
-- that misfires or a chest that does nothing is usually about what else is on
-- the tile, or about an id the map never got. This prints the whole stack.
--
--   /tile              the tile you are standing on
--   /tile 32097,32219,7    that tile
--   /tile n            the tile n steps ahead of you, in the way you are facing
--
-- Needs group access (Tutor and above), same as the look debug.

local DIRECTION_STEP = {
	[DIRECTION_NORTH] = {x =  0, y = -1},
	[DIRECTION_EAST]  = {x =  1, y =  0},
	[DIRECTION_SOUTH] = {x =  0, y =  1},
	[DIRECTION_WEST]  = {x = -1, y =  0},
}

-- Only the flags that say something about walking, fighting or scripting here.
-- The full TILESTATE set includes internal bookkeeping nobody needs to read.
local FLAGS = {
	{TILESTATE_BLOCKSOLID, "blocks movement"},
	{TILESTATE_BLOCKPATH, "blocks pathfinding"},
	{TILESTATE_IMMOVABLEBLOCKSOLID, "blocks movement (immovable)"},
	{TILESTATE_IMMOVABLEBLOCKPATH, "blocks pathfinding (immovable)"},
	{TILESTATE_NOFIELDBLOCKPATH, "blocks pathfinding (no field)"},
	{TILESTATE_TELEPORT, "teleport"},
	{TILESTATE_MAGICFIELD, "magic field"},
	{TILESTATE_MAILBOX, "mailbox"},
	{TILESTATE_TRASHHOLDER, "trash holder"},
	{TILESTATE_BED, "bed"},
	{TILESTATE_DEPOT, "depot"},
	{TILESTATE_SUPPORTS_HANGABLE, "supports hangable"},
	{TILESTATE_FLOORCHANGE, "floor change"},
	{TILESTATE_FLOORCHANGE_DOWN, "floor change down"},
	{TILESTATE_FLOORCHANGE_NORTH, "floor change north"},
	{TILESTATE_FLOORCHANGE_SOUTH, "floor change south"},
	{TILESTATE_FLOORCHANGE_EAST, "floor change east"},
	{TILESTATE_FLOORCHANGE_WEST, "floor change west"},
}

-- An item with no name is not broken, but the client cannot name it either --
-- it falls back to "You see an item of type N". Saying so here saves working
-- that out from the client message.
local function describeItem(item, label)
	local itemId = item:getId()
	local name = item:getName()
	local line = string.format("  %-8s id %d", label, itemId)

	if name and name ~= "" then
		line = line .. string.format("  %s", name)
	else
		line = line .. "  (UNNAMED -- client shows 'an item of type " .. itemId .. "')"
	end

	local actionId = item:getActionId()
	if actionId and actionId ~= 0 then
		line = line .. string.format("  aid %d", actionId)
	end

	local uniqueId = item:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
	if uniqueId and uniqueId > 0 then
		line = line .. string.format("  uid %d", uniqueId)
	end

	local count = item:getCount()
	if count and count > 1 then
		line = line .. string.format("  x%d", count)
	end

	-- Item has no isContainer binding; ItemType does, and Container() returns nil
	-- for anything that is not one, so both are checked rather than assumed.
	local itemType = item:getType()
	if itemType and itemType:isContainer() then
		local container = Container(item.uid)
		if container then
			line = line .. string.format("  [container, %d item(s)]", container:getSize())
		end
	end

	return line
end

local function resolvePosition(player, param)
	if param == "" then
		return player:getPosition()
	end

	if param:find(",") then
		local split = param:split(",")
		local x, y, z = tonumber(split[1]), tonumber(split[2]), tonumber(split[3])
		if not x or not y or not z then
			return nil, "Give a position as x,y,z -- for example /tile 32097,32219,7."
		end
		return Position(x, y, z)
	end

	local steps = tonumber(param)
	if not steps then
		return nil, "Give a position as x,y,z, or a number of steps ahead."
	end

	local step = DIRECTION_STEP[player:getDirection()]
	if not step then
		return nil, "I cannot tell which way you are facing."
	end

	local from = player:getPosition()
	return Position(from.x + step.x * steps, from.y + step.y * steps, from.z)
end

local talk = TalkAction("/tile", "!tile")

function talk.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local position, err = resolvePosition(player, param)
	if not position then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, err)
		return false
	end

	local tile = Tile(position)
	if not tile then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
			string.format("No tile at %d, %d, %d -- nothing is mapped there.", position.x, position.y, position.z))
		return false
	end

	local out = {string.format("--- tile %d, %d, %d ---", position.x, position.y, position.z)}

	local ground = tile:getGround()
	if ground then
		out[#out + 1] = describeItem(ground, "ground")
	else
		out[#out + 1] = "  ground   (none)"
	end

	-- getItems() is the stack above the ground, bottom first, which is the order
	-- a script walking the tile would see them in.
	local items = tile:getItems() or {}
	if #items == 0 then
		out[#out + 1] = "  (nothing on the ground item)"
	else
		for index, item in ipairs(items) do
			out[#out + 1] = describeItem(item, string.format("[%d]", index))
		end
	end

	local creatures = tile:getCreatures() or {}
	for _, creature in ipairs(creatures) do
		local kind = creature:isPlayer() and "player" or (creature:isMonster() and "monster" or "npc")
		out[#out + 1] = string.format("  %-8s %s", kind, creature:getName())
	end

	local flags = {}
	for _, entry in ipairs(FLAGS) do
		if tile:hasFlag(entry[1]) then
			flags[#flags + 1] = entry[2]
		end
	end
	if #flags > 0 then
		out[#out + 1] = "  flags    " .. table.concat(flags, ", ")
	end

	local house = tile:getHouse()
	if house then
		out[#out + 1] = string.format("  house    %s (id %d)", house:getName(), house:getId())
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(out, "\n"))
	return false
end

talk:separator(" ")
talk:register()
