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

	if msgcontains(msg, "sam sent me") or msgcontains(msg, "sam send me") then
		if player:getStorageValue(Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc) == 1 then
			npcHandler:say({
				"Oh, so its you, he wrote me about? Sadly I have no dwarven armor in stock. But I give you the permission to retrive one from the mines. ...",
				"The problem is, some giant spiders made the tunnels where the storage is their new home. Good luck.",
			}, cid)
			player:setStorageValue(Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc, 2)
			player:setStorageValue(Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackDoor, 1)
		end
	elseif msg == "lokurs measurements" then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) >= 7 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.MeasurementsKroox) ~= 1 then
			npcHandler:say("Hm, well I guess its ok to tell you ... <tells you about Lokurs measurements> ", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07, player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) + 1)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.MeasurementsKroox, 1)
		else
			npcHandler:say("...", cid)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Kroox Quality Armor, |PLAYERNAME|! Wanna take a look, ask me for a trade.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
