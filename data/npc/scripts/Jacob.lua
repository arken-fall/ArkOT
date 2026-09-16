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

	if msgcontains(msg, "abandoned sewers") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission05) == 1 then
			npcHandler:say("I'm glad to see you back alive and healthy. Did you find anything interesting that you want to {report}?", cid)
			npcHandler.topic[playerId] = 7
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) < 22 then
			npcHandler:say({
				"You want to enter the abandoned sewers? That's rather dangerous and not a good idea, man. That part of the sewers was not sealed off for nothing, you know? ...",
				"But hey, it's your life, bro. So here's the deal. I'll let you into the abandoned sewers if you help me with our {mission}.",
			}, cid)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 22 then
			npcHandler:say({
				"Wow, you already did it, that's fast. I'm used to a more laid-back attitude from most people. It's a shame to risk losing you to some collapsing tunnels, but a deal is a deal. ...",
				"I hereby grant you the permission to enter the abandoned part of the sewers. Take care, man! ...",
				"If you find something interesting, come back to talk about the {abandoned sewers}.",
			}, cid)
			if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission04) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission04, 1)
			end
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, -1)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) < 1 then
			npcHandler:say("The sewers need repair. You in?", cid)
			npcHandler.topic[playerId] = 2
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) < 22 then
			npcHandler:say("Elliott's keeps calling it that. It's just another job! You fixed some broken pipes and stuff? Let me check, {ok}?", cid)
			npcHandler.topic[playerId] = 3
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 22 then
			npcHandler:say("If you want to redo this task just say {abandoned sewers} to repeat it.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Good. Broken pipe and generator pieces, there's smoke evading. That's how you recognise them. See how you can fix them using your hands. Need about, oh, twenty of them at least repaired. Report to me or Jacob", cid)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 1)
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Door) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Door, 1)
			end
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.QuestLine, 1)
			end
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "ok") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say("Good. Thanks, man. That's one vote you got for helping us with this.", cid)
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 22)
			local currentVotingPoints = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints)
			if currentVotingPoints == -1 then
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, 1)
			else
				player:setStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints, currentVotingPoints + 1)
			end
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "report") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission05) == 1 then
			if npcHandler.topic[playerId] == 7 then
				npcHandler:say({
					"A sacrificial site? Damn, sounds like some freakish cult or something. Just great. And this ancient structure you talked about that's not part of the sewers? You'd better see the local historian about that, man. ...",
					"He can make more sense of what you found there. His name is Barazbaz. He should be in the magistrate building.",
				}, cid)
				player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission06, 1) -- Start mission 6
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You already reported this mission, go to the next.", cid)
			end
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "<nods> Hi.")
npcHandler:setMessage(MESSAGE_FAREWELL, "<nods> See ya.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
