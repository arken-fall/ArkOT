local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
-- local function greetCallback(npc, creature, message)
-- 	local player = Player(creature)
-- 
-- 	if player:getStorageValue(HiddenThreats.CorymRescued06) < 0 then
-- 		npcHandler:setMessage(MESSAGE_GREET, {
-- 			"Every man is the architect of his own fortune. I want to see the daylight again! Just smell fresh air.",
-- 		})
-- 		player:setStorageValue(HiddenThreats.CorymRescueMission, player:getStorageValue(HiddenThreats.CorymRescueMission) + 1)
-- 		player:setStorageValue(HiddenThreats.CorymRescued06, 1)
-- 	else
-- 		npcHandler:setMessage(MESSAGE_GREET, "Every man is the architect of his own fortune. I want to see the daylight again! Just smell fresh air.")
-- 	end
-- 	return true
-- end

local function creatureSayCallback(cid, type, msg)
	--local player = Player(cid)

	if not npcHandler:isFocused(cid) then
		return false
	end
	return true
end

-- Greeting message
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")

-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
