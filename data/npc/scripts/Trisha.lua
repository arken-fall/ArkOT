local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local config = {
	["hardened bones"] = {
		value = 1,
		message = {
			wrongValue = "Well, I'll give you a little hint. They can sometimes be extracted from creatures \z
				that consist only of - you guessed it, bones. You need an obsidian knife though.",
			deliever = "How are you faring with your mission? Have you collected all 100 hardened bones?",
			success = "I'm surprised. That's pretty good for a man. Now, bring us the 100 turtle shells.",
		},
		itemId = 5925,
		count = 100,
	},
	["turtle shells"] = {
		value = 2,
		message = {
			wrongValue = "Turtles can be found on some idyllic islands which have recently been discovered.",
			deliever = "Did you get us 100 turtle shells so we can make new shields?",
			success = "Well done - for a man. These shells are enough to build many strong new shields. \z
			Thank you! Now - show me fighting spirit.",
		},
		itemId = 5899,
		count = 100,
	},
	["fighting spirit"] = {
		value = 3,
		message = {
			wrongValue = "You should have enough fighting spirit if you are a true hero. \z
				Sorry, but you have to figure this one out by yourself. Unless someone grants you a wish.",
			deliever = "So, can you show me your fighting spirit?",
			success = "Correct - pretty smart for a man. But the hardest task is yet to come: \z
				the claw from a lord among the dragon lords.",
		},
		itemId = 5884,
	},
	["dragon claw"] = {
		value = 4,
		message = {
			wrongValue = "You cannot get this special red claw from any common dragon in Tibia. \z
				It requires a special one, a lord among the lords.",
			deliever = "Have you actually managed to obtain the dragon claw I asked for?",
			success = "You did it! I have seldom seen a man as courageous as you. \z
				I really have to say that you deserve to wear a spike. Go ask Cornelia to adorn your armour.",
		},
		itemId = 5919,
	},
}

local topic = {}

local function greetCallback(cid)
	local playerId = cid:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Welcome back, knight |PLAYERNAME|!")
	topic[playerId] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local player, storage = Player(cid), Storage.Quest.U7_8.WarriorOutfits.WarriorShoulderAddon
	if npcHandler.topic[playerId] == 0 then
		if table.contains({ "outfit", "addon" }, msg) then
			npcHandler:say("Are you talking about my spiky shoulder pad? You can't buy one of these. They have to be {earned}.", cid)
		elseif msgcontains(msg, "earn") then
			if player:getStorageValue(storage) < 1 then
				npcHandler:say("I'm not sure if you are enough of a hero to earn them. You could try, though. What do you think?", cid)
				npcHandler.topic[playerId] = 1
			elseif player:getStorageValue(storage) >= 1 and player:getStorageValue(storage) < 5 then
				npcHandler:say("Before I can nominate you for an award, please complete your task.", cid)
			elseif player:getStorageValue(storage) == 5 then
				npcHandler:say("You did it! I have seldom seen a man as courageous as you. I really have to say that you deserve to wear a spike. Go ask Cornelia to adorn your armour.", cid)
			end
		elseif config[msg:lower()] then
			local targetMessage = config[msg:lower()]
			if player:getStorageValue(storage) ~= targetMessage.value then
				npcHandler:say(targetMessage.msg.wrongValue, cid)
				return true
			end

			npcHandler:say(targetMessage.msg.deliever, cid)
			npcHandler.topic[playerId] = 3
			topic[playerId] = targetMessage
		end
	elseif npcHandler.topic[playerId] == 1 then
		if msgcontains(msg, "yes") then
			npcHandler:say({
				"Okay, who knows, maybe you have a chance. A really small one though. Listen up: ...",
				"First, you have to prove your guts by bringing me 100 hardened bones. ...",
				"Next, if you actually managed to collect that many, please complete a small task for our guild and bring us 100 turtle shells. ...",
				"It is said that excellent shields can be created from these. ...",
				"Alright, um, afterwards show me that you have fighting spirit. Any true hero needs plenty of that. ...",
				"The last task is the hardest. You will need to bring me a claw from a mighty dragon king. ...",
				"Did you understand everything I told you and are willing to handle this task?",
			}, cid, 100)
			npcHandler.topic[playerId] = 2
		elseif msgcontains(msg, "no") then
			npcHandler:say("I thought so. Train hard and maybe some day you will be ready to face this mission.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "yes") then
			player:setStorageValue(storage, 1)
			-- This for default start of outfit and addon quests
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			npcHandler:say("Excellent! Don't forget: Your first task is to bring me 100 hardened bones. Good luck!", cid)
			npcHandler.topic[playerId] = 0
		elseif msgcontains(msg, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif npcHandler.topic[playerId] == 3 then
		if msgcontains(msg, "yes") then
			local targetMessage = topic[playerId]
			if not player:removeItem(targetMessage.itemId, targetMessage.count or 1) then
				npcHandler:say("Why do men always lie?", cid)
				return true
			end

			player:setStorageValue(storage, player:getStorageValue(storage) + 1)
			npcHandler:say(targetMessage.msg.success, cid)
		elseif msgcontains(msg, "no") then
			npcHandler:say("Don't give up just yet.", cid)
		end
		npcHandler.topic[playerId] = 0
	end
	return true
end

local node1 = keywordHandler:addKeyword({ "lesser front sweep" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lesser front sweep} magic spell for free?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "lesser front sweep", vocation = { 4, 8 }, price = 0, level = 1 })

local node2 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node3 = keywordHandler:addKeyword({ "wound cleansing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {wound cleansing} magic spell for free?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "wound cleansing", vocation = { 4, 8 }, price = 0, level = 8 })

local node4 = keywordHandler:addKeyword({ "bruise bane" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {bruise bane} magic spell for free?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "bruise bane", vocation = { 4, 8 }, price = 0, level = 1 })

local node5 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node6 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node7 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node8 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {healing} spells and {support} spells. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Bruise Bane}, {Cure Poison} and {Wound Cleansing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Find Fiend}, {Find Person}, {Great Light}, {Lesser Front Sweep} and {Light}.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {10}, {13} and {25}.",
})

nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Find Person} for 80 gold, {Light} for free and {Wound Cleansing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Bruise Bane} for free and {Lesser Front Sweep} for free." })

npcHandler:setMessage(MESSAGE_WALKAWAY, "Be careful on your journeys.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Don't hurt yourself with that weapon, little one.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
