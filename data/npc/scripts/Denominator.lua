local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local playerLastResp = {}

local function greetCallback(cid)
	local playerId = cid:getId()

	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 13 then
		npcHandler:setMessage(MESSAGE_GREET, "Enter answers for the following {questions}:")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
	end
	return true
end

local quiz1 = {
	[1] = {
		p = "The sum of the first and second digit?",
		r = function(player)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone1) + player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone2))
			return player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer)
		end,
	},
	[2] = {
		p = "The sum of the second and third digit?",
		r = function(player)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone2) + player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone3))
			return player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer)
		end,
	},
	[3] = {
		p = "The sum of the first and third digit?",
		r = function(player)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone1) + player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone3))
			return player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer)
		end,
	},
	[4] = {
		p = "The total digit sum?",
		r = function(player)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone1) + player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone2) + player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone3))
			return player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer)
		end,
	},
}

local quiz2 = {
	[1] = {
		p = "Is the number prime?",
		r = function(player)
			local stg = player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer)
			if stg < 1 then
				return 0
			end
			if stg == 1 or stg == 2 then
				return 1
			end
			local incr = 0
			for i = 1, stg do
				if stg % i == 0 then
					incr = incr + 1
				end
			end
			return (incr == 2 and 1 or 0)
		end,
	},
	[2] = {
		p = "Does the number belong to a twin prime?",
		r = function(player)
			local stg = player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer)
			if stg < 2 then
				return 0
			end
			if stg == 1 or stg == 2 then
				return 1
			end
			local incr = 0
			for i = 1, stg do
				if stg % i == 0 then
					incr = incr + 1
				end
			end
			return (incr == 2 and 1 or 0)
		end,
	},
}

local quiz3 = {
	[1] = {
		p = "Is the number divisible by 3?",
		r = function(player)
			return (player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer) % 3 == 0 and 1 or 0)
		end,
	},
	[2] = {
		p = "Is the number divisible by 2?",
		r = function(player)
			return (player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Answer) % 2 == 0 and 1 or 0)
		end,
	},
}

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Quest started
	if msgcontains(msg, "questions") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 13 then
		npcHandler:say("Ready to {start}?", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "start") and npcHandler.topic[playerId] == 2 then
		local questionId = math.random(#quiz1)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId, questionId)
		npcHandler:say(quiz1[questionId].p, cid)
		npcHandler.topic[playerId] = 3
	elseif npcHandler.topic[playerId] == 3 then
		npcHandler:say(string.format("Your answer is %s, do you want to continue?", msg), cid)
		playerLastResp[playerId] = tonumber(msg)
		npcHandler.topic[playerId] = 4
	elseif npcHandler.topic[playerId] == 4 then
		if msgcontains(msg, "yes") then
			local answer = quiz1[player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId)].r
			if playerLastResp[playerId] ~= (tonumber(answer(player))) then
				npcHandler:say("Wrong. SHUT DOWN.", cid)
				npcHandler:resetNpc(npc, cid)
				npcHandler:releaseFocus(cid)
				return false
			else
				npcHandler:say("Correct. {Next} question?", cid)
				npcHandler.topic[playerId] = 5
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("SHUT DOWN.", cid)
			npcHandler:resetNpc(npc, cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif msgcontains(msg, "next") and npcHandler.topic[playerId] == 5 then
		local questionId = math.random(#quiz2)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId, questionId)
		npcHandler:say(quiz2[questionId].p, cid)
		npcHandler.topic[playerId] = 6
	elseif npcHandler.topic[playerId] == 6 then
		local response = 0
		if msgcontains(msg, "no") then
			response = 0
		elseif msgcontains(msg, "yes") then
			response = 1
		end
		local answer = quiz2[player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId)].r
		if response == answer(player) then
			npcHandler:say("Correct. {Next} question?", cid)
			npcHandler.topic[playerId] = 7
		else
			npcHandler:say("Wrong. SHUT DOWN.", cid)
			npcHandler:resetNpc(npc, cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif npcHandler.topic[playerId] == 7 and msgcontains(msg, "next") then
		local questionId = math.random(#quiz3)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId, questionId)
		npcHandler:say(quiz3[questionId].p, cid)
		npcHandler.topic[playerId] = 8
	elseif npcHandler.topic[playerId] == 8 then
		local response = 0
		if msgcontains(msg, "no") then
			response = 0
		elseif msgcontains(msg, "yes") then
			response = 1
		end
		local answer = quiz3[player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId)].r
		if response == answer(player) then
			npcHandler:say("Correct. {Last} question?", cid)
			npcHandler.topic[playerId] = 9
		else
			npcHandler:say("Wrong. SHUT DOWN.", cid)
			npcHandler:resetNpc(npc, cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif npcHandler.topic[playerId] == 9 and msgcontains(msg, "last") then
		npcHandler:say("Tell me the correct number?", cid)
		npcHandler.topic[playerId] = 10
	elseif npcHandler.topic[playerId] == 10 then
		npcHandler:say(string.format("Your answer is %s, do you want to continue?", msg), cid)
		playerLastResp[playerId] = tonumber(msg)
		npcHandler.topic[playerId] = 11
	elseif npcHandler.topic[playerId] == 11 then
		if msgcontains(msg, "yes") then
			local correct = string.format("%d%d%d", player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone1), player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone2), player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone3))
			if tonumber(playerLastResp[playerId]) ~= (tonumber(correct)) then
				npcHandler:say("Wrong. SHUT DOWN.", cid)
				npcHandler:resetNpc(npc, cid)
				npcHandler:releaseFocus(cid)
				return false
			else
				npcHandler:say("Correct. The lower door is now open. The druid of Crunor lies.", cid)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) + 1)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorDenominator)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("SHUT DOWN.", cid)
			npcHandler:resetNpc(npc, cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
