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

-- local function greetCallback(npc, creature, message)
-- 	local player = Player(creature)
-- 	local playerId = player:getId()
-- 
-- 	--Checks if the player has completed the quest
-- 	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03) ~= 3 then
-- 		if not MsgContains(message, "djanni'hah") and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) < 0 then
-- 			npcHandler:say("Shove off, little one! Humans are not welcome here, |PLAYERNAME|!", npc, creature)
-- 			endConversationWithDelay(npcHandler, npc, creature)
-- 			return false
-- 		end
-- 
-- 		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Start) == 1 then
-- 			npcHandler:say({
-- 				"Hahahaha! ...",
-- 				"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
-- 			}, npc, creature)
-- 			endConversationWithDelay(npcHandler, npc, creature)
-- 			return false
-- 		end
-- 	end
-- 
-- 	npcHandler:say("Be greeted, human |PLAYERNAME|. How can a humble djinn be of service?", npc, creature)
-- 	npcHandler:setInteraction(npc, creature)
-- 
-- 	return true
-- end

-- local function creatureSayCallback(npc, creature, type, message)
-- 	local player = Player(creature)
-- 	local playerId = player:getId()
-- 
-- 	if not npcHandler:checkInteraction(npc, creature) then
-- 		return false
-- 	end
-- 
-- 	if table.contains({ "enchanted chicken wing", "boots of haste", "Enchanted Chicken Wing", "Boots of Haste" }, message) then
-- 		npcHandler:say("Do you want to trade Boots of haste for Enchanted Chicken Wing?", npc, creature)
-- 		npcHandler:setTopic(playerId, 1)
-- 	elseif table.contains({ "warrior sweat", "warrior helmet", "Warrior Sweat", "Warrior Helmet" }, message) then
-- 		npcHandler:say("Do you want to trade 4 Warrior Helmet for Warrior Sweat?", npc, creature)
-- 		npcHandler:setTopic(playerId, 2)
-- 	elseif table.contains({ "fighting spirit", "royal helmet", "Fighting Spirit", "Royal Helmet" }, message) then
-- 		npcHandler:say("Do you want to trade 2 Royal Helmet for Fighting Spirit", npc, creature)
-- 		npcHandler:setTopic(playerId, 3)
-- 	elseif table.contains({ "magic sulphur", "fire sword", "Magic Sulphur", "Fire Sword" }, message) then
-- 		npcHandler:say("Do you want to trade 3 Fire Sword for Magic Sulphur", npc, creature)
-- 		npcHandler:setTopic(playerId, 4)
-- 	elseif table.contains({ "job", "items", "Items", "Job" }, message) then
-- 		npcHandler:say("I trade Enchanted Chicken Wing for Boots of Haste, Warrior Sweat for 4 Warrior Helmets, Fighting Spirit for 2 Royal Helmet Magic Sulphur for 3 Fire Swords", npc, creature)
-- 		npcHandler:setTopic(playerId, 0)
-- 	elseif MsgContains(message, "cookie") then
-- 		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Djinn) ~= 1 then
-- 			npcHandler:say("You brought cookies! How nice of you! Can I have one?", npc, creature)
-- 			npcHandler:setTopic(playerId, 5)
-- 		end
-- 	elseif MsgContains(message, "yes") then
-- 		if npcHandler:getTopic(playerId) >= 1 and npcHandler:getTopic(playerId) <= 4 then
-- 			local trade = {
-- 				{ NeedItem = 3079, Ncount = 1, GiveItem = 5891, Gcount = 1 }, -- Enchanted Chicken Wing
-- 				{ NeedItem = 3369, Ncount = 4, GiveItem = 5885, Gcount = 1 }, -- Flask of Warrior's Sweat
-- 				{ NeedItem = 3392, Ncount = 2, GiveItem = 5884, Gcount = 1 }, -- Spirit Container
-- 				{ NeedItem = 3280, Ncount = 3, GiveItem = 5904, Gcount = 1 }, -- Magic Sulphur
-- 			}
-- 			if player:getItemCount(trade[npcHandler:getTopic(playerId)].NeedItem) >= trade[npcHandler:getTopic(playerId)].Ncount then
-- 				player:removeItem(trade[npcHandler:getTopic(playerId)].NeedItem, trade[npcHandler:getTopic(playerId)].Ncount)
-- 				player:addItem(trade[npcHandler:getTopic(playerId)].GiveItem, trade[npcHandler:getTopic(playerId)].Gcount)
-- 				return npcHandler:say("Here you are.", npc, creature)
-- 			else
-- 				npcHandler:say("Sorry but you don't have the item.", npc, creature)
-- 			end
-- 		elseif npcHandler:getTopic(playerId) == 5 then
-- 			if not player:removeItem(130, 1) then
-- 				npcHandler:say("You have no cookie that I'd like.", npc, creature)
-- 				npcHandler:setTopic(playerId, 0)
-- 				return true
-- 			end
-- 
-- 			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Djinn, 1)
-- 			if player:getCookiesDelivered() == 10 then
-- 				player:addAchievement("Allow Cookies?")
-- 			end
-- 
-- 			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
-- 			npcHandler:say("You see, good deeds like this will ... YOU ... YOU SPAWN OF EVIL! I WILL MAKE SURE THE MASTER LEARNS ABOUT THIS!", npc, creature)
-- 			npcHandler:removeInteraction(npc, creature)
-- 			npcHandler:resetNpc(npc, creature)
-- 		end
-- 	elseif MsgContains(message, "no") then
-- 		if npcHandler:getTopic(playerId) >= 1 and npcHandler:getTopic(playerId) <= 4 then
-- 			npcHandler:say("Ok then.", npc, creature)
-- 			npcHandler:setTopic(playerId, 0)
-- 		elseif npcHandler:getTopic(playerId) == 5 then
-- 			npcHandler:say("I see.", npc, creature)
-- 			npcHandler:setTopic(playerId, 0)
-- 		end
-- 	end
-- 	return true
-- end

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

-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
--

npcHandler:addModule(FocusModule:new())
