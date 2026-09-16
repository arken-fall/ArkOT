local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- local function creatureSayCallback(npc, creature, type, message)
-- 	local player = Player(creature)
-- 	local playerId = player:getId()
-- 
-- 	if not npcHandler:checkInteraction(npc, creature) then
-- 		return false
-- 	end
-- 
-- 	if MsgContains(message, "cigar") then
-- 		npcHandler:say("Oh my. Have you gotten an exquisite cigar for me, my young friend?", npc, creature)
-- 		npcHandler:setTopic(playerId, 1)
-- 	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
-- 		local player = Player(creature)
-- 		if not player:removeItem(141, 1) then
-- 			npcHandler:setTopic(playerId, 0)
-- 			return true
-- 		end
-- 
-- 		player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Cigar, 1)
-- 		npc:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
-- 		npcHandler:say({
-- 			"Ah what a fine blend. I really ...",
-- 			"OUCH! What have you done you fool? How dare you???",
-- 		}, npc, creature)
-- 		npcHandler:setTopic(playerId, 0)
-- 	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
-- 		npcHandler:say("Oh, then there must be a misunderstanding.", npc, creature)
-- 		npcHandler:setTopic(playerId, 0)
-- 	end
-- 
-- 	return true
-- end

-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
