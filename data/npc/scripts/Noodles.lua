local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Grrrrrrr.'},
	{text = '<wiggles>'},
	{text = '<sniff>'},
	{text = 'Woof! Woof!'},
	{text = 'Wooof!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "banana skin") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 7 then
			if player:getItemCount(3104) > 0 then
				npcHandler:say("<sniff><sniff>", cid)
				npcHandler.topic[playerId] = 1
			end
		end
	elseif msgcontains(msg, "dirty fur") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 8 then
			if player:getItemCount(3105) > 0 then
				npcHandler:say("<sniff><sniff>", cid)
				npcHandler.topic[playerId] = 2
			end
		end
	elseif msgcontains(msg, "mouldy cheese") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 9 then
			if player:getItemCount(3120) > 0 then
				npcHandler:say("<sniff><sniff>", cid)
				npcHandler.topic[playerId] = 3
			end
		end
	elseif msgcontains(msg, "like") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Woof!", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 8)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say("Woof!", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 9)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say("Meeep! Grrrrr! <spits>", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 10)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "<sniff> Woof! <sniff>")
npcHandler:setMessage(MESSAGE_FAREWELL, "Woof! <wiggle>")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Woof! <wiggle>")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "sniff banana" }, StdModule.say, { npcHandler = npcHandler, text = "Woof!" })
keywordHandler:addKeyword({ "sniff cheese" }, StdModule.say, { npcHandler = npcHandler, text = "Woof!" })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "Wooooof! <wiggle> <wiggle> <wiggle>" })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "Meeep! Meeep!" })
keywordHandler:addKeyword({ "sniff fur" }, StdModule.say, { npcHandler = npcHandler, text = "Woof!" })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "Wooooof! <wiggle> <wiggle> <wiggle>" })
keywordHandler:addKeyword({ "kingsday" }, StdModule.say, { npcHandler = npcHandler, text = "Wooooof!" })
keywordHandler:addKeyword({ "eloise" }, StdModule.say, { npcHandler = npcHandler, text = "GRRRRRRR! WOOOOOOF! WOOOOOF! WOOOOOF!" })
keywordHandler:addKeyword({ "queen" }, StdModule.say, { npcHandler = npcHandler, text = "GRRRRRRR! WOOOOOOF! WOOOOOF! WOOOOOF!" })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Wooooof! <wiggle> <wiggle> <wiggle>" })
keywordHandler:addKeyword({ "cat" }, StdModule.say, { npcHandler = npcHandler, text = "GRRRRRRR! WOOOOOOF! WOOOOOF! WOOOOOF!" })
keywordHandler:addKeyword({ "go" }, StdModule.say, { npcHandler = npcHandler, text = "Woof! Woof!" })

npcHandler:addModule(FocusModule:new())
