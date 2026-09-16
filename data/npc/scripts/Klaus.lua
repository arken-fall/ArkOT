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

	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission4) == 1 then
			npcHandler:say("Hmm, you look like a seasoned seadog. Kill Captain Ray Striker, bring me his lucky pillow as a proof and you are our hero!", cid)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission4, 2)
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission4) == 3 then
			npcHandler:say("Do you have Striker's pillow?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission4) == 3 then
			if npcHandler.topic[playerId] == 1 then
				if player:removeItem(6105, 1) then
					npcHandler:say("You DID it!!! Incredible! Boys, lets have a PAAAAAARTY!!!!", cid)
					player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission4, 4)
					npcHandler.topic[playerId] = 0
				else
					npcHandler:say("Come back when you have his lucky pillow.", cid)
					npcHandler.topic[playerId] = 0
				end
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ho matey.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Whenever your throat is dry, you know where to find my tavern.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
