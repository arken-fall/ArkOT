local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Alms! Alms for the poor!'},
	{text = 'Sir, Ma\'am, have a gold coin to spare?'},
	{text = 'I need help! Please help me!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local npc = Npc()
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Outfits and Addons logic
	if msgcontains(msg, "outfit") then
		if player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 6 then
			if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 157 or 153) then
				npcHandler:say("Haha, that beard is - well, not fake, but there's a trick behind it. I noticed people tend to be more generous towards a poor gramps. Want to know my trick?", cid)
				npcHandler.topic[playerId] = 1
			end
		end
	elseif msgcontains(msg, "100 ape fur") then
		npcHandler:say("Have you brought me the 100 pieces of ape fur and 20000 gold pieces?", cid)
		npcHandler.topic[playerId] = 3
	elseif msgcontains(msg, "beard") then
		if player:getSex() == PLAYERSEX_MALE then
			if player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 8 then
				npcHandler:say("Hmm, I'm not done yet with your potion. But here, let me sprinkle a few drops of my own potion on your face... there you go. Now you just have to wait.", cid)
				player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit, 9)
				player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfitTimerAddon, os.time())
			elseif player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 9 then
				local beggarOutfitTimer = player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfitTimerAddon)
				if os.time() - beggarOutfitTimer >= 432000 then -- 5 dias em segundos
					npcHandler:say("Aha! I can see it! Now that you've waited patiently without shaving, your beard is perfect! All thanks to my, err, potion. Yes. Goodbye!", cid)
					player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit, 10)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarFirstAddonDoor, 1)
					player:addOutfitAddon(153, 1)
					npcHandler.topic[playerId] = 0
				else
					npcHandler:say("Hmm, it seems you need to wait a bit longer for the potion to take full effect. Please be patient.", cid)
				end
			end
		end
	elseif msgcontains(msg, "addon") then
		if player:getSex() == PLAYERSEX_MALE and player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 9 then
			local beggarOutfitTimer = player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfitTimerAddon)
			if os.time() - beggarOutfitTimer >= 432000 then
				npcHandler:say("Aha! I can see it! Now that you've waited patiently without shaving, your beard is perfect! All thanks to my, err, potion. Yes. Goodbye!", cid)
				player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit, 10)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarFirstAddonDoor, 1)
				player:addOutfitAddon(153, 1)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("Hmm, it seems you need to wait a bit longer for the potion to take full effect. Please be patient.", cid)
			end
		end
	elseif msgcontains(msg, "gypsy dress") then
		if player:getSex() == PLAYERSEX_FEMALE then
			if player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 8 then
				npcHandler:say("Oh, I'm sorry... I almost forgot! Okay, okay... here is your promised dress. I'm sure it will look so much better on you than on me- I mean, my, err, sister.", cid)
				player:addOutfitAddon(157, 1)
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			if player:getSex() == PLAYERSEX_MALE then
				npcHandler:say({
					"I can mix a secret potion which will increase your facial hair growth enormously. I call it 'Instabeard'. However, it requires certain ingredients. ...",
					"For the small fee of 20000 gold pieces I will help you mix this potion. Just bring me 100 pieces of ape fur, which are necessary to create this potion. ...",
					"Do we have a deal?",
				}, cid)
				npcHandler.topic[playerId] = 2
			else
				npcHandler:say({
					"I can mix a secret potion which increases facial hair growth enormously. I call it 'Instabeard'. However, I fear it works only for men. ...",
					"Even if it worked on girls, I'd rather not be responsible for you ruining your pretty face. I have an idea though. If you help me brew one of these potions, I will sell something nice to you. ...",
					"I still have a pretty gypsy dress and a pearl necklace somewhere, which you could wear instead of this ragged skirt. For the small fee of 20000 gold pieces, it'd be yours. ...",
					"You only have to bring me 100 pieces of ape fur, so I can brew the potion. Do we have a deal?",
				}, cid)
				npcHandler.topic[playerId] = 2
			end
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say("Great! Come back to me once you have the 100 pieces of ape fur and I'll do my part of the deal.", cid)
			player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit, 7)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 3 then
			if player:isPremium() then
				if player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarFirstAddonDoor) == -1 then
					if player:getItemCount(5883) >= 100 and player:getMoney() + player:getBankBalance() >= 20000 then
						if player:removeItem(5883, 100) and player:removeMoneyBank(20000) then
							npcHandler:say("Ahh! Very good. I will start mixing the potion immediately. Come back later. Bye bye.", cid)
							player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit, 8)
							if player:getSex() == PLAYERSEX_MALE then
								player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfitTimerAddon, os.time())
							end
						else
							npcHandler:say("You do not have all the required items.", cid)
						end
					else
						npcHandler:say("You do not have all the required items.", cid)
					end
				else
					npcHandler:say("It seems you already have this addon, don't you try to mock me son!", cid)
				end
			end
			npcHandler.topic[playerId] = 0
		end
	end

	-- Second addon logic
	if msgcontains(msg, "addon") and player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 10 then
		npcHandler:say("No, no. Our deal is finished, no complaining now, I don't have time all day. And no, you can't have my staff.", cid)
		npcHandler.topic[playerId] = 4
	elseif msgcontains(msg, "staff") then
		if npcHandler.topic[playerId] == 4 then
			npcHandler:say("I said, no! Or well - I have a suggestion to make. Will you listen?", cid)
			npcHandler.topic[playerId] = 5
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 5 then
			npcHandler:say({
				"When I was wandering around in Tibia, I lost my favourite staff somewhere in the northern ruins in Edron. ...",
				"Uh, don't ask me what I was doing there... sort of a pilgrimage. Well anyway, if you could bring that staff back to me, I promise I'll give you my current one. ...",
				"What do you say?",
			}, cid)
			npcHandler.topic[playerId] = 6
		elseif npcHandler.topic[playerId] == 6 then
			npcHandler:say("Good! Come back to me once you have retrieved my staff. Good luck.", cid)
			player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit, 11)
			player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarFirstAddonDoor, 1)
			npcHandler.topic[playerId] = 0
		end
	end

	if msgcontains(msg, "staff") and player:getStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit) == 11 then
		npcHandler:say("Did you bring my favourite staff??", cid)
		npcHandler.topic[playerId] = 7
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 7 then
			if player:isPremium() then
				if player:getItemCount(6107) >= 1 then
					if player:removeItem(6107, 1) then
						npcHandler:say("Yes!! That's it! I'm so glad! Here, you can have my other one. Thanks!", cid)
						player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
						player:setStorageValue(Storage.Quest.U7_8.BeggarOutfits.BeggarSecondAddon, 2)
						player:addOutfitAddon(153, 2)
						player:addOutfitAddon(157, 2)
					else
						npcHandler:say("You do not have the staff.", cid)
					end
				else
					npcHandler:say("You do not have the staff.", cid)
				end
			else
				npcHandler:say("Sorry, but you need to have a premium account!", cid)
			end
			npcHandler.topic[playerId] = 0
		end
	end

	if msgcontains(msg, "cookie") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.SimonTheBeggar) ~= 1 then
			npcHandler:say("Have you brought a cookie for the poor?", cid)
			npcHandler.topic[playerId] = 8
		end
	elseif msgcontains(msg, "help") then
		npcHandler:say("I need gold. Can you spare 100 gold pieces for me?", cid)
		npcHandler.topic[playerId] = 9
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 8 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.SimonTheBeggar, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end
			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say({
				"Well, it's the least you can do for those who live in dire poverty.",
				"A single cookie is a bit less than I'd expected, but better than ... WHA ... WHAT??",
				"MY BEARD! MY PRECIOUS BEARD! IT WILL TAKE AGES TO CLEAR IT OF THIS CONFETTI!",
			}, cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(npc, cid)
		elseif npcHandler.topic[playerId] == 9 then
			if not player:removeMoneyBank(100) then
				npcHandler:say("You haven't got enough money for me.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end
			npcHandler:say("Thank you very much. Can you spare 500 more gold pieces for me? I will give you a nice hint.", cid)
			npcHandler.topic[playerId] = 10
		elseif npcHandler.topic[playerId] == 10 then
			if not player:removeMoneyBank(500) then
				npcHandler:say("Sorry, that's not enough.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end
			npcHandler:say({
				"That's great! I have stolen something from Dermot.",
				"You can buy it for 200 gold. Do you want to buy it?",
			}, cid)
			npcHandler.topic[playerId] = 11
		elseif npcHandler.topic[playerId] == 11 then
			if not player:removeMoneyBank(200) then
				npcHandler:say("Pah! I said 200 gold. You don't have that much.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end
			local key = player:addItem(2968, 1)
			if key then
				key:setActionId(3940)
			end
			npcHandler:say("Now you own the hot key.", cid)
			npcHandler.topic[playerId] = 0
		end
	end

	if msgcontains(msg, "no") and npcHandler.topic[playerId] ~= 0 then
		local noResponse = {
			[1] = "I see.",
			[2] = "Hmm, maybe next time.",
			[3] = "It was your decision.",
			[4] = "I see.",
			[5] = "Hmm, maybe next time.",
			[6] = "It was your decision.",
			[7] = "Ok. No problem",
			[8] = "Ok. No problem",
			[9] = "Ok. No problem",
			[10] = "Ok. No problem",
			[11] = "Ok. No problem",
		}
		npcHandler:say(noResponse[npcHandler.topic[playerId]], cid)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|. I am a poor man. Please help me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "giant spider" }, StdModule.say, { npcHandler = npcHandler, text = "I know that terrible monster. It killed the fishers on the isle to the north." })
keywordHandler:addKeyword({ "minotaurs" }, StdModule.say, { npcHandler = npcHandler, text = "Very rich monsters. But they are too strong for me. However, there are even stronger monsters." })
keywordHandler:addKeyword({ "treasure" }, StdModule.say, { npcHandler = npcHandler, text = "I know there are two rooms. And I know you can pass only the first door. The second door can't be opened." })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, text = "I heard a lot about the Fibula Dungeon. But I never was there." })
keywordHandler:addKeyword({ "village" }, StdModule.say, { npcHandler = npcHandler, text = "To the north is the village Fibula. A very small village." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "The strongest monster I know is the giant spider." })
keywordHandler:addKeyword({ "beggar" }, StdModule.say, { npcHandler = npcHandler, text = "I have no gold and no job, so I am a beggar." })
keywordHandler:addKeyword({ "dermot" }, StdModule.say, { npcHandler = npcHandler, text = "The magistrate of the village. I heard he is selling something for the Fibula Dungeon." })
keywordHandler:addKeyword({ "fibula" }, StdModule.say, { npcHandler = npcHandler, text = "I hate Fibula. Too many wolves are here." })
keywordHandler:addKeyword({ "shovel" }, StdModule.say, { npcHandler = npcHandler, text = "Hehe, don't you have a shovel? I can sell you a shovel if you want to return to Tibia, just ask me for a trade." })
keywordHandler:addKeyword({ "jetty" }, StdModule.say, { npcHandler = npcHandler, text = "I hate this jetty. I have never seen a ship here." })
keywordHandler:addKeyword({ "simon" }, StdModule.say, { npcHandler = npcHandler, text = "I am Simon. The poorest human all over the continent." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Hehe, don't you have a shovel? I can sell you a shovel if you want to return to Tibia, just ask me for a trade." })
keywordHandler:addKeyword({ "timur" }, StdModule.say, { npcHandler = npcHandler, text = "I hate Timur. He is too expensive. But sometimes I find maces and hatchets. Timur is buying these items." })
keywordHandler:addKeyword({ "flute" }, StdModule.say, { npcHandler = npcHandler, text = "Har, har. The stupid Dermot lost his flute. I know that some minotaurs have it in their treasure room." })
keywordHandler:addKeyword({ "gold" }, StdModule.say, { npcHandler = npcHandler, text = "I need gold. I love gold. I need help." })
keywordHandler:addKeyword({ "poor" }, StdModule.say, { npcHandler = npcHandler, text = "I have no job. I am a beggar." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Simon. I am a very poor man." })
keywordHandler:addKeyword({ "ship" }, StdModule.say, { npcHandler = npcHandler, text = "There is a large sea-monster outside. I think there is no gritty captain to sail in this quarter." })
keywordHandler:addKeyword({ "wolf" }, StdModule.say, { npcHandler = npcHandler, text = "Please kill them ... ALL." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I have no job. I am a beggar." })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "Key? There are a lot of keys. Please change the topic." })

npcHandler:addModule(FocusModule:new())
