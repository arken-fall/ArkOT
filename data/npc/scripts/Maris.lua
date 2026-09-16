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
		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Maris) < 0 then
			npcHandler:say("The good thing about cookies is that they last for a long time. So they are well suited for a boat trip. I'll take some of those, okay?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("It'd be better for you to leave now.", cid)
		end
	elseif msg == "yes" then
		if npcHandler.topic[playerId] == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Let's try that stuff first - ARRRRRRHH! <coughs> That must have been the worst cookie I've ever eaten. Get off my ship.", cid)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Maris, 1)
			npcHandler.topic[playerId] = 0
		end
	end
end
-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you want go to the " .. keyword:titleCase() .. " for |TRAVELCOST|?", cost = cost })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = cost, destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "Alright then!", reset = true })
end

addTravelKeyword("fenrock", 100, Position(32563, 31313, 7))
addTravelKeyword("mistrock", 100, Position(32640, 31439, 7))

-- Basic
keywordHandler:addKeyword({ "offer" }, StdModule.say, { npcHandler = npcHandler, text = "I can take you to {Fenrock} and {Mistrock}!" })
keywordHandler:addAliasKeyword({ "passage" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am Maris, Captain of this ship." })
keywordHandler:addAliasKeyword({ "captain" })
keywordHandler:addKeyword({ "alori mort" }, StdModule.say, { npcHandler = npcHandler, text = "Stop mumbling and don't bug me." }, function(player)
	return player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 1
end)

npcHandler:setMessage(MESSAGE_GREET, "I hope you have a good reason to step near my {ship}, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, bye or whatever.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
