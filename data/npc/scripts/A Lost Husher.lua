local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

if not UNDERCOVER_CONTACTED then
	UNDERCOVER_CONTACTED = {}
end







-- local function greetCallback(npc, creature)
-- 	local player = Player(creature)
-- 	local SPIKE_STORAGE = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main)
-- 
-- 	if table.contains({ -1, 3 }, SPIKE_STORAGE) then
-- 		npcHandler:setMessage(MESSAGE_GREET, "Pssst! Keep it down! <gives you an elaborate report on monster activity>")
-- 		return true
-- 	end
-- 
-- 	if not UNDERCOVER_CONTACTED[player:getGuid()] then
-- 		UNDERCOVER_CONTACTED[player:getGuid()] = {}
-- 	end
-- 
-- 	if table.contains(UNDERCOVER_CONTACTED[player:getGuid()], npc:getId()) then
-- 		npcHandler:setMessage(MESSAGE_GREET, "Pssst! Keep it down! <gives you an elaborate report on monster activity>")
-- 		return true
-- 	end
-- 
-- 	player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Undercover_Main, SPIKE_STORAGE + 1)
-- 	table.insert(UNDERCOVER_CONTACTED[player:getGuid()], npc:getId())
-- 	npcHandler:removeInteraction(npc, creature)
-- 	npcHandler:setMessage(MESSAGE_GREET, "Pssst! Keep it down! <gives you an elaborate report on monster activity>")
-- 	return true
-- end

-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
