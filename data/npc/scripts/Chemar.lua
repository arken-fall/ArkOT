local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Ask me if you need letters or parcels. I\'ll deliver them via airmail, of course!'},
	{text = 'Feel the wind in your hair during one of my carpet rides!'}
}
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function addTravelKeyword(keyword, text, cost, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Never heard about a place like this." }, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you seek a ride to " .. keyword:titleCase() .. " for |TRAVELCOST|?", cost = cost, discount = "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, text = "Hold on!", cost = cost, discount = "postman", destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true })
end

addTravelKeyword("farmine", "Do you seek a ride to Farmine for |TRAVELCOST|?", 60, Position(32983, 31539, 1), function(player)
	return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2
end)
addTravelKeyword("zao", "Do you seek a ride to Farmine for |TRAVELCOST|?", 60, Position(32983, 31539, 1), function(player)
	return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2
end)
addTravelKeyword("edron", "", 60, Position(33193, 31784, 3))
addTravelKeyword("svargrond", "", 60, Position(32253, 31097, 4))
addTravelKeyword("femor hills", "", 60, Position(32536, 31837, 4))
keywordHandler:addAliasKeyword({ "hills" })
addTravelKeyword("kazordoon", "", 80, Position(32588, 31941, 0))
keywordHandler:addAliasKeyword({ "kazor" })
addTravelKeyword("issavi", "", 100, Position(33957, 31515, 0))
addTravelKeyword("marapur", "Marapur", 70, Position(33805, 32767, 2))

npcHandler:setMessage(MESSAGE_GREET, "Daraman's blessings, traveller |PLAYERNAME|.")
keywordHandler:addKeyword({ "fly" }, StdModule.say, { npcHandler = npcHandler, text = "I can fly you to {Edron}, {Issavi}, {Svargrond}, {Kazordoon}, {Zao}, {Femor Hills} or to {Marapur} if you like. Where do you want to go?" })
npcHandler:setMessage(MESSAGE_FAREWELL, "It was a pleasure to help you, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "It was a pleasure to help you, |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new())
