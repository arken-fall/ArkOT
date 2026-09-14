local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

-- Travel
local travelNode = keywordHandler:addKeyword({'daram'}, StdModule.say, {npcHandler = npcHandler, text = 'Give me |TRAVELCOST| and I bring you to Daram Island. Alright?', cost = 2400, discount = 'postman'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, cost = 2400, discount = 'postman', destination = Position(31226, 31977, 6) })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Alright.'})

-- Travel
local travelNode = keywordHandler:addKeyword({'daram island'}, StdModule.say, {npcHandler = npcHandler, text = 'Give me |TRAVELCOST| and I bring you to Daram Island. Alright?', cost = 2400, discount = 'postman'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, cost = 2400, discount = 'postman', destination = Position(31226, 31977, 6) })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Alright.'})	
	
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
