local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "caves" }, StdModule.say, { npcHandler = npcHandler, text = "I'd go by myself and tear that beast's heart out if I were younger. I hope ya can do that for me. Now go and good luck to ya!" })
keywordHandler:addKeyword({ "wares" }, StdModule.say, { npcHandler = npcHandler, text = "Ya're a coward, aren't ya? Prove that I'm wrong and get your lazy bones up to the lookout!!" })
keywordHandler:addAliasKeyword({ "go" })
keywordHandler:addKeyword({ "bait" }, StdModule.say, { npcHandler = npcHandler, text = "Just ask me for a trade if you need a bait." })
keywordHandler:addKeyword({ "test" }, StdModule.say, { npcHandler = npcHandler, text = "I can give ya a challenge to test if ya have the guts to be a real sailor. Go up to the lookout and remain there for 24 hours during a storm! Harharhar!" })

npcHandler:setMessage(MESSAGE_SENDTRADE, "Here ya go! Use it on the crane when you see the monster. Then refill it every time you use the telescope.")
-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
