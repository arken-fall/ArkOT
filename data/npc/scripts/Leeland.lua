local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	-- The New Frontier
	if msgcontains(msg, "farmine") and player:getStorageValue(TheNewFrontier.Questline) == 14 then
		if player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
			npcHandler:say("Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up. Do you want to try again?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "impress") or msgcontains(msg, "plea") and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) <= 2 and player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
		if npcHandler.topic[playerId] == 1 then
			if player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) == 1 then
				npcHandler:say("Your pathetic whimpering amuses me. For this I grant you my assistance. But listen, one day I'll ask you to return this favour. From now on, you owe me one.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 3)
			else
				npcHandler:say("Wrong Word.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.LeelandKeyword, math.random(3, 4))
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 2)
			end
		end
	elseif msgcontains(msg, "reason") or msgcontains(msg, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) > 2 and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) <= 4 and player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
		if npcHandler.topic[playerId] == 1 then
			if msgcontains(msg, "reason") and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) == 3 then
				npcHandler:say("The idea of a promising market and new resources suits us quite well. I think it is reasonable to send some assistance.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 3)
			elseif msgcontains(msg, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.LeelandKeyword) == 4 then
				npcHandler:say("Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 3)
			else
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 2)
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			if player:getStorageValue(TheNewFrontier.Questline) == 14 and player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 2 and player:removeItem(10028, 1) then
				npcHandler:say("Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Leeland, 1)
				npcHandler.topic[playerId] = 1
			end
		end
	else
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and player:getStorageValue(TheNewFrontier.Mission05.Leeland) == 1 then
			npcHandler:say("Wrong Word.", cid)
			player:setStorageValue(TheNewFrontier.Mission05.Leeland, 2)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
