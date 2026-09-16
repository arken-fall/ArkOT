local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid
	if msg == "cookie" then
		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Armenius) < 0 then
			npcHandler:say("What kind of strange offer is this? You're actually offering me a cookie?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("It'd be better for you to leave now.", cid)
		end
	elseif msg == "yes" then
		if npcHandler.topic[playerId] == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Errrkss - coughcough - what the - heck did you put in there? Get out of my sight!", cid)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Armenius, 1)
			npcHandler.topic[playerId] = 0
		end
	elseif msg:lower() == "alori mort" and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 1 then
		if npcHandler.topic[playerId] == 2 then
			local rand = math.random(2)
			npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh, the nerve. Go to the rats which raised you.")
			player:teleportTo(Position(32759, 31241, 9))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03, 2)
		else
			npcHandler:say("Oh, the nerve. Sod off.", cid)
			npcHandler.topic[playerId] = 2
		end
	end
end
-- Basic

npcHandler:setMessage(MESSAGE_GREET, "Ah, an adventurer. Be greeted and have a seat. How may I {serve} you?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
