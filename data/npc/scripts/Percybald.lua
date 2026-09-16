local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "disguise") then
		if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.TheatreScript) < 0 then
			npcHandler:say({
				"Hmpf. Why should I waste my time to help some amateur? I'm afraid I can only offer my assistance to actors that are as great as I am. ...",
				"Though, your futile attempt to prove your worthiness could be amusing. Grab a copy of a script from the prop room at the theatre cellar. Then talk to me again about your test!",
			}, cid)
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.TheatreScript, 0)
		end
	elseif msgcontains(msg, "test") then
		if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04) == 5 then
			npcHandler:say("I hope you learnt your role! I'll tell you a line from the script and you'll have to answer with the corresponding line! Ready?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("How dare you? Are you mad? I hold the princess hostage and you drop your weapons. You're all lost!", cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say("Too late puny knight. You can't stop my master plan anymore!", cid)
			npcHandler.topic[playerId] = 4
		elseif npcHandler.topic[playerId] == 5 then
			npcHandler:say("What's this? Behind the doctor?", cid)
			npcHandler.topic[playerId] = 6
		elseif npcHandler.topic[playerId] == 7 then
			npcHandler:say("Haha! You may not fear for your own life, but how about hers!?", cid)
			npcHandler.topic[playerId] = 8
		elseif npcHandler.topic[playerId] == 9 then
			npcHandler:say("Grrr!", cid)
			npcHandler.topic[playerId] = 10
		elseif npcHandler.topic[playerId] == 11 then
			npcHandler:say("You're such a monster!", cid)
			npcHandler.topic[playerId] = 12
		elseif npcHandler.topic[playerId] == 13 then
			npcHandler:say("Ah well, I think you passed the test! Here is your disguise kit! Now get lost, fate awaits me!", cid)
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04, 6)
			player:addItem(7865, 1)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "I don't think so, dear doctor!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", cid)
			npcHandler.topic[playerId] = 3
		else
			npcHandler:say("No no no! That is not correct!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 4 then
		if msgcontains(msg, "Watch out! It's a trap!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", cid)
			npcHandler.topic[playerId] = 5
		else
			npcHandler:say("No no no! That is not correct!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 6 then
		if msgcontains(msg, "Look! It's Lucky, the wonder dog!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", cid)
			npcHandler.topic[playerId] = 7
		else
			npcHandler:say("No no no! That is not correct!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 8 then
		if msgcontains(msg, "Oh no! Look! It's Princess Buttercup! He's holding her hostage!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", cid)
			npcHandler.topic[playerId] = 9
		else
			npcHandler:say("No no no! That is not correct!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 10 then
		if msgcontains(msg, "Ahhhhhh!") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", cid)
			npcHandler.topic[playerId] = 11
		else
			npcHandler:say("No no no! That is not correct!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 12 then
		if msgcontains(msg, "Hahaha! Now drop your weapons or else...") then
			npcHandler:say("Ok, ok. You've got this one right! Ready for the next one?", cid)
			npcHandler.topic[playerId] = 13
		else
			npcHandler:say("No no no! That is not correct!", cid)
			npcHandler.topic[playerId] = 0
		end
	end

	-- Additional dialogue options related to outfits
	if msgcontains(msg, "outfit") or msgcontains(msg, "addon") or msgcontains(msg, "royal") then
		npcHandler:say("In exchange for a generous donation of gold and silver tokens, I can offer you a special outfit. Would you like to donate?", cid)
		npcHandler.topic[playerId] = 14
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 14 then
			npcHandler:say({
				"Great! To clarify, donating 30,000 silver tokens and 25,000 gold tokens will entitle you to a unique outfit. ...",
				"For 15,000 silver tokens and 12,500 gold tokens, you will receive the {armor}. For an additional 7,500 silver tokens and 6,250 gold tokens each, you can also receive the {shield} and {crown}. ...",
				"What will you choose?",
			}, cid)
			npcHandler.topic[playerId] = 15
		elseif npcHandler.topic[playerId] == 15 then
			npcHandler:say("If you haven't made up your mind, please come back when you are ready.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 16 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 1 then
				if player:removeItem(22516, 15000) and player:removeItem(22721, 12500) then
					npcHandler:say("Take this armor as a token of great gratitude. Let us forever remember this day, my friend!", cid)
					player:addOutfit(1457)
					player:addOutfit(1456)
					player:getPosition():sendMagicEffect(171)
					player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 1)
				else
					npcHandler:say("You do not have enough tokens to donate that amount.", cid)
				end
			else
				npcHandler:say("You already have that addon.", cid)
			end
			npcHandler.topic[playerId] = 15
		elseif npcHandler.topic[playerId] == 17 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) == 1 then
				if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 2 then
					if player:removeItem(22516, 7500) and player:removeItem(22721, 6250) then
						npcHandler:say("Take this shield as a token of great gratitude. Let us forever remember this day, my friend.", cid)
						player:addOutfitAddon(1457, 1)
						player:addOutfitAddon(1456, 1)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 2)
					else
						npcHandler:say("You do not have enough tokens to donate that amount.", cid)
					end
				else
					npcHandler:say("You already have that outfit.", cid)
				end
			else
				npcHandler:say("You need to donate the {armor} outfit first.", cid)
			end
			npcHandler.topic[playerId] = 15
		elseif npcHandler.topic[playerId] == 18 then
			if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) == 2 then
				if player:getStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit) < 3 then
					if player:removeItem(22516, 7500) and player:removeItem(22721, 6250) then
						npcHandler:say("Take this crown as a token of great gratitude. Let us forever remember this day, my friend.", cid)
						player:addOutfitAddon(1457, 2)
						player:addOutfitAddon(1456, 2)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.RoyalCostumeOutfit, 3)
					else
						npcHandler:say("You do not have enough tokens to donate that amount.", cid)
					end
				else
					npcHandler:say("You already have that outfit.", cid)
				end
			else
				npcHandler:say("You need to donate the {shield} addon first.", cid)
			end
			npcHandler.topic[playerId] = 15
		end
	elseif msgcontains(msg, "armor") and npcHandler.topic[playerId] == 15 then
		npcHandler:say("Would you like to donate 15,000 silver tokens and 12,500 gold tokens for a unique red armor?", cid)
		npcHandler.topic[playerId] = 16
	elseif msgcontains(msg, "shield") and npcHandler.topic[playerId] == 15 then
		npcHandler:say("Would you like to donate 7,500 silver tokens and 6,250 gold tokens for a unique shield?", cid)
		npcHandler.topic[playerId] = 17
	elseif msgcontains(msg, "crown") and npcHandler.topic[playerId] == 15 then
		npcHandler:say("Would you like to donate 7,500 silver tokens and 6,250 gold tokens for a unique crown?", cid)
		npcHandler.topic[playerId] = 18
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "interrupt" }, StdModule.say, { npcHandler = npcHandler, text = "Can't you see? I am the greatest actor in the world!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Can't you see? I am the greatest actor in the world!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Haven't you heard of me? I'm Percybald, the Magnificent!" })

npcHandler:addModule(FocusModule:new())
