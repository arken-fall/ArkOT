local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local brokenCompass = 25746
local chargeableCompass = 29291
local chargedCompass = 29294
local goldenAxe = 29286
local CompassValue = 10000

local buildCompass = {
	[1] = { id = 29346, qnt = 15 },
	[2] = { id = 29345, qnt = 50 },
	[3] = { id = 29347, qnt = 5 },
	[4] = { id = 25746, qnt = 1 },
}

local chargeCompass = {
	[1] = { id = 29287, qnt = 5 },
	[2] = { id = 29288, qnt = 3 },
	[3] = { id = 29289, qnt = 1 },
	[4] = { id = 29348, qnt = 1 },
	[5] = { id = 29291, qnt = 1 },
}

local function removeBait(player)
	local player = Player(player)

	if player and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.HasBait) == 1 then
		player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.HasBait, -1)
	end
end

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello, I am the warden of this {monument}. The {sarcophagus} in front of you was established to prevent people from going {down} there. But I doubt that this step is sufficient.")
	elseif player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Well, let's see if your mission was successful. Just bring me all needed {materials}.")
	elseif player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "If you dug up all three crystals of sufficient quantity and obtained the poison gland, the charging of your compass can start! For the very first time it will be charged by the violet crystal. Ready to {unleash} the power of the crystals?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
	end

	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "monument") and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) < 1 then
		npcHandler:say({
			"Well, a while ago powerful magic devices were used all around Tibia. These are chargeable compasses. There was but one problem: they offered the possibility to make people rich in a quite easy way. ...",
			"Therefore, these instruments were very coveted. People tried to get their hands on them at all costs. And so it happened what everybody feared - bloody battles forged ahead. ...",
			"To put an end to these cruel escalations, eventually all of the devices were collected and destroyed. The remains were buried {deep} in the earth.",
		}, cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "deep") and npcHandler.topic[playerId] == 2 then
		npcHandler:say("As far as I know it is a place of helish heat with bloodthirsty monsters of all kinds.", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "sarcophagus") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("This sarcophagus seals the entrance to the caves down there. Only here you can get all the {materials} you need for a working compass of this kind. So no entrance here - no further magic compasses in Tibia. In theory.", cid)
		npcHandler.topic[playerId] = 4
	elseif msgcontains(msg, "down") and npcHandler.topic[playerId] == 10 then
		npcHandler:say("On first glance, this cave does not look very spectacular, but the things you find in there, are. You have to know that this is the only place where you can find the respective materials to build the compass.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "materials") then
		if npcHandler.topic[playerId] == 4 then
			npcHandler:say({
				"Only in the cave down there you will find the materials you need to repair the {compass}. Now you know why the entrance is sealed. There's the seal, but I have a deal for you: ...",
				"I can repair the compass for you if you deliver what I need. Besides the broken compass you have to bring me the following materials: 50 blue glas plates, 15 green glas plates and 5 violet glas plates. ...",
				"They all can be found in this closed cave in front of you. I should have destroyed this seal key but things have changed. The entrance is opened now, go down and do what has to be done.",
			}, cid)
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline, 1)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) == 1 then
			npcHandler:say("May I repair your compass if possible?", cid)
			npcHandler.topic[playerId] = 11
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 11 then
			local haveItens = false

			for _, k in pairs(buildCompass) do
				if player:getItemCount(k.id) >= k.qnt then
					haveItens = true
				else
					haveItens = false
				end
			end

			if haveItens then
				for _, k in pairs(buildCompass) do
					if player:getItemCount(k.id) >= k.qnt then
						player:removeItem(k.id, k.qnt)
					end
				end

				npcHandler:say({
					"Alright, I put the glasses into the right pattern and can repair the compass. ...",
					"There we are! The next step is the charging of the compass. For this you have to dig three different crystals down there: 5 blue, 3 green and one violet crystal. Are you ready to do that?",
				}, cid)
				player:addItem(chargeableCompass, 1)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline, 2)
				npcHandler.topic[playerId] = 12
			else
				npcHandler:say("You don't have the needed itens yet.", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 12 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.GotAxe) < 1 then
			npcHandler:say({
				"Nice! To do so, take this golden axe and mine the prominent crystals in the cave. Besides, I need a poison gland of quite rare spiders, they are called lucifuga araneae. ...",
				"These are quite shy, but I have a {bait} for you to lure them. But take care not to face too many of them at once. And hurry, the effect won't last forever!",
			}, cid)
			player:addItem(goldenAxe, 1)
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.GotAxe, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 51 then
			if (player:getMoney() + player:getBankBalance()) >= CompassValue then
				npcHandler:say("Here's your broken compass!", cid)
				player:removeMoneyBank(CompassValue)
				player:addItem(brokenCompass, 1)
				npcHandler.topic[playerId] = 10
			else
				npcHandler:say("You don't have enough money.", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "unleash") then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) == 2 then
			local haveItens = false

			for _, k in pairs(chargeCompass) do
				if player:getItemCount(k.id) >= k.qnt then
					haveItens = true
				else
					haveItens = false
				end
			end

			if haveItens then
				for _, k in pairs(chargeCompass) do
					if player:getItemCount(k.id) >= k.qnt then
						player:removeItem(k.id, k.qnt)
					end
				end

				npcHandler:say({
					"I put these crystals onto the top of compass. As you can see, the compass is now pulsating in a warm, violet colour. ...",
					"Now this compass is ready for usage. It can transfer the bound energy to other inanimate objects to open certain gates or chests.",
				}, cid)
				player:addItem(chargedCompass, 1)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline, 3)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You don't have the needed itens yet.", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "bait") then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline) == 2 then
			if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.HasBait) < 1 then
				npcHandler:say("Done. Worry, the effect won't last forever!", cid)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.HasBait, 1)
				addEvent(removeBait, 3 * 60 * 1000, cid)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You're already with my bait!", cid)
				npcHandler.topic[playerId] = 0
			end
		else
			npcHandler:say("You cannot do that yet.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "compass") then
		npcHandler:say("It was decided to collect all of the compasses, destroy them and throw them in the fiery depths of Tibia. I still have some of them here. I {sell} them for a low price if you want.", cid)
		npcHandler.topic[playerId] = 50
	elseif msgcontains(msg, "sell") then
		if npcHandler.topic[playerId] == 50 then
			npcHandler:say("Would you like to buy a broken compass for 10.000 gold?", cid)
			npcHandler.topic[playerId] = 51
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say({ "Don't waste my time." }, cid)
		npcHandler.topic[playerId] = 0
	else
		npcHandler:say("Sorry, I didn't understand.", cid)
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
