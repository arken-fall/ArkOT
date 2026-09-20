local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallbackFemale(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon) < 1 then
		npcHandler:say("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", npc, creature)
		npcHandler:setTopic(playerId, 19)
	elseif npcHandler:getTopic(playerId) == 19 and MsgContains(message, "yes") then
		npcHandler:say("Especially for you, mylady, we are offering a pretty hat and a beautiful dress like the ones I wear. Which one are you interested in?", npc, creature)
		npcHandler:setTopic(playerId, 20)
	elseif npcHandler:getTopic(playerId) == 20 and MsgContains(message, "dress") then
		npcHandler:say("Great! Since our accessories are hand-tailored designer pieces, of course they are not made for citizens with an empty wallet. Should I inform you about our payment policy?", npc, creature)
		npcHandler:setTopic(playerId, 21)
	elseif npcHandler:getTopic(playerId) == 21 and MsgContains(message, "yes") then
		npcHandler:say({
			"The accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...",
			"This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...",
			"I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. Are you interested in purchasing this accessory?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 22)
	elseif npcHandler:getTopic(playerId) == 22 and MsgContains(message, "yes") then
		npcHandler:say("I'm very pleased to hear that! Which do you prefer - paying 150000 at once or 10000 for 15 times?", npc, creature)
		npcHandler:setTopic(playerId, 23)
	elseif npcHandler:getTopic(playerId) == 23 and MsgContains(message, "150000") then
		player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon, 1)
		npcHandler:say("Good, I have noted down your order. Once you have the money, please come back to pick up your accessory.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon) == 1 then
		npcHandler:say("Ah, are you here to pickup your accessory for 150000 gold pieces?", npc, creature)
		npcHandler:setTopic(playerId, 24)
	elseif npcHandler:getTopic(playerId) == 24 and MsgContains(message, "yes") then
		if player:removeMoney(150000) then
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addOutfitAddon(140, 1)
			npcHandler:say("Congratulations! Here is your brand-new accessory, I hope you like it. Please visit us again!", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon, 2)
		else
			npcHandler:say("You do not have enough money.", npc, creature)
		end
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon) < 1 then
		npcHandler:say("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", npc, creature)
		npcHandler:setTopic(playerId, 25)
	elseif npcHandler:getTopic(playerId) == 25 and MsgContains(message, "yes") then
		npcHandler:say("Especially for you, mylady, we are offering a pretty hat and a beautiful dress like the ones I wear. Which one are you interested in?", npc, creature)
		npcHandler:setTopic(playerId, 26)
	elseif npcHandler:getTopic(playerId) == 26 and MsgContains(message, "hat") then
		npcHandler:say("Great! Since our accessories are hand-tailored designer pieces, of course they are not made for citizens with an empty wallet. Should I inform you about our payment policy?", npc, creature)
		npcHandler:setTopic(playerId, 27)
	elseif npcHandler:getTopic(playerId) == 27 and MsgContains(message, "yes") then
		npcHandler:say({
			"This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...",
			"This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...",
			"I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. Are you interested in purchasing this accessory?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 28)
	elseif npcHandler:getTopic(playerId) == 28 and MsgContains(message, "yes") then
		npcHandler:say("I'm very pleased to hear that! Which do you prefer - paying 150000 at once or 10000 for 15 times?", npc, creature)
		npcHandler:setTopic(playerId, 29)
	elseif npcHandler:getTopic(playerId) == 29 and MsgContains(message, "150000") then
		player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon, 1)
		npcHandler:say("Good, I have noted down your order. Once you have the money, please come back to pick up your accessory.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon) == 1 then
		npcHandler:say("Ah, are you here to pickup your accessory for 150000 gold pieces?", npc, creature)
		npcHandler:setTopic(playerId, 30)
	elseif npcHandler:getTopic(playerId) == 30 and MsgContains(message, "yes") then
		if player:removeMoney(150000) then
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addOutfitAddon(140, 2)
			player:addAchievement(226) -- Achievement Aristocrat
			npcHandler:say("Congratulations! Here is your brand-new accessory, I hope you like it. Please visit us again!", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon, 2)
		else
			npcHandler:say("You do not have enough money.", npc, creature)
		end
	end

	return true
end

local function creatureSayCallbackMale(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon) < 1 then
		npcHandler:say("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", npc, creature)
		npcHandler:setTopic(playerId, 9)
	elseif npcHandler:getTopic(playerId) == 9 and MsgContains(message, "yes") then
		npcHandler:say("Especially for you, mylord, we are offering a fashionable top hat and a fancy coat like the one Kalvin wears. Which one are you interested in?", npc, creature)
		npcHandler:setTopic(playerId, 10)
	elseif npcHandler:getTopic(playerId) == 10 and MsgContains(message, "coat") then
		npcHandler:say("Great! Since our accessories are hand-tailored designer pieces, of course they are not made for citizens with an empty wallet. Should I inform you about our payment policy?", npc, creature)
		npcHandler:setTopic(playerId, 11)
	elseif npcHandler:getTopic(playerId) == 11 and MsgContains(message, "yes") then
		npcHandler:say({
			"This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...",
			"This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...",
			"I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. Are you interested in purchasing this accessory?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 12)
	elseif npcHandler:getTopic(playerId) == 12 and MsgContains(message, "yes") then
		npcHandler:say("I'm very pleased to hear that! Which do you prefer - paying 150000 at once or 10000 for 15 times?", npc, creature)
		npcHandler:setTopic(playerId, 13)
	elseif npcHandler:getTopic(playerId) == 13 and MsgContains(message, "150000") then
		player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon, 1)
		npcHandler:say("Good, I have noted down your order. Once you have the money, please come back to pick up your accessory.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon) == 1 then
		if player:removeMoney(150000) then
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addOutfitAddon(132, 1)
			npcHandler:say("Ah, are you here to pickup your accessory for 150000 gold pieces? Here is your nobleman coat. Enjoy!", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanFirstAddon, 2)
		else
			npcHandler:say("You do not have enough money.", npc, creature)
		end
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon) < 1 then
		npcHandler:say("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", npc, creature)
		npcHandler:setTopic(playerId, 14)
	elseif npcHandler:getTopic(playerId) == 14 and MsgContains(message, "yes") then
		npcHandler:say("Especially for you, mylord, we are offering a fashionable top hat and a fancy coat like the one Kalvin wears. Which one are you interested in?", npc, creature)
		npcHandler:setTopic(playerId, 15)
	elseif npcHandler:getTopic(playerId) == 15 and MsgContains(message, "yes") then
		npcHandler:say("Great! Since our accessories are hand-tailored designer pieces, of course they are not made for citizens with an empty wallet. Should I inform you about our payment policy?", npc, creature)
		npcHandler:setTopic(playerId, 16)
	elseif npcHandler:getTopic(playerId) == 16 and MsgContains(message, "yes") then
		npcHandler:say({
			"This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...",
			"This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...",
			"I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. Are you interested in purchasing this accessory?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 17)
	elseif npcHandler:getTopic(playerId) == 17 and MsgContains(message, "yes") then
		npcHandler:say("I'm very pleased to hear that! Which do you prefer - paying 150000 at once or 10000 for 15 times?", npc, creature)
		npcHandler:setTopic(playerId, 18)
	elseif npcHandler:getTopic(playerId) == 18 and MsgContains(message, "150000") then
		player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon, 1)
		npcHandler:say("Good, I have noted down your order. Once you have the money, please come back to pick up your accessory.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon) == 1 then
		if player:removeMoney(150000) then
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addOutfitAddon(132, 2)
			player:addAchievement(226) -- Achievement Aristocrat
			npcHandler:say("Ah, are you here to pickup your accessory for 150000 gold pieces? Here is your nobleman hat. Enjoy!", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.NoblemanOutfits.NoblemanSecondAddon, 2)
		else
			npcHandler:say("You do not have enough money.", npc, creature)
		end
	end

	return true
end

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid
	local playerSex = player:getSex()

	if msgcontains(msg, "fur") then
		if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 7 and player:getStorageValue(ThreatenedDreams.Mission01.PoacherNotes) == 1 then
			npcHandler:say({
				"A wolf whelp fur? Well, some months ago a hunter came here - a rather scruffy, smelly guy. I would have thrown him out instantly, but he had to offer some fine pelts. One of them was the fur of a very young wolf. ...",
				"I was not delighted that he obviously killed such a young animal. When I confronted him, he said he wanted to raise it as a companion but it unfortunately died. A sad story. In the end, I bought some of his pelts, among them the whelp fur. ...",
				"You can have it if this is important for you. I would sell it for 1000 gold. Are you interested?",
			}, cid)
			npcHandler.topic[playerId] = 8
		else
			npcHandler:say("You are not on that mission.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 5 then
		if player:getItemCount(3566) >= 1 then
			player:removeItem(3566, 1)
			npcHandler:say("A {Red Robe}! Great. Here, take this red piece of cloth, I don't need it anyway.", cid)
			player:addItem(5911, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Are you trying to mess with me?!", cid)
		end
	elseif npcHandler.topic[playerId] == 6 then
		if player:getItemCount(3574) >= 1 then
			player:removeItem(3574, 1)
			npcHandler:say("A {Mystic Turban}! Great. Here, take this blue piece of cloth, I don't need it anyway.", cid)
			player:addItem(5912, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Are you trying to mess with me?!", cid)
		end
	elseif npcHandler.topic[playerId] == 7 then
		if player:getItemCount(3563) >= 150 then
			player:removeItem(3563, 150)
			npcHandler:say("A 150 {Green Tunic}! Great. Here, take this green piece of cloth, I don't need it anyway.", cid)
			player:addItem(5910, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Are you trying to mess with me?!", cid)
		end
	elseif npcHandler.topic[playerId] == 8 then
		if player:getMoney() >= 1000 then
			player:removeMoney(1000)
			player:addItem(25238, 1) -- Fur of a Wolf Whelp
			npcHandler:say("Alright. Here is the fur.", cid)
			player:setStorageValue(ThreatenedDreams.Mission01[1], 8)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Are you trying to mess with me?!", cid)
		end
	elseif msgcontains(msg, "red robe") then
		npcHandler:say("Have you found a {Red Robe} for me?", cid)
		npcHandler.topic[playerId] = 5
	elseif msgcontains(msg, "mystic turban") then
		npcHandler:say("Have you found a {Mystic Turban} for me?", cid)
		npcHandler.topic[playerId] = 6
	elseif msgcontains(msg, "green tunic") then
		npcHandler:say("Have you found {150 Green Tunic} for me?", cid)
		npcHandler.topic[playerId] = 7
	elseif playerSex == PLAYERSEX_MALE then
		return creatureSayCallbackMale(npc, cid, type, msg)
	else
		return creatureSayCallbackFemale(npc, cid, type, msg)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the house of fashion, |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
