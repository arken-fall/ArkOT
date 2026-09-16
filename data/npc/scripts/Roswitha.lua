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

	if msgcontains(msg, "Harsin") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission13) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission14) < 1 then
			npcHandler:say("I'm sorry, but Harsin no longer lives here. He ordered a local named Quandon to transport all his stuff somewhere. I don't know where he moved, but Quandon should be able to help you with this information.", cid)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission14, 1)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.DoorQuandon, 1)
			npcHandler.topic[playerId] = 0
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello, my lad. Sit down, have a drink, why don't you?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
