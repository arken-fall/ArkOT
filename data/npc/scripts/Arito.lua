local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Come in, have a drink and something to eat.'}
}
npcHandler:addModule(VoiceModule:new(voices))

-- local function greetCallback(npc, player)
-- 	if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask) == 2 then
-- 		npcHandler:setMessage(MESSAGE_GREET, "Thank god you are back!! Did you find....err...what we were talking about??")
-- 	else
-- 		npcHandler:setMessage(MESSAGE_GREET, "Be mourned, pilgrim in flesh. Be mourned in my tavern.")
-- 	end
-- 
-- 	return true
-- end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local AritosTask = player:getStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask)

	-- Check if the msg contains "nomads"
	if msgcontains(msg, "nomads") then
		if AritosTask <= 0 and player:getItemCount(7533) > 0 then
			npcHandler:say({
				"What?? My name on a deathlist which you retrieved from a nomad?? Show me!! ...",
				"Oh my god! They found me! You must help me! Please !!!! Are you willing to do that?",
			}, cid)
			npcHandler.topic[playerId] = 1
		end
		-- Check if the msg contains "yes"
	elseif msgcontains(msg, "yes") then
		local topic = npcHandler.topic[playerId]
		if topic == 1 then
			npcHandler:say({
				"Thank you thousand times! Well, I think I start telling you what I think they are after...",
				"You have to know, I was one of them before I opened that shop here. Sure they fear about their hideout being revealed by me. Please go to the north, there is a small cave in the mountains with a rock in the middle. ...",
				"If you stand in front of it, place a scimitar - which is the weapon of the nomads - left of you and make a sacrifice to the earth by pouring some water on the floor to your right. ...",
				"The entrance to their hideout will be revealed in front of you. I don't know who is in charge there right now but please tell him that I won't spoil their secret...",
				"... well, I just told you but anyway .... I won't tell it to anybody else. Now hurry up before they get here!!",
			}, cid)
			if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart) <= 0 then
				player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
			end
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask, 1)
		elseif AritosTask == 2 then
			npcHandler:say("And what did they say?? Do I have to give up everything here? Come on tell me!!", cid)
			npcHandler.topic[playerId] = 2
		end
		-- Check if the msg contains "Acquitted" and topic is 2
	elseif msgcontains(msg, "Acquitted") and npcHandler.topic[playerId] == 2 then
		npcHandler:say("These are great news!! Thank you for your help! I don't have much, but without you I wouldn't have anything so please take this as a reward.", cid)
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask, 3)
		player:addItem(3035, 100)
	end

	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Do visit us again.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do visit us again.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Sure, browse through my offers.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
--

npcHandler:addModule(FocusModule:new())
