local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Arrrgh!'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Are you sure you want to go back? '})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Arr! see you next time!', reset = true})
end

addTravelKeyword('svargrond', 150, Position(32349, 31124, 6))

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'My job, huh? Its to sail you back.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|, Do you want to go back to {Svargrond}?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Arrr!.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Arrrr!')

npcHandler:addModule(FocusModule:new())