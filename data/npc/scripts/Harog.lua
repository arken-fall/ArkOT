local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

npcHandler:setMessage(MESSAGE_GREET, "Hello.")
npcHandler:setMessage(MESSAGE_FAREWELL, "It was a pleasure to help you, |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_SENDTRADE, "Keep in mind you won't find better offers here. Just browse through my wares.")

npcHandler:addModule(FocusModule:new())
