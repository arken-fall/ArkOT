local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	if not player then
		return false
	end
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local theLostBrotherStorage = player:getStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest)
	if msgcontains(msg, "mission") then
		if theLostBrotherStorage < 1 then
			npcHandler:say({
				"My brother is missing. I fear, he went to this evil palace north of here. A place of great beauty, certainly filled with riches and luxury. But in truth it is a threshold to hell and demonesses are after his blood. ...",
				"He is my brother, and I am deeply ashamed to admit but I don't dare to go there. Perhaps your heart is more courageous than mine. Would you go to see this place and search for my brother?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif theLostBrotherStorage == 1 then
			npcHandler:say("I hope you will find my brother.", cid)
			npcHandler.topic[playerId] = 0
		elseif theLostBrotherStorage == 2 then
			npcHandler:say({
				"So, he is dead as I feared. I warned him not to go with this woman, but he gave in to temptation. My heart darkens and moans. But you have my sincere thanks. ...",
				"Without your help I would have stayed in the dark about his fate. Please, take this as a little recompense.",
			}, cid)
			player:addItem(3039, 1)
			player:addExperience(3000, true)
			player:setStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest, 3)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 1 then
		if msgcontains(msg, "yes") then
			npcHandler:say("I thank you! This is more than I could hope!", cid)
			if theLostBrotherStorage < 1 then
				player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.QuestLine, 1)
			end
			player:setStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest, 1)
		elseif msgcontains(msg, "no") then
			npcHandler:say("As you wish.", cid)
		end
		npcHandler.topic[playerId] = 0
	end

	return true
end

local function onTradeRequest(cid)
	local player = Player(cid)
	if not player then
		return false
	end
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest) ~= 3 then
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just have a look.")
npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")

npcHandler:addModule(FocusModule:new())
