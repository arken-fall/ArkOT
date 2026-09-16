local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Have a drink in Meriana\'s only tavern!'}
}
npcHandler:addModule(VoiceModule:new(voices))

-- local function creatureSayCallback(npc, creature, type, message)
-- 	local player = Player(creature)
-- 	local playerId = player:getId()
-- 
-- 	if not npcHandler:checkInteraction(npc, creature) then
-- 		return false
-- 	end
-- 
-- 	if MsgContains(message, "cookie") then
-- 		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Ariella) ~= 1 then
-- 			npcHandler:say("So you brought a cookie to a pirate?", npc, creature)
-- 			npcHandler:setTopic(playerId, 1)
-- 		end
-- 	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.PirateOutfits.PirateBaseOutfit) == 1 then
-- 		npcHandler:say("You mean my hat? Well, I might have another one just like that, but I won't simply give it away, even if you earned our trust. You'd have to fulfil a task first.", npc, creature)
-- 		npcHandler:setTopic(playerId, 2)
-- 	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "task") then
-- 		npcHandler:say("Your task is to bring me the shirt of the Lethal Lissy, the sabre of Ron the Ripper, the hat of Brutus Bloodbeard and the eye patch of Deadeye Devious. Did you succeed?", npc, creature)
-- 		npcHandler:setTopic(playerId, 5)
-- 	elseif MsgContains(message, "mission") then
-- 		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 1 then
-- 			npcHandler:say("You know, we have plenty of rum here but we lack some basic food. Especially food that easily becomes mouldy is a problem. Bring me 100 breads and you will help me a lot.", npc, creature)
-- 			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 2)
-- 		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 2 then
-- 			npcHandler:say("Are you here to bring me the 100 pieces of bread that I requested?", npc, creature)
-- 			npcHandler:setTopic(playerId, 3)
-- 		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 3 then
-- 			npcHandler:say({
-- 				"The sailors always tell tales about the famous beer of Carlin. You must know, alcohol is forbidden in that city. ...",
-- 				"The beer is served in a secret whisper bar anyway. Bring me a sample of the whisper beer, NOT the usual beer but whisper beer. I hope you are listening.",
-- 			}, npc, creature)
-- 			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 4)
-- 		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 5 then
-- 			npcHandler:say("Did you get a sample of the whisper beer from Carlin?", npc, creature)
-- 			npcHandler:setTopic(playerId, 4)
-- 		end
-- 	elseif MsgContains(message, "yes") then
-- 		if npcHandler:getTopic(playerId) == 1 then
-- 			if not player:removeItem(130, 1) then
-- 				npcHandler:say("You have no cookie that I'd like.", npc, creature)
-- 				npcHandler:setTopic(playerId, 0)
-- 				return true
-- 			end
-- 
-- 			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Ariella, 1)
-- 			if player:getCookiesDelivered() == 10 then
-- 				player:addAchievement("Allow Cookies?")
-- 			end
-- 
-- 			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
-- 			npcHandler:say("How sweet of you ... Uhh ... OH NO ... Bozo did it again. Tell this prankster I'll pay him back.", npc, creature)
-- 			npcHandler:removeInteraction(npc, creature)
-- 			npcHandler:resetNpc(npc, creature)
-- 		elseif npcHandler:getTopic(playerId) == 3 then
-- 			if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 2 then
-- 				if player:removeItem(3600, 100) then
-- 					npcHandler:say("What a joy. At least for a few days adequate supply is ensured.", npc, creature)
-- 					player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 3)
-- 					npcHandler:setTopic(playerId, 0)
-- 				else
-- 					npcHandler:say("Come back when you got all neccessary items.", npc, creature)
-- 					npcHandler:setTopic(playerId, 0)
-- 				end
-- 			end
-- 		elseif npcHandler:getTopic(playerId) == 4 then
-- 			if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 5 then
-- 				if player:removeItem(6106, 1) then
-- 					npcHandler:say("Thank you very much. I will test this beauty in privacy.", npc, creature)
-- 					player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 6)
-- 					npcHandler:setTopic(playerId, 0)
-- 				else
-- 					npcHandler:say("Come back when you got the neccessary item.", npc, creature)
-- 					npcHandler:setTopic(playerId, 0)
-- 				end
-- 			end
-- 		elseif npcHandler:getTopic(playerId) == 5 and player:getStorageValue(Storage.Quest.U7_8.PirateOutfits.PirateHatAddon) == -1 then
-- 			if player:getItemCount(6101) > 0 and player:getItemCount(6102) > 0 and player:getItemCount(6100) > 0 and player:getItemCount(6099) > 0 then
-- 				if player:removeItem(6101, 1) and player:removeItem(6102, 1) and player:removeItem(6100, 1) and player:removeItem(6099, 1) then
-- 					npcHandler:say("INCREDIBLE! You have found all four of them! |PLAYERNAME|, you have my respect. You more than deserve this hat. There you go.", npc, creature)
-- 					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
-- 					player:addOutfitAddon(155, 2)
-- 					player:addOutfitAddon(151, 2)
-- 					player:setStorageValue(Storage.Quest.U7_8.PirateOutfits.PirateHatAddon, 1)
-- 				end
-- 			else
-- 				npcHandler:say("You do not have all the required items.", npc, creature)
-- 				npcHandler:setTopic(playerId, 0)
-- 			end
-- 		end
-- 	elseif MsgContains(message, "no") then
-- 		if npcHandler:getTopic(playerId) == 1 then
-- 			npcHandler:say("I see.", npc, creature)
-- 			npcHandler:setTopic(playerId, 0)
-- 		elseif npcHandler:getTopic(playerId) == 2 then
-- 			npcHandler:say("Alright then. Come back when you got all neccessary items.", npc, creature)
-- 			npcHandler:setTopic(playerId, 0)
-- 		end
-- 	end
-- 
-- 	return true
-- end

npcHandler:setMessage(MESSAGE_GREET, "Hi there.")
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
--

npcHandler:addModule(FocusModule:new())
