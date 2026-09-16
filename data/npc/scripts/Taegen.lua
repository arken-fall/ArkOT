local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Id like to take a walk with Aurita.'},
	{text = 'I miss Aurita golden hair.*sigh*'},
	{text = 'Pas in boldly tyll thow com to an hall the feyrist undir sky ... *sings*'}
}
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:addModule(FocusModule:new())
