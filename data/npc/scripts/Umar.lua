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

	if not msgcontains(msg, "djanni'hah") and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) < 0 then
		npcHandler:say("Whoa! A human! This is no place for you, |PLAYERNAME|. Go and play somewhere else.", cid)
		endConversationWithDelay(npcHandler, cid)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Start) == 1 then
		npcHandler:say({
			"Hahahaha! ...",
			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
		}, cid)
		endConversationWithDelay(npcHandler, cid)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) == -1 then
		npcHandler:say({
			"Hahahaha! ...",
			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
		}, cid)
		endConversationWithDelay(npcHandler, cid)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor) ~= 1 then
		npcHandler:say({
			"Whoa? You know the word! Amazing, |PLAYERNAME|! ...",
			"I should go and tell Fa'hradin. ...",
			"Well. Why are you here anyway, |PLAYERNAME|?",
		}, cid)
	else
		npcHandler:say("|PLAYERNAME|! How's it going these days? What brings you {here}?", cid)
	end

	npcHandler:setInteraction(npc, cid)

	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	-- To Appease the Mighty Quest
	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) == 1 then
		npcHandler:say({
			"I should go and tell Fa'hradin. ...",
			"I am impressed you know our address of welcome! I honour that. So tell me who sent you on a mission to our fortress?",
		}, cid)
		npcHandler.topic[playerId] = 9
	elseif msgcontains(msg, "kazzan") and npcHandler.topic[playerId] == 9 then
		npcHandler:say({
			"How dare you lie to me?!? The caliph should choose his envoys more carefully. We will not accept his peace-offering ...",
			"...but we are always looking for support in our fight against the evil Efreets. Tell me if you would like to join our fight.",
		}, cid)
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest, player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) + 1)
	end

	if msgcontains(msg, "passage") then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor) ~= 1 then
			npcHandler:say({
				"If you want to enter our fortress you have to become one of us and fight the Efreet. ...",
				"So, are you willing to do so?",
			}, cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("You already have the permission to enter Ashta'daramai.", cid)
		end
	elseif npcHandler.topic[playerId] == 1 then
		if msgcontains(msg, "yes") then
			if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.EfreetDoor) ~= 1 then
				npcHandler:say("Are you sure? You pledge loyalty to king Gabel, who is... you know. And you are willing to never ever set foot on Efreets' territory, unless you want to kill them? Yes?", cid)
				npcHandler.topic[playerId] = 2
			else
				npcHandler:say("I don't believe you! You better go now.", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("This isn't your war anyway, human.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "yes") then
			npcHandler:say({
				"Oh. Ok. Welcome then. You may pass. ...",
				"And don't forget to kill some Efreets, now and then.",
			}, cid)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor, 1)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting, 0)
		elseif msgcontains(msg, "no") then
			npcHandler:say("This isn't your war anyway, human.", cid)
		end
		npcHandler.topic[playerId] = 0
	end
	return true
end

-- Greeting
-- keywordHandler:addCustomGreetKeyword({ "djanni'hah" }, greetCallback, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "<salutes>Aaaa -tention!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "<salutes>Aaaa -tention!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
