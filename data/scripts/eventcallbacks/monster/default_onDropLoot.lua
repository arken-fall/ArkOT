local ec = EventCallback

ec.onDropLoot = function(self, corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end

	local player = Player(corpse:getCorpseOwner())
	local mType = self:getType()
	if not player or player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		-- an active loot prey on this creature raises every drop chance
		local preyBonus = player and player:getPreyLootPercentage(mType:raceId()) or 0
		for i = 1, #monsterLoot do
			local lootBlock = monsterLoot[i]
			if preyBonus > 0 then
				lootBlock.chance = math.floor(lootBlock.chance * (100 + preyBonus) / 100)
			end
			local item = corpse:createLootItem(lootBlock)
			if not item then
				print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
			end
		end

		if player then
			-- the hunt analysers: the kill with its drops, and every drop as loot
			player:sendKillTracker(self, corpse)
			for _, lootItem in ipairs(corpse:getItems()) do
				player:sendLootTracker(lootItem)
			end

			local text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())
			local party = player:getParty()
			if party then
				party:broadcastPartyLoot(text)
			else
				player:sendTextMessage(MESSAGE_LOOT, text)
			end
		end
	else
		local text = ("Loot of %s: nothing (due to low stamina)"):format(mType:getNameDescription())
		local party = player:getParty()
		if party then
			party:broadcastPartyLoot(text)
		else
			player:sendTextMessage(MESSAGE_LOOT, text)
		end
	end
end

ec:register()
