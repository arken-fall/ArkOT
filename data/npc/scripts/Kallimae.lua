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

	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 11 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 11 then
			npcHandler:say({ "Some residents are in need of ingredients to finish a ritual. You can help?" }, cid) -- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 11 then
			npcHandler:say({ "Search for the NPCs Yonan, Narsai, Shimun and Tefrit." }, cid) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Ritual, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, 12)
			npcHandler.topic[playerId] = 2
			npcHandler.topic[playerId] = 2
		else
			npcHandler:say({ "Sorry." }, cid) -- It needs to be revised, it's not the same as the global
		end
	end
	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3 then
			npcHandler:say({ "Did you help some residents with ingredients?" }, cid) -- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 3
			npcHandler.topic[playerId] = 3
		end
	elseif
		msgcontains(msg, "yes")
		and npcHandler.topic[playerId] == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3
		and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3
	then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 3 then
			npcHandler:say({ "Thanks. I need you to go to 4 places indicated by Goddess Bastesh." }, cid) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Nine.Owl, 1)
			npcHandler.topic[playerId] = 4
			npcHandler.topic[playerId] = 4
		else
			npcHandler:say({ "Sorry." }, cid) -- It needs to be revised, it's not the same as the global
		end
	end
	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 then
			npcHandler:say({ "Did you check all the points and bring the Symbol of Sun and Sea?" }, cid) -- It needs to be revised, it's not the same as the global
			npcHandler.topic[playerId] = 5
			npcHandler.topic[playerId] = 5
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 5 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin) == 1 and player:getItemById(31431, 1) then
			player:addItem(31572, 1)
			npcHandler:say({ "Thanks. Here is your reward." }, cid) -- It needs to be revised, it's not the same as the global
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Boss, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin, 2)
			npcHandler.topic[playerId] = 6
			npcHandler.topic[playerId] = 6
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
