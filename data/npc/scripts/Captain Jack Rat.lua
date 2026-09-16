local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)

	if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hail, pirat! Come on board to go home! Welcome on board of the ship Flying Bat. Should I set {sail}s?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "...")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "sail") and player:getStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled) == 1 then
		npcHandler:say("There are two different routes. The dangerous one will be available once a day and it is likely that a seemonster will attack the ship once again. And a {safe} route that we can take directly there.", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "safe") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("Do you want to take the safe route?", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			cid:teleportTo(Position(33839, 31222, 5))
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
