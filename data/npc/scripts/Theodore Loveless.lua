local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local npc = Npc()
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "cigar") then
		npcHandler:say("Oh my. Have you gotten an exquisite cigar for me, my young friend?", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 then
		local player = Player(cid)
		if not player:removeItem(141, 1) then
			npcHandler.topic[playerId] = 0
			return true
		end

		player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Cigar, 1)
		npc:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
		npcHandler:say({
			"Ah what a fine blend. I really ...",
			"OUCH! What have you done you fool? How dare you???",
		}, cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("Oh, then there must be a misunderstanding.", cid)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
