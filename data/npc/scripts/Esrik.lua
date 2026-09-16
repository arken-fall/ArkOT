local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local tomes = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge
-- On buy npc shop message
-- On sell npc shop message
-- On check npc shop message (look item)
npcHandler:setMessage(MESSAGE_GREET, "Hello, |PLAYERNAME| and welcome to my little forge.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")

npcHandler:addModule(FocusModule:new())
