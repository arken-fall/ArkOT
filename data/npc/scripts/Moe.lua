local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'The menu of the day sounds delicious!'},
	{text = 'The last visit to the theatre was quite rewarding.'},
	{text = 'Such a beautiful and wealthy city - with so many opportunities ...'}
}
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:addModule(FocusModule:new())
