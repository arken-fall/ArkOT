local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is now known only to the wind and it shall remain like this until I will return to my kin." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I was a guardian of this glade. I am the last one... everyone had to leave." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "This glade's time is growing short if nothing will be done soon." })
keywordHandler:addKeyword({ "forest fury" }, StdModule.say, { npcHandler = npcHandler, text = "Take care, guardian." })
keywordHandler:addKeyword({ "orclops" }, StdModule.say, { npcHandler = npcHandler, text = "Cruel beings. Large and monstrous, with a single eye, staring at their prey. " })

npcHandler:addModule(FocusModule:new())
