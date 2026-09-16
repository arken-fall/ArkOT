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
		npcHandler:setMessage(MESSAGE_GREET, "Hello, my name is Saideh. Once this was the entry to the crypt of our heroes. One of the graves belongs to our beloved hero Dayyan. Nowadays it is not a good idea to visit this place.")
		npcHandler.topic[playerId] = 1
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains) == 1 then
			npcHandler:say({ " I would like you to visit the grave of our beloved hero Dayyan. His remains have to be reburied, because a horde of ogres controls this place. Do you want to start this holy mission?" }, cid)
			npcHandler.topic[playerId] = 1
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains) == 1 then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains) == 1 then
			npcHandler:say({ "Well, I appreciate that. Good luck!" }, cid)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains, 2)
			npcHandler.topic[playerId] = 2
			npcHandler.topic[playerId] = 2
		else
			npcHandler:say({ "Sorry." }, cid)
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
