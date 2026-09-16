local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "times" }, StdModule.say, { npcHandler = npcHandler, text = "Times have changed <sigh>. In the past dragons were feared and respected. Only the {demons} rivalled our notoriety." })
keywordHandler:addKeyword({ "demons" }, StdModule.say, { npcHandler = npcHandler, text = "Those upstarts! I wonder why would anyone care about them. They lack our style. For them it is all about brute force and showing-off." })
keywordHandler:addKeyword({ "style" }, StdModule.say, { npcHandler = npcHandler, text = "Breathing fire is an art! Instead of setting everything on fire, you exhale a cone of fire to give a worthy opponent a chance to avoid it." })
keywordHandler:addKeyword({ "humans" }, StdModule.say, { npcHandler = npcHandler, text = "Your lives are so short and meaningless and yet you are here! And as a race you even have your own history and remember things with the help of {books}, which amazes me." })
keywordHandler:addKeyword({ "concept" }, StdModule.say, { npcHandler = npcHandler, text = "I like the idea of books so much that I acquired a human servant to record my memoirs. You find a copy somewhere in my lair." })
keywordHandler:addKeyword({ "lava" }, StdModule.say, { npcHandler = npcHandler, text = "Lava is only fun as long as it doesn't harden - then it turns into an annoyance." })

-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
