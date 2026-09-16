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
		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Lisander) < 0 then
			npcHandler:say("A cookie? Sure, is it for free?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("Whatever you have there, I think I don't want it.", cid)
		end
	elseif msg == "yes" then
		if npcHandler.topic[playerId] == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Errrkss - coughcough - what the - heck did you put in there? Get out of my sight!", cid)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Lisander, 1)
			npcHandler.topic[playerId] = 0
		end
	end
end
--Basic
keywordHandler:addKeyword({ "alori mort" }, StdModule.say, { npcHandler = npcHandler, text = "Hold your tongue." }, function(player)
	return player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 1
end)

npcHandler:setMessage(MESSAGE_GREET, "I'd rather be left in {peace}. Keep it short.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
