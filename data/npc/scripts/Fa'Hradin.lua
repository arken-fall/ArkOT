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
-- 	if not MsgContains(message, "djanni'hah") and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) < 0 then
-- 		npcHandler:say("Whoa! A human! This is no place for you, |PLAYERNAME|. Go and play somewhere else.", npc, creature)
-- 		endConversationWithDelay(npcHandler, npc, creature)
-- 		return false
-- 	end
-- 
-- 	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Start) == 1 then
-- 		npcHandler:say({
-- 			"Hahahaha! ...",
-- 			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
-- 		}, npc, creature)
-- 		endConversationWithDelay(npcHandler, npc, creature)
-- 		return false
-- 	end
-- 
-- 	npcHandler:say("Aaaah... what have we here. A human - interesting. And such an ugly specimen, too... All right, human |PLAYERNAME|. How can I help you?", npc, creature)
-- 	npcHandler:setInteraction(npc, creature)
-- 
-- 	return true
-- end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local missionProgress = player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission02)
	if msgcontains(msg, "spy report") or msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission01) ~= 2 then
			npcHandler:say("Looking for work, are you? Well, it's very tempting, you know, but I'm afraid we do not really employ beginners. Perhaps our cook could need a helping hand in the kitchen.", cid)
		elseif missionProgress < 1 then
			npcHandler:say({
				"I have heard some good things about you from Bo'ques. But I don't know. ...",
				"Well, all right. I do have a job for you. ...",
				"In order to stay informed about our enemy's doings, we have managed to plant a spy in Mal'ouquah. ...",
				"He has kept the Efreet and Malor under surveillance for quite some time. ...",
				"But unfortunately, I have lost contact with him months ago. ...",
				"I do not fear for his safety because his cover is foolproof, but I cannot contact him either. This is where you come in. ...",
				"I need you to infiltrate Mal'ouqhah, contact our man there and get his latest spyreport. The password is {PIEDPIPER}. Remember it well! ...",
				"I do not have to add that this is a dangerous mission, do I? If you are discovered expect to be attacked! So goodluck, human!",
			}, cid)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission02, 1)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.DoorToEfreetTerritory, 1)
		elseif missionProgress == 1 then
			npcHandler:say("Did you already retrieve the spyreport?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("Did you already talk to Gabel about the report? I think he will have further instructions for you.", cid)
		end
	elseif npcHandler.topic[playerId] == 1 then
		if msgcontains(msg, "yes") then
			if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.RataMari) ~= 2 or not player:removeItem(3232, 1) then
				npcHandler:say({
					"Don't waste any more time. We need the spyreport of our man in Mal'ouquah as soon as possible! ...",
					"Also don't forget the password to contact our man: PIEDPIPER!",
				}, cid)
			else
				npcHandler:say({
					"You really have made it? You have the report? How come you did not get slaughtered? I must say I'm impressed. Your race will never cease to surprise me. ...",
					"Well, let's see. ...",
					"I think I need to talk to Gabel about this. I am sure he will know what to do. Perhaps you should have a word with him, too.",
				}, cid)
				player:setStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission02, 2)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say({
				"Don't waste any more time. We need the spyreport of our man in Mal'ouquah as soon as possible! ...",
				"Also don't forget the password to contact our man: PIEDPIPER!",
			}, cid)
		end
	end
	return true
end

-- Greeting
-- keywordHandler:addCustomGreetKeyword({ "djanni'hah" }, greetCallback, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, human. I will always remember you. Unless I forget you, of course.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human. I will always remember you. Unless I forget you, of course.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
--

npcHandler:addModule(FocusModule:new())
