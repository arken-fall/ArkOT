local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local npc = Npc()
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if npcHandler.topic[playerId] == 0 then
		if msgcontains(msg, "outfit") then
			npcHandler:say({
				"I'm tired of all these young unskilled wannabe heroes. Every Tibian can show his skills or actions by wearing a special outfit. To prove oneself worthy of the demon outfit, this is how it goes: ...",
				"The base outfit will be granted for completing the annihilator quest, which isn't much of a challenge nowadays, in my opinion. Anyway ...",
				"The shield however will only be granted to those adventurers who have finished the demon helmet quest. ...",
				"Well, the helmet is for those who really are tenacious and have hunted down all 6666 demons and finished the demon oak as well. ...",
				"Are you interested?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif msgcontains(msg, "cookie") then
			if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.AvarTar) ~= 1 then
				npcHandler:say("Do you really think you could bribe a hero like me with a meagre cookie?", cid)
				npcHandler.topic[playerId] = 3
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("So you want to have the demon outfit, hah! Let's have a look first if you really deserve it. Tell me: {base}, {shield} or {helmet}?", cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 3 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.AvarTar, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say("Well, you won't! Though it looks tasty ...What the ... WHAT DO YOU THINK YOU ARE? THIS IS THE ULTIMATE INSULT! GET LOST!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(npc, cid)
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say("I see.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "base") then
			if player:getStorageValue(Storage.Quest.U7_24.TheAnnihilator.Reward) == 1 then
				player:addOutfit(541)
				player:addOutfit(542)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.U7_24.TheAnnihilator.Reward, 2)
				npcHandler:say("Receive the base outfit, |PLAYERNAME|.", cid)
			else
				npcHandler:say("You need to complete annihilator quest first, |PLAYERNAME|.", cid)
				npcHandler.topic[playerId] = 2
			end
		elseif msgcontains(msg, "shield") then
			if player:getStorageValue(Storage.Quest.U7_24.TheAnnihilator.Reward) == 2 and player:getStorageValue(Storage.Quest.U6_4.DemonHelmet.Rewards.DemonHelmet) == 1 then
				player:addOutfitAddon(541, 1)
				player:addOutfitAddon(542, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.U6_4.DemonHelmet.Rewards.DemonHelmet, 2)
				npcHandler:say("Receive the shield, |PLAYERNAME|.", cid)
			else
				npcHandler:say("The shield will only be granted to those adventurers who have finished the demon helmet quest, |PLAYERNAME|.", cid)
				npcHandler.topic[playerId] = 2
			end
		elseif msgcontains(msg, "helmet") then
			if player:getStorageValue(Storage.Quest.U7_24.TheAnnihilator.Reward) == 2 and player:getStorageValue(Storage.Quest.U8_2.TheDemonOak.Done) == 3 then
				player:addOutfitAddon(541, 2)
				player:addOutfitAddon(542, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.U8_2.TheDemonOak.Done, 4)
				npcHandler:say("Receive the helmet, |PLAYERNAME|.", cid)
			else
				npcHandler:say("The helmet is for those who have hunted down all 6666 demons and finished the demon oak as well, |PLAYERNAME|.", cid)
				npcHandler.topic[playerId] = 2
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you later, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you later, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
