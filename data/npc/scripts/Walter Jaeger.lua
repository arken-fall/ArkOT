local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "moderate" }, StdModule.say, { npcHandler = npcHandler, text = "Too much of anything is always a problem. Nothing in excess! That's my motto." })
keywordHandler:addKeyword({ "falconer" }, StdModule.say, { npcHandler = npcHandler, text = "The base Falconer outfit costs 100,000 HTP, the first addon 35,000 HTP and the second addon 35,000 HTP." })
keywordHandler:addKeyword({ "antelope" }, StdModule.say, { npcHandler = npcHandler, text = "The antelope mount costs 145,000 HTP." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Walter Jaeger. Hunting is for me a necessary process to keep the creatures in Tibia in a sustainable balance. None of the creatures should gain the upper hand." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the commissioner for hunting in Tibia. It is important to keep populations of all creatures at a moderate level. That's why the prey hunting tasks are that important." })

npcHandler:addModule(FocusModule:new())
