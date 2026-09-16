local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if msgcontains(msg, "funding") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission07) == 1 and player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints) >= 1 then
			npcHandler:say({
				"So far you earned x votes. Each single vote can be spent on a different topic or you're also able to cast all your votes on one voting. ...",
				"Well in the topic b you have the possibility to vote for the funding of the {archives}, import of bug {milk} or street {repairs}.",
			}, cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("You can't vote yet.", cid)
		end
	elseif msgcontains(msg, "archives") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("How many of your x votes do you want to cast?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "1") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Did I get that right: You want to cast 1 of your votes on funding the {archives}?", cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 3 then
			local currentVotes = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints)
			if currentVotes > 0 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, currentVotes - 1)
			end
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission08, 1)
			npcHandler:say("Thanks, you successfully cast your vote. Feel free to continue gathering votes by helping the city! Farewell.", cid)
			npcHandler.topic[playerId] = 0
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ah, you come just in time for the special voting about the most recent {funding} project. I guess you want to participate in it.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
