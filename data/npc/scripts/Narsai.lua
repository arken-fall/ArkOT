local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		npcHandler.topic[playerId] = 1
	elseif (player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.JamesfrancisTask) <= 50) and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		npcHandler.topic[playerId] = 15
	elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Mission, 5)
		npcHandler.topic[playerId] = 20
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 1 then
			npcHandler:say({ "Could you help me do a ritual?" }, cid) -- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 1 then
			player:addItem(31714, 1)
			npcHandler:say({ "Here is the list of ingredients that are missing to complete the ritual. " }, cid) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai, 2)
			npcHandler.topic[playerId] = 2
			npcHandler.topic[playerId] = 2
		else
			npcHandler:say({ "Sorry." }, cid) -- It needs to be revised, it's not the same as the global
		end
	end
	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 2 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 2 then
			npcHandler:say({ "Did you bring all the materials I informed you about?" }, cid) -- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 3
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 2 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 2 and player:getItemById(31335, 10) and player:getItemById(10279, 2) and player:getItemById(31332, 5) then
			player:removeItem(31335, 10)
			player:removeItem(10279, 2)
			player:removeItem(31332, 5)
			npcHandler:say({ "Thank you this stage of the ritual is complete." }, cid) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai, 3)
			npcHandler.topic[playerId] = 4
			npcHandler.topic[playerId] = 4
		else
			npcHandler:say({ "Sorry." }, cid) -- It needs to be revised, it's not the same as the global
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
