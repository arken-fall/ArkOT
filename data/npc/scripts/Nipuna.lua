local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'I\'m selling magic equipment. Come and have a look.'},
	{text = 'If you need runes, this is the market stall for you!'}
}
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:addModule(FocusModule:new())
