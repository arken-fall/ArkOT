local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Don\'t enter this area if you are an inexperienced fighter! It would be your end!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Gerimor is right. As an expert for minotaurs I am researching these creatures for years. I thought I already knew a lot but the monsters in this cave are {different}. It's a big {mystery}.")
		npcHandler.topic[playerId] = 0
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.JamesfrancisTask) <= 50 and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
		npcHandler.topic[playerId] = 0
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"You say the minotaurs were controlled by a very powerful boss they worshipped. This explains why they had so much more power than the normal ones. ...",
			"I'm very thankful. Please go to the Druid of Crunor and tell him what you've seen. He might be interested in that.",
		})
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission, 5)
		npcHandler.topic[playerId] = 0
	end

	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mystery") then
		npcHandler:say("The minotaurs I faced in the cave are much stronger than the normal ones. What I were able to see before I had to flee: all of them seem to belong to a cult worshipping their god. Could you do me a {favour}?", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "favour") and npcHandler.topic[playerId] == 2 then
		npcHandler:say("I'd like to work in this cave researching the minotaurs. But right now there are too many of hem and what is more, they are too powerful for me. Could you enter the cave and kill at least 50 of these creatures?", cid)
		npcHandler.topic[playerId] = 3
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.JamesfrancisTask) >= 50 then
			npcHandler:say("Great job! You have killed at least 50 of these monsters. I give this key to you to open the door to the inner area. Go there and find out what's going on.", cid)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission, 3)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.BossAccessDoor, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Come back when you have killed enough minotaurs.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 3 then
		npcHandler:say("Very nice. Return to me if you've finished your job.", cid)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission, 2)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.JamesfrancisTask, 0)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.AccessDoor, 1)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
