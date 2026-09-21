local ec = EventCallback

-- Map work needs more than the top item. A lever that misfires or a chest that
-- does nothing is usually about what else is stacked on the tile, or about an
-- id the map never got, and neither is visible one item at a time -- so a look
-- by staff also reports the whole tile underneath what was clicked.

-- Only the flags that say something about walking, fighting or scripting here.
-- The rest of the TILESTATE set is internal bookkeeping.
local TILE_FLAGS = {
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

-- An item with no name is not a broken script. The client cannot name it
-- either, so it falls back to "an item of type N" -- which reads exactly like
-- a script failure. 7,729 of the generated items are in that state, so it is
-- worth saying out loud rather than leaving to be guessed at.
local function describeStackedItem(item, label)
	local itemId = item:getId()
	local line = string.format("  %-7s id %d", label, itemId)

	local name = item:getName()
	if name and name ~= "" then
		line = line .. "  " .. name
	else
		line = line .. "  (UNNAMED - client shows 'an item of type " .. itemId .. "')"
	end

	-- Always stated, present or not. "no aid" and "the tool did not look" are
	-- the same silence otherwise, and the difference between them is usually the
	-- whole question when a lever or a chest does nothing.
	local actionId = item:getActionId()
	line = line .. string.format("  aid %s", (actionId and actionId ~= 0) and actionId or "-")

	local uniqueId = item:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
	line = line .. string.format("  uid %s", (uniqueId and uniqueId > 0) and uniqueId or "-")

	local count = item:getCount()
	if count and count > 1 then
		line = line .. string.format("  x%d", count)
	end

	-- Item has no isContainer binding; ItemType does, and Container() returns
	-- nil for anything that is not one, so both are checked rather than assumed.
	local itemType = item:getType()
	if itemType and itemType:isContainer() then
		local container = Container(item.uid)
		if container then
			line = line .. string.format("  [container, %d item(s)]", container:getSize())
		end
	end

	return line
end

local function describeTile(position)
	-- 0xFFFF means the thing is in a container or on the body, not on the map.
	if not position or position.x == CONTAINER_POSITION then
		return nil
	end

	local tile = Tile(position)
	if not tile then
		return nil
	end

	local out = {string.format("--- tile %d, %d, %d ---", position.x, position.y, position.z)}

	local ground = tile:getGround()
	out[#out + 1] = ground and describeStackedItem(ground, "ground") or "  ground  (none)"

	-- getItems() is the stack above the ground, in the order a script walking
	-- the tile would meet them.
	local items = tile:getItems() or {}
	for index, item in ipairs(items) do
		out[#out + 1] = describeStackedItem(item, string.format("[%d]", index))
	end

	for _, creature in ipairs(tile:getCreatures() or {}) do
		local kind = creature:isPlayer() and "player" or (creature:isMonster() and "monster" or "npc")
		out[#out + 1] = string.format("  %-7s %s", kind, creature:getName())
	end

	local flags = {}
	for _, entry in ipairs(TILE_FLAGS) do
		if tile:hasFlag(entry[1]) then
			flags[#flags + 1] = entry[2]
		end
	end
	if #flags > 0 then
		out[#out + 1] = "  flags   " .. table.concat(flags, ", ")
	end

	local house = tile:getHouse()
	if house then
		out[#out + 1] = string.format("  house   %s (id %d)", house:getName(), house:getId())
	end

	return table.concat(out, "\n")
end

ec.onLook = function(self, thing, position, distance, description)
	local description = "You see " .. thing:getDescription(distance)
	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())

			-- said up front, because "an item of type N" in the client is the
			-- symptom people mistake for a broken script
			local lookedName = thing:getName()
			if not lookedName or lookedName == "" then
				description = description .. "  (UNNAMED - the client cannot name this item either)"
			end

			-- Reported whether or not they are set: an item with no action id is
			-- the commonest reason a script never fires, and it should be
			-- visible rather than inferred from an absent line.
			local actionId = thing:getActionId()
			description = string.format("%s, Action ID: %s", description,
				actionId ~= 0 and actionId or "none")

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			description = string.format("%s, Unique ID: %s", description,
				(uniqueId > 0 and uniqueId < 65536) and uniqueId or "none")

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:isPlayer() and thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
			end
		end

		-- The whole tile under whatever was clicked. thing:getPosition() is used
		-- rather than the position argument because for a creature the argument
		-- is where the look started, not where the creature is standing.
		local tileInfo = describeTile(thing:getPosition())
		if tileInfo then
			description = description .. "\n" .. tileInfo
		end
	end

	if thing:isItem() then
		if thing:isAugmented() then
			local augments = thing:getAugments()
			local label = (#augments > 1) and "Augments: " or "Augment: "

			for _, augment in pairs(augments) do
				local originalDesc = augment:getDescription()
				local augDesc = originalDesc
				if not augDesc or augDesc == "" or augDesc == "unknown" then
					augDesc = buildAugmentDescription(augment)
				end

				if augDesc and augDesc ~= "" then
					if originalDesc and originalDesc ~= "" and originalDesc ~= "unknown" then
						description = description .. "\n" .. label .. augment:getName() .. "\n" .. augDesc
					else
						description = description .. "\n" .. augDesc
					end
				end
			end
		end

	end

	return description
end

ec:register()
