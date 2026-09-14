local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Are you sure you want to go there? '})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Wait.. okay then.', reset = true})
end

addTravelKeyword('port hope', 0, Position(32883, 32527, 11))
addTravelKeyword('edron', 0, Position(33231, 31762, 2))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32952, 32031, 6), Position(32955, 32031, 6), Position(32957, 32032, 6)}})

-- Basic
keywordHandler:addKeyword({'secret'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you wish to go? to {Edron}, {Port Hope}?'})
keywordHandler:addKeyword({'secrets'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you wish to go? to {Edron}, {Port Hope}?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am miss Penny, your secretary."})
keywordHandler:addKeyword({'penny'}, StdModule.say, {npcHandler = npcHandler, text = "Yep, Penny's my name. You seem to be as smart as you're talkative."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I'm a secretary. I'm organising all those papers and your mail."})
keywordHandler:addKeyword({'criminal'}, StdModule.say, {npcHandler = npcHandler, text = "<Sigh> It's an evil world, isn't it?"})
keywordHandler:addKeyword({'record'}, StdModule.say, {npcHandler = npcHandler, text = "<Sigh> It's an evil world, isn't it?"})
keywordHandler:addKeyword({'paper'}, StdModule.say, {npcHandler = npcHandler, text = "<Sigh> It's an evil world, isn't it?"})
keywordHandler:addKeyword({'mail'}, StdModule.say, {npcHandler = npcHandler, text = "You can get a letter from me."})
keywordHandler:addKeyword({'?'}, StdModule.say, {npcHandler = npcHandler, text = "Don't stare at me."})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome home |PLAYERNAME|. Do you want to travel to a {secret}?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, and may Justice be with you!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Wait... will you take me a diamond when you come back?')

npcHandler:addModule(FocusModule:new())
