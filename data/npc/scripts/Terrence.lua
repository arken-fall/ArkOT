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

	if msgcontains(msg, "manway") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission17) < 1 then
			npcHandler:say("I'm not allowed to let just anyone pass. If you have proven your willingness and effort to participate in the fighting, I'm allowed to let you pass.", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("Ahhhhhhhh! ", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "effort") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("You fought hard enough against the minotaurs. Since you've shown so much effort in our war, I'll let you pass through the gate.", cid)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission17, 1)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.DoorHideout, 1)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, " Hey there, you are surely interested in helping the Rathleton city guard, right? Right - especially now since the dreaded minotaurs gain more ground every day.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
