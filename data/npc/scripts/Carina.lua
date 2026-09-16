local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "precious necklace") then
		if player:getItemCount(7940) > 0 then
			npcHandler:say("Would you like to buy my precious necklace for 5000 gold?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "mouse") then
		npcHandler:say("Wha ... What??? Are you saying you've seen a mouse here??", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			if player:removeMoneyBank(5000) then
				player:removeItem(7940, 1)
				player:addItem(7939, 1)
				npcHandler:say("Here you go kind sir.", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 2 then
			if not player:removeItem(123, 1) then
				npcHandler:say("There is no mouse here! Stop talking foolish things about serious issues!", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.ScaredCarina, 1)
			npcHandler:say("IIIEEEEEK!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Thank goodness!", cid)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|. I am looking forward to trade with you.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
