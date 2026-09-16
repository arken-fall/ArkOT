local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Don\'t forget to deposit your money here in the Tibian Bank before you head out for adventure.'}
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
-- 	-- Parse bank
-- 	npc:parseBank(message, npc, creature, npcHandler)
-- 	-- Parse guild bank
-- 	npc:parseGuildBank(message, npc, creature, playerId, npcHandler)
-- 	-- Normal messages
-- 	npc:parseBankMessages(message, npc, creature, npcHandler)
-- 
-- 	if MsgContains(message, "ticket") then
-- 		if Player(creature):getStorageValue(Storage.WagonTicket) >= os.time() then
-- 			npcHandler:say("Your weekly ticket is still valid. Would be a waste of money to purchase a second one", npc, creature)
-- 			return true
-- 		end
-- 
-- 		npcHandler:say("Do you want to purchase a weekly ticket for the ore wagons? With it you can travel freely and swiftly through Kazordoon for one week. 250 gold only. Deal?", npc, creature)
-- 		npcHandler:setTopic(playerId, 9)
-- 	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) > 0 then
-- 		local player = Player(creature)
-- 		if npcHandler:getTopic(playerId) == 9 then
-- 			if not player:removeMoneyBank(250) then
-- 				npcHandler:say("You don't have enough money.", npc, creature)
-- 				npcHandler:setTopic(playerId, 0)
-- 				return true
-- 			end
-- 
-- 			player:setStorageValue(Storage.WagonTicket, os.time() + 7 * 24 * 60 * 60)
-- 			npcHandler:say("Here is your stamp. It can't be transferred to another person and will last one week from now. You'll get notified upon using an ore wagon when it isn't valid anymore.", npc, creature)
-- 		end
-- 		npcHandler:setTopic(playerId, 0)
-- 	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) > 0 then
-- 		npcHandler:say("No then.", npc, creature)
-- 		npcHandler:setTopic(playerId, 0)
-- 	elseif MsgContains(message, "measurements") then
-- 		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) >= 6 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.MeasurementsKroox) ~= 1 then
-- 			npcHandler:say("Come on, I have no clue what they are. Better ask my armorer Kroox for such nonsense.Go and ask him for good ol' Lokurs measurements, he'll know.", npc, creature)
-- 			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07, player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) + 1)
-- 		else
-- 			npcHandler:say("...", npc, creature)
-- 			npcHandler:setTopic(playerId, 0)
-- 		end
-- 	end
-- 
-- 	return true
-- end

npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")
npcHandler:setCallback(CALLBACK_GREET, NpcBankGreetCallback)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
