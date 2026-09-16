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
	if msgcontains(msg, "want") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission01) == 1 then
			npcHandler.topic[playerId] = 1
		end
		npcHandler:say("The guys from the magistrate sent you here, didn't they?", cid)
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Thought so. You'll have to talk to the king though. The beggar king that is. The king does not grant an audience to just everyone. You know how those kings are, don't you? ... ",
				"However, to get an audience with the king, you'll have to help his subjects a bit. ... ",
				"His subjects that would be us, the poor, you know? ... ",
				"So why don't you show your dedication to the poor? Go and help Chavis at the poor house. He's collecting food for people like us. ... ",
				"If you brought enough of the stuff you'll see that the king will grant you entrance in his {palace}.",
			}, cid, 100)
			npcHandler.topic[playerId] = 0
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission01, 2) -- Mission 1 end
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission02, 1) -- Mission 2 start
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi! What is it, what d'ye {want}?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
