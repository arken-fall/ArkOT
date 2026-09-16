local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'There\'s a storm brewing.'}
}
npcHandler:addModule(VoiceModule:new(voices))

local travelKeyword = keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Ye' want a passage back to cormaya? {Yes} or {no}." })
travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 400, text = "All Hand Hoy!", destination = Position(33356, 31983, 7) })
travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to serve you some time.", reset = true })

npcHandler:setMessage(MESSAGE_GREET, "Ahoy, matey! Lookin' for a {passage}, eh.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

npcHandler:addModule(FocusModule:new())
