-- The functions Canary's quest scripts call, as Canary writes them.
-- Only what runs on BlackTek's own API is here; see harness/build_canary_functions.py.

function Gobbler_onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not table.contains(slime_ids, target.itemid) then
		return false
	end

	local time = os.time()
	if slime_exhaust[player.uid] and slime_exhaust[player.uid] >= os.time() then
		player:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	slime_exhaust[player.uid] = time + config.slime_exhaust
	player:say("The slime gobbler gobbles large chunks of the slime fungus with great satisfaction.", TALKTYPE_MONSTER_SAY)
	player:addExperience(20, true, true)
	slimes_removed[#slimes_removed + 1] = { cid = player.uid, id = target.itemid, pos = toPosition }
	target:transform(12065)

	if not table.contains(valid_participants, player.uid) then
		local slime_count = 0
		for i = 1, #slimes_removed do
			if slimes_removed[i].cid == player.uid then
				slime_count = slime_count + 1
				if slime_count >= config.slimes_needed then
					player:say("You gobbled enough slime to get a good grip on this dungeon's slippery floor.", TALKTYPE_MONSTER_SAY)
					valid_participants[#valid_participants + 1] = player.uid
					break
				end
			end
		end
	end

	if #slimes_removed == 1 then
		addEvent(revertQuest, config.quest_duration * 60 * 1000)
	elseif #slimes_removed >= config.max_slimes and current_wave == 0 then
		player:say("COME! My servants! RISE!", TALKTYPE_MONSTER_SAY)
		startServantWave()
	end
	return true
end

function Mage_onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
	if killer and table.contains(valid_participants, killer.uid) then
		-- add achievements if needed
	end
	return true
end

function NewBit(number)
	return BIT:new(number)
end

function ParseDuration(duration)
	if not duration then
		return nil
	end

	if type(duration) == "number" then
		return duration
	end

	local multipliers = {
		w = 7 * 24 * 60 * 60 * 1000,
		d = 24 * 60 * 60 * 1000,
		h = 60 * 60 * 1000,
		m = 60 * 1000,
		s = 1000,
		ms = 1,
	}

	local total = 0

	for numStr, unit in string.gmatch(duration, "([%d%.]+)(%a+)") do
		local num = tonumber(numStr)
		if not num then
			error("Invalid numeric part in duration string")
		end

		local multiplier = multipliers[unit]
		if not multiplier then
			error("Invalid unit in duration string")
		end

		total = total + (num * multiplier)
	end

	if total == 0 then
		error("Invalid duration string")
	end

	return total
end

function Participants(player, requireSharedExperience)
	local party = player:getParty()
	if not party then
		return { player }
	end
	if requiredSharedExperience and not party:isSharedExperienceActive() then
		return { player }
	end
	local members = party:getMembers()
	table.insert(members, party:getLeader())
	return members
end

function Servant_onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
	for i = 1, #current_servants do
		if current_servants[i] == creature.uid then
			table.remove(current_servants, i)
			break
		end
	end

	if #current_servants < 1 then
		startServantWave()
	end
	return true
end

function checkBoss(centerPosition, rangeX, rangeY, bossName, bossPos)
	local spectators, found = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY), false
	for i = 1, #spectators do
		local spec = spectators[i]
		if spec:isMonster() then
			if spec:getName() == bossName then
				found = true
				break
			end
		end
	end
	if not found then
		local boss = Game.createMonster(bossName, bossPos, true, true)
		boss:setReward(true)
	end
	return found
end

function cleanAreaQuest(frompos, topos, itemtable, blockmonsters)
	if not itemtable then
		itemtable = {}
	end
	if not blockmonsters then
		blockmonsters = {}
	end
	for _x = frompos.x, topos.x do
		for _y = frompos.y, topos.y do
			for _z = frompos.z, topos.z do
				local tile = Tile(Position(_x, _y, _z))
				if tile then
					local itc = tile:getItems()
					if itc and tile:getItemCount() > 0 then
						for _, pid in pairs(itc) do
							local itp = ItemType(pid:getId())
							if itp and itp:isCorpse() then
								pid:remove()
							end
						end
					end
					for _, pid in pairs(itemtable) do
						local _until = tile:getItemCountById(pid)
						if _until > 0 then
							for i = 1, _until do
								local it = tile:getItemById(pid)
								if it then
									it:remove()
								end
							end
						end
					end
					local mtempc = tile:getCreatures()
					if mtempc and tile:getCreatureCount() > 0 then
						for _, pid in pairs(mtempc) do
							if pid:isMonster() and not table.contains(blockmonsters, pid:getName():lower()) then
								-- broadcastMessage(pid:getName())
								pid:remove()
							end
						end
					end
				end
			end
		end
	end
	return true
end

function clearBossRoom(playerId, centerPosition, onlyPlayers, rangeX, rangeY, exitPosition)
	local spectators, spectator = Game.getSpectators(centerPosition, false, onlyPlayers, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() and ((playerId ~= nil and spectator.uid == playerId) or playerId == nil) then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end

		if spectator:isMonster() then
			spectator:remove()
		end
	end
end

function clearForgotten(fromPosition, toPosition, exitPosition, storage)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			for z = fromPosition.z, toPosition.z do
				if Tile(Position(x, y, z)) then
					local creature = Tile(Position(x, y, z)):getTopCreature()
					if creature then
						if creature:isPlayer() then
							creature:teleportTo(exitPosition)
							exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
							creature:say("Time out! You were teleported out by strange forces.", TALKTYPE_MONSTER_SAY)
						elseif creature:isMonster() then
							creature:remove()
						end
					end
				end
			end
		end
	end
	Game.setStorageValue(storage, 0)
end

function clearRoom(centerPosition, rangeX, rangeY, resetGlobalStorage)
	local spectators, spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end
	if resetGlobalStorage ~= nil and Game.getStorageValue(resetGlobalStorage) == 1 then
		Game.setStorageValue(resetGlobalStorage, -1)
	end
end

function doCreatureSayWithRadius(cid, text, type, radiusx, radiusy, position)
	if not position then
		position = Creature(cid):getPosition()
	end

	local spectators, spectator = Game.getSpectators(position, false, true, radiusx, radiusx, radiusy, radiusy)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:say(text, type, false, spectator, position)
	end
end

function getMonstersInArea(fromPos, toPos, monsterName, ignoreMonsterId)
	local monsters = {}
	for _x = fromPos.x, toPos.x do
		for _y = fromPos.y, toPos.y do
			for _z = fromPos.z, toPos.z do
				local tile = Tile(Position(_x, _y, _z))
				if tile and tile:getTopCreature() then
					for _, pid in pairs(tile:getCreatures()) do
						local mt = Monster(pid)
						if not ignoreMonsterId then
							if mt and mt:isMonster() and mt:getName():lower() == monsterName:lower() and not mt:getMaster() then
								monsters[#monsters + 1] = mt
							end
						else
							if mt and mt:isMonster() and mt:getName():lower() == monsterName:lower() and not mt:getMaster() and ignoreMonsterId ~= mt:getId() then
								monsters[#monsters + 1] = mt
							end
						end
					end
				end
			end
		end
	end
	return monsters
end

function getTibiaTimerDayOrNight()
	local light = getWorldLight()
	if light == 40 then
		return "night"
	else
		return "day"
	end
end

function grimvaleSpectators()
	local specs, spec = Game.getSpectators(Position(33430, 31537, 11), false, false, 18, 18, 18, 18)
	for i = 1, #specs do
		spec = specs[i]
		if spec and spec:isPlayer() then
			oldpos = spec:getPosition()
		end
		addEvent(teleportPlayer, 1, 60 * 1000, spec:getId(), oldpos)
	end
	if Game.getStorageValue(GlobalStorage.Feroxa.Active) == 2 then
		addEvent(removeItems, 15 * 60 * 1000)
		addEvent(loadMap, 15 * 60 * 1000)
		addEvent(Game.broadcastMessage, 15 * 60 * 1000, "The full moon is completely exposed: Feroxa awaits!", MESSAGE_EVENT_ADVANCE)
		addEvent(final, 30 * 60 * 1000)
		Game.setStorageValue(GlobalStorage.Feroxa.Active, 3)
		return true
	end
	Game.setStorageValue(GlobalStorage.Feroxa.Active, 2)
	addEvent(grimvaleSpectators, 15 * 60 * 1000)
	addEvent(Game.broadcastMessage, 15 * 60 * 1000, "Half of the current full moon is visible now, there are still a lot of clouds in front of it.", MESSAGE_EVENT_ADVANCE)
end

function isPlayerInArea(fromPos, toPos)
	for positionX = fromPos.x, toPos.x do
		for positionY = fromPos.y, toPos.y do
			for positionZ = fromPos.z, toPos.z do
				local tile = Tile(Position({ x = positionX, y = positionY, z = positionZ }))
				if tile then
					if tile:getTopCreature() and tile:getTopCreature():isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

function kickerPlayerRoomAfterMin(playername, fromPosition, toPosition, teleportPos, message, monsterName, minutes, firstCall, itemtable, blockmonsters)
	local players = false
	if type(playername) == table then
		players = true
	end
	local player = false
	if not players then
		player = Player(playername)
	end
	local monster = {}
	if monsterName ~= "" then
		monster = getMonstersInArea(fromPosition, toPosition, monsterName)
	end
	if player == false and players == false then
		return false
	end
	if not players and player then
		if player:getPosition():isInRange(fromPosition, toPosition) and minutes == 0 then
			if monsterName ~= "" then
				for _, pid in pairs(monster) do
					if pid:isMonster() then
						if pid:getStorageValue("playername") == playername then
							pid:remove()
						end
					end
				end
			else
				if not itemtable then
					itemtable = {}
				end
				if not blockmonsters then
					blockmonsters = {}
				end
				cleanAreaQuest(fromPosition, toPosition, itemtable, blockmonsters)
			end
			player:teleportTo(teleportPos, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return true
		end
	else
		if minutes == 0 then
			if monsterName ~= "" then
				for _, pid in pairs(monster) do
					if pid:isMonster() then
						if pid:getStorageValue("playername") == playername then
							pid:remove()
						end
					end
				end
			else
				if not itemtable then
					itemtable = {}
				end
				if not blockmonsters then
					blockmonsters = {}
				end
				cleanAreaQuest(fromPosition, toPosition, itemtable, blockmonsters)
			end
			for _, pid in pairs(playername) do
				local player = Player(pid)
				if player and player:getPosition():isInRange(fromPosition, toPosition) then
					player:teleportTo(teleportPos, true)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
				end
			end
			return true
		end
	end
	local min = 60 -- Use the 60 for 1 minute
	if firstCall then
		addEvent(kickerPlayerRoomAfterMin, 1000, playername, fromPosition, toPosition, teleportPos, message, monsterName, minutes, false, itemtable, blockmonsters)
	else
		local subt = minutes - 1
		if monsterName ~= "" then
			if minutes > 3 and table.maxn(monster) == 0 then
				subt = 2
			end
		end
		addEvent(kickerPlayerRoomAfterMin, min * 1000, playername, fromPosition, toPosition, teleportPos, message, monsterName, subt, false, itemtable, blockmonsters)
	end
end

function onDeathForDamagingPlayers(creature, func)
	for key, value in pairs(creature:getDamageMap()) do
		local player = Player(key)
		if player then
			func(creature, player)
		end
	end
end

function onDeathForParty(creature, player, func)
	if not player or not player:isPlayer() then
		return
	end

	local participants = Participants(player, true)
	for _, participant in ipairs(participants) do
		func(creature, participant)
	end
end

function removeItems()
	for x = config.position.fromPosition.x, config.position.toPosition.x do
		for y = config.position.fromPosition.y, config.position.toPosition.y do
			for z = config.position.fromPosition.z, config.position.toPosition.z do
				local tile = Tile(Position(x, y, z))
				if not tile then
					break
				end
				local items = tile:getItems()
				if items then
					for i = 1, #items do
						items[i]:remove()
					end
				end
				local ground = tile:getGround()
				if ground then
					ground:remove()
				end
			end
		end
	end
end

function resetFerumbrasAscendantHabitats()
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Corrupted, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Desert, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Dimension, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Grass, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Ice, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Mushroom, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Roshamuul, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Venom, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.AllHabitats, 0)

	for _, spec in pairs(Game.getSpectators(Position(33629, 32693, 12), false, false, 25, 25, 85, 85)) do
		if spec:isPlayer() then
			spec:teleportTo(Position(33630, 32648, 12))
			spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported because the habitats are returning to their original form.")
		elseif spec:isMonster() then
			spec:remove()
		end
	end

	for x = 33611, 33625 do
		for y = 32658, 32727 do
			local position = Position(x, y, 12)
			local tile = Tile(position)
			if not tile then
				return
			end
			local ground = tile:getGround()
			if not ground then
				return
			end
			ground:remove()
			local items = tile:getItems()
			if items then
				for i = 1, #items do
					local item = items[i]
					item:remove()
				end
			end
		end
	end

	for x = 33634, 33648 do
		for y = 32658, 32727 do
			local position = Position(x, y, 12)
			local tile = Tile(position)
			if not tile then
				return
			end
			local ground = tile:getGround()
			if not ground then
				return
			end
			ground:remove()
			local items = tile:getItems()
			if items then
				for i = 1, #items do
					local item = items[i]
					item:remove()
				end
			end
		end
	end

	Game.loadMap(DATA_DIRECTORY .. "/world/quest/ferumbras_ascendant/habitats.otbm")
	return true
end

function roomIsOccupied(centerPosition, onlyPlayers, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, onlyPlayers, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
end

function setFlag(bt, flag)
	return bit.bor(bt, flag)
end

function setFlag(set, flag)
	if set % (2 * flag) >= flag then
		return set
	end
	return set + flag
end

function startServantWave()
	if current_wave == config.max_waves and not mageSpawned then
		local mage = Game.createMonster("Mad Mage", mage_positions[math.random(#mage_positions)], true, true)
		if mage then
			mageSpawned = true
			mage:registerEvent("MageDeath")
		end
		return
	end

	current_wave = current_wave + 1
	current_servants = {}
	for pos_key = 1, #servant_positions do
		local random = math.random(100)
		for servant_key = 1, #servants do
			if random <= servants[servant_key][1] then
				local servant = Game.createMonster(servants[servant_key][2], servant_positions[pos_key], true, true)
				if servant then
					current_servants[#current_servants + 1] = servant.uid
					servant:registerEvent("ServantDeath")
					break
				end
			end
		end
	end
end

function string.splitFirst(str, delimiter)
	local start, finish = string.find(str, delimiter)
	if start == nil then
		return str, nil
	end
	local firstPart = string.sub(str, 1, start - 1)
	local secondPart = string.sub(str, finish + 1)
	return firstPart:trim(), secondPart:trim()
end

function string.toPosition(inputString)
	local positionPatterns = {
		"{%s*x%s*=%s*(%d+)%s*,%s*y%s*=%s*(%d+)%s*,%s*z%s*=%s*(%d+)%s*}",
		"Position%s*%((%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)",
		"(%d+)%s*,%s*(%d+)%s*,%s*(%d+)",
	}

	for _, pattern in ipairs(positionPatterns) do
		local posX, posY, posZ = string.match(inputString, pattern)
		if posX and posY and posZ then
			return Position(tonumber(posX), tonumber(posY), tonumber(posZ))
		end
	end
	return nil
end

function string.diff(self)
	local format = {
		{ "day", self / 60 / 60 / 24 },
		{ "hour", self / 60 / 60 % 24 },
		{ "minute", self / 60 % 60 },
		{ "second", self % 60 },
	}

	local out = {}
	for k, t in ipairs(format) do
		local v = math.floor(t[2])
		if v > 0 then
			table.insert(out, (k < #format and (#out > 0 and ", " or "") or " and ") .. v .. " " .. t[1] .. (v ~= 1 and "s" or ""))
		end
	end
	local ret = table.concat(out)
	if ret:len() < 16 and ret:find("second") then
		local a, b = ret:find(" and ")
		ret = ret:sub(b + 1)
	end
	return ret
end

function testFlag(set, flag)
	return set % (2 * flag) >= flag
end

function toKey(str)
	return str:lower():gsub(" ", "-"):gsub("%s+", "")
end
