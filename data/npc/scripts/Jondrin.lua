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

	if msgcontains(msg, "necrometer") and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission09) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission10) < 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission09) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.OramondTaskProbing) == 1 then
		npcHandler:say({
			"A necrometer? Have you any idea how rare and expensive a necrometer is? There is no way I could justify giving a necrometer to an inexperienced adventurer. Hm, although ... if you weren't inexperienced that would be a different matter. ...",
			"Did you do any measuring task for Doubleday lately?",
		}, cid)
		npcHandler.topic[playerId] = 1
	elseif player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission10) >= 1 then
		npcHandler:say("You already got the Necrometer.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("Indeed I heard you did a good job out there. <sigh> I guess that means I can hand you one of our necrometers. Handle it with care.", cid)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission10, 1)
		player:addItem(21124, 1)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
