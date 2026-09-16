local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Health potions! Mana potions! Buy them here!'},
	{text = 'All kinds of potions available here!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "ring") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.Memories) == 1 then
			npcHandler:say("So, the Librarian sent you. Well, yes, I have a vial of the hallucinogen you need. I'll give it to you for 1000 gold. Do you agree?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("I don't have anything to offer you regarding a ring.", cid)
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 then
		if player:getMoney() + player:getBankBalance() >= 1000 then
			npcHandler:say("Great. Here, take it.", cid)
			player:removeMoneyBank(1000)
			player:addItem(31350, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("You do not have enough money.", cid)
			npcHandler.topic[playerId] = 0
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, dear guest and welcome to my {potion} shop.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
