local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function endConversationWithDelay(npcHandler, npc, creature)
	addEvent(function()
		npcHandler:unGreet(npc, creature)
	end, 1000)
end

local function greetCallback(npc, cid, msg)
	local player = Player(cid)
	local playerId = cid

	--Checks if the player has completed the quest
	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		if not msgcontains(msg, "djanni'hah") and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) < 0 then
			npcHandler:say("Shove off, little one! Humans are not welcome here, |PLAYERNAME|!", cid)
			endConversationWithDelay(npcHandler, cid)
			return false
		end

		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Start) == 1 then
			npcHandler:say({
				"Hahahaha! ...",
				"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
			}, cid)
			endConversationWithDelay(npcHandler, cid)
			return false
		end
	end

	npcHandler:say("Be greeted, human |PLAYERNAME|. How can a humble djinn be of service?", cid)
	npcHandler:setInteraction(npc, cid)

	return true
end

local function creatureSayCallback(cid, type, msg)
	local npc = Npc()
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if table.contains({ "enchanted chicken wing", "boots of haste", "Enchanted Chicken Wing", "Boots of Haste" }, msg) then
		npcHandler:say("Do you want to trade Boots of haste for Enchanted Chicken Wing?", cid)
		npcHandler.topic[playerId] = 1
	elseif table.contains({ "warrior sweat", "warrior helmet", "Warrior Sweat", "Warrior Helmet" }, msg) then
		npcHandler:say("Do you want to trade 4 Warrior Helmet for Warrior Sweat?", cid)
		npcHandler.topic[playerId] = 2
	elseif table.contains({ "fighting spirit", "royal helmet", "Fighting Spirit", "Royal Helmet" }, msg) then
		npcHandler:say("Do you want to trade 2 Royal Helmet for Fighting Spirit", cid)
		npcHandler.topic[playerId] = 3
	elseif table.contains({ "magic sulphur", "fire sword", "Magic Sulphur", "Fire Sword" }, msg) then
		npcHandler:say("Do you want to trade 3 Fire Sword for Magic Sulphur", cid)
		npcHandler.topic[playerId] = 4
	elseif table.contains({ "job", "items", "Items", "Job" }, msg) then
		npcHandler:say("I trade Enchanted Chicken Wing for Boots of Haste, Warrior Sweat for 4 Warrior Helmets, Fighting Spirit for 2 Royal Helmet Magic Sulphur for 3 Fire Swords", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "cookie") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Djinn) ~= 1 then
			npcHandler:say("You brought cookies! How nice of you! Can I have one?", cid)
			npcHandler.topic[playerId] = 5
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] >= 1 and npcHandler.topic[playerId] <= 4 then
			local trade = {
				{ NeedItem = 3079, Ncount = 1, GiveItem = 5891, Gcount = 1 }, -- Enchanted Chicken Wing
				{ NeedItem = 3369, Ncount = 4, GiveItem = 5885, Gcount = 1 }, -- Flask of Warrior's Sweat
				{ NeedItem = 3392, Ncount = 2, GiveItem = 5884, Gcount = 1 }, -- Spirit Container
				{ NeedItem = 3280, Ncount = 3, GiveItem = 5904, Gcount = 1 }, -- Magic Sulphur
			}
			if player:getItemCount(trade[npcHandler.topic[playerId]].NeedItem) >= trade[npcHandler.topic[playerId]].Ncount then
				player:removeItem(trade[npcHandler.topic[playerId]].NeedItem, trade[npcHandler.topic[playerId]].Ncount)
				player:addItem(trade[npcHandler.topic[playerId]].GiveItem, trade[npcHandler.topic[playerId]].Gcount)
				return npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry but you don't have the item.", cid)
			end
		elseif npcHandler.topic[playerId] == 5 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Djinn, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say("You see, good deeds like this will ... YOU ... YOU SPAWN OF EVIL! I WILL MAKE SURE THE MASTER LEARNS ABOUT THIS!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(npc, cid)
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] >= 1 and npcHandler.topic[playerId] <= 4 then
			npcHandler:say("Ok then.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 5 then
			npcHandler:say("I see.", cid)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

local function onTradeRequest(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		npcHandler:say("I'm sorry, but you don't have Malor's permission to trade with me.", cid)
		return false
	end
	return true
end

-- keywordHandler:addCustomGreetKeyword({ "djanni'hah" }, greetCallback, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, human.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "At your service, just browse through my wares.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
