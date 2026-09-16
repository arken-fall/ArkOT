local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Feel the wind in your hair during one of my carpet rides!'}
}
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function addTravelKeyword(keyword, text, cost, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Never heard about a place like this." }, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you seek a ride to " .. text .. " for |TRAVELCOST|?", cost = cost, discount = "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, text = "Hold on!", cost = cost, discount = "postman", destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true })
end

addTravelKeyword("farmine", "Do you seek a ride to Farmine for |TRAVELCOST|?", 60, Position(32983, 31539, 1), function(player)
	return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2
end)
addTravelKeyword("zao", "Do you seek a ride to Farmine for |TRAVELCOST|?", 60, Position(32983, 31539, 1), function(player)
	return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2
end)
addTravelKeyword("darashia", "Darashia on Darama", 40, Position(33270, 32441, 6))
addTravelKeyword("darama", "Darashia on Darama", 40, Position(33270, 32441, 6))
addTravelKeyword("kazordoon", "Kazordoon", 70, Position(32588, 31941, 0))
addTravelKeyword("kazor", "Kazordoon", 70, Position(32588, 31941, 0))
addTravelKeyword("femor hills", "the Femor Hills", 60, Position(32536, 31837, 4))
addTravelKeyword("hills", "the Femor Hills", 60, Position(32536, 31837, 4))
addTravelKeyword("svargrond", "Svargrond", 60, Position(32253, 31097, 4))
addTravelKeyword("issavi", "Issavi", 100, Position(33957, 31515, 0))
addTravelKeyword("marapur", "Marapur", 70, Position(33805, 32767, 2))

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller |PLAYERNAME|. Where do you want me to {fly} you?")
keywordHandler:addKeyword({ "fly" }, StdModule.say, { npcHandler = npcHandler, text = "I can fly you to {Darashia}, {Issavi}, {Svargrond}, {Kazordoon}, {Zao}, {Femor Hills} or to {Marapur} if you like. Where do you want to go?" })
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye!")

npcHandler:addModule(FocusModule:new())
