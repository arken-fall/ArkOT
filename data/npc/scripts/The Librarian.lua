local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'I really have to find this scroll. Where did I put it?'},
	{text = 'Too much dust here. I should tidy up on occasion.'},
	{text = 'Someone opened the Grimoire of Flames without permission. Egregious!'}
}
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:addModule(FocusModule:new())
