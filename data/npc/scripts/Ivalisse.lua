local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "silus" }, StdModule.say, { npcHandler = npcHandler, text = "My {father}, can you tell me if he's alright?" })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "Alright then, you are very welcome to explore the temple!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Ivalisse." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "There is always time to make a change." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Besides my various {duties} in the temple, I also take care of visitors. Well, I would but right now I can't get my mind of how my {father}'s doing. I am sorry." })
keywordHandler:addKeyword({ "duties" }, StdModule.say, { npcHandler = npcHandler, text = " I help linking the portals of this temple to other ancient sites of the {Astral Shapers}." })
keywordHandler:addKeyword({ "duties" }, StdModule.say, { npcHandler = npcHandler, text = " I help linking the portals of this temple to other ancient sites of the {Astral Shapers}." })

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "astral shapers" }, StdModule.say, { npcHandler = npcHandler, text = "As far as we know today, the Astral Shapers are an ancient, very advanced race of master artisans." })
keywordHandler:addKeyword({ "rumours" }, StdModule.say, { npcHandler = npcHandler, text = "I hope he's alright... ah, nevermind." })
keywordHandler:addKeyword({ "chalice" }, StdModule.say, { npcHandler = npcHandler, text = "I don't really know what you're talking about, sorry." })

npcHandler:addModule(FocusModule:new())
