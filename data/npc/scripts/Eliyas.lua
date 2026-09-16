local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "need" }, StdModule.say, { npcHandler = npcHandler, text = "I am a jeweller. Maybe you want to have a look at my wonderful {offers}." })
keywordHandler:addKeyword({ "offers" }, StdModule.say, { npcHandler = npcHandler, text = "Well, I sell gems and {goblets}. If you'd like to see my offers, ask me for a {trade}." })
keywordHandler:addKeyword({ "goblets" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, our newest import! We have golden goblets, silver goblets and bronze goblets. All of them have space for a hand-written dedication." })

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, |PLAYERNAME|. Which of my fine gems do you {need}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings and good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Daraman's blessings and good bye.")

-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
