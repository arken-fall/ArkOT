local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'What a beautiful palace. The Kilmareshians are highly skilful architects.'},
	{text = 'The new treaty of amity and commerce with Kilmaresh is of utmost importance.'},
	{text = 'The pending freight from the saffron coasts is overdue.'}
}
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:addModule(FocusModule:new())
