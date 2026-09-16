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

	if msgcontains(msg, "friend") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission12) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission13) < 1 and player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints) >= 50 then
			npcHandler:say({
				"So you have proven yourself a true friend of our city. It's hard to believe but I think your words only give substance to suspicions my heart had harboured since quite a while. ...",
				"So Harsin is probably not the person he appeared to be. Actually I haven't heard from him for quite a while. He was resident in the local bed and breakfast hotel. You should be able to find him there or at least to learn about his whereabouts.",
			}, cid)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission13, 1)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "quandon") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission14) == 2 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15) < 1 then
			npcHandler:say({
				"A transporter dead? This is more then alarming. It seems Harsin is up to something and whatever it is, it's nothing good at all. But not all is lost. A local medium, Barnabas, has truly the gift to speak to the dead. ...",
				"I'll mark his home on your map. He should be able to get the information you need to locate Harsin.",
			}, cid)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Already clicked the body on the house Roswitha ?", cid)
			npcHandler.topic[playerId] = 0
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
