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

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "help") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 1 then
			npcHandler:say("I guess I could do this, yes. But I have to impose a condition. If you bring me ten sphinx feathers I will steal this ring for you.", cid)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 2)
		end
	elseif msgcontains(msg, "feathers") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 2 then
			if player:getItemById(31437, 10) then
				npcHandler:say("Thank you! They look so pretty, I'm very pleased. Agreed, now I will steal the ring from the Ambassador of Rathleton. Just be patient, I have to wait for a good moment.", cid)
				player:removeItem(31437, 10)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 3)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.MoeTimer, os.time() + 60 * 60)
			else
				npcHandler:say("If you bring me ten sphinx feathers, I will steal this ring for you.", cid)
			end
		else
			npcHandler:say("You already delivered the feathers. Be patient while I steal the ring.", cid)
		end
	elseif msgcontains(msg, "ring") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 3 then
			local timeLeft = player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.MoeTimer) - os.time()
			if timeLeft <= 0 then
				npcHandler:say("You're arriving at the right time. I have the ring you asked for. It was not too difficult. I just had to wait until the Ambassador left his residence and then I climbed in through the window. Here it is.", cid)
				player:addItem(31306, 1)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 4)
			else
				npcHandler:say("I will steal it, promised. I'm just waiting for a good moment.", cid)
			end
		elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 1 then
			npcHandler:say("I guess I could do this, yes. But I have to impose a condition. If you bring me ten sphinx feathers I will steal this ring for you.", cid)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 2)
		else
			npcHandler:say("You don't need this ring anymore.", cid)
		end
	elseif msgcontains(msg, "lyre") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre) == 1 then
			npcHandler:say("I'm upset to accuse myself, the lyre is hidden in a tomb west of Kilmaresh.", cid)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre, 2)
		else
			npcHandler:say("You already know about the lyre's location.", cid)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller. It seems, you're a {guest} here, just like me.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
