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

	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = text, cost = cost, discount = "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, text = "Hold on!", cost = cost, discount = "postman", destination = destination }, nil, action)
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true })
end

addTravelKeyword("passage", "Can we finally leave this cursed place?", 60, Position(32535, 31837, 4))

-- Basic
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am known as Uzon Ibn Kalith." })
keywordHandler:addKeyword({ "fly" }, StdModule.say, { npcHandler = npcHandler, text = "I transport travellers to the continent of Darama for a small fee. So many want to see the wonders of the desert and learn the secrets of Darama." })
keywordHandler:addKeyword({ "new" }, StdModule.say, { npcHandler = npcHandler, text = "I heard too many news to recall them all." })
keywordHandler:addKeyword({ "rumors" }, StdModule.say, { npcHandler = npcHandler, text = "I heard too many news to recall them all." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "It's 3:42 pm right now. The next flight is scheduled soon." })

npcHandler:setMessage(MESSAGE_GREET, "Daraman's blessings, traveller |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Daraman's blessings")

npcHandler:addModule(FocusModule:new())
