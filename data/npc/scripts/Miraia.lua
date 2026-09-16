local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local topic = {}

local config = {
	["ape fur"] = {
		itemId = 5883,
		count = 100,
		storageValue = 1,
		text = {
			"Have you really managed to fulfil the task and brought me 100 pieces of ape fur?",
			"Only ape fur is good enough to touch the feet of our Caliph.",
			"Ahhh, this softness! I'm impressed, |PLAYERNAME|. You're on the best way to earn that turban. Now, please retrieve 100 fish fins.",
		},
	},
	["fish fins"] = {
		itemId = 5895,
		count = 100,
		storageValue = 2,
		text = {
			"Were you able to discover the undersea race and retrieved 100 fish fins?",
			"I really wonder what the explorer society is up to. Actually I have no idea how they managed to dive unterwater.",
			"I never thought you'd make it, |PLAYERNAME|. Now we only need two enchanted chicken wings to start our waterwalking test!",
		},
	},
	["enchanted chicken wings"] = {
		itemId = 5891,
		count = 2,
		storageValue = 3,
		text = {
			"Were you able to get hold of two enchanted chicken wings?",
			"Enchanted chicken wings are actually used to make boots of haste, so they could be magically extracted again. Djinns are said to be good at that.",
			"Great, thank you very much. Just bring me 100 pieces of blue cloth now and I will happily show you how to make a turban.",
		},
	},
	["blue cloth"] = {
		itemId = 5912,
		count = 100,
		storageValue = 4,
		text = {
			"Ah, have you brought the 100 pieces of blue cloth?",
			"It's a great material for turbans.",
			"Ah! Congratulations - I hope this veil will turn out as beautiful as you are. Here, I'll do it for you.",
		},
	},
}

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if player:getSex() == PLAYERSEX_FEMALE and msgcontains(msg, "outfit") then
		npcHandler:say("Hehe, would you like to wear a pretty veil like I do? Well... I could help you, but you would have to complete a task first." or "My veil? No, I will definitely not lift it for you! If you are looking for an addon, go talk to Razan.", cid)
	elseif player:getSex() == PLAYERSEX_FEMALE and msgcontains(msg, "task") then
		if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) < 1 then
			npcHandler:say("You mean, you would like to prove that you deserve to wear such a veil?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif config[msg] and npcHandler.topic[playerId] == 0 then
		if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) == config[msg].storageValue then
			npcHandler:say(config[msg].text[1], cid)
			npcHandler.topic[playerId] = 3
			topic[playerId] = msg
		else
			npcHandler:say(config[msg].text[2], cid)
		end
	elseif msgcontains(msg, "scarab cheese") then
		if player:getStorageValue(Storage.Quest.U8_1.TheTravellingTrader.Mission03) == 1 then
			npcHandler:say("Let me cover my nose before I get this for you... Would you REALLY like to buy scarab cheese for 100 gold?", cid)
		elseif player:getStorageValue(Storage.Quest.U8_1.TheTravellingTrader.Mission03) == 2 then
			npcHandler:say("Oh the last cheese molded? Would you like to buy another one for 100 gold?", cid)
		end
		npcHandler.topic[playerId] = 4
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Alright, then listen to the following requirements. We are currently in dire need of ape fur since the Caliph has requested a new bathroom carpet. ...",
				"Thus, please bring me 100 pieces of ape fur. Secondly, it came to our ears that the explorer society has discovered a new undersea race of fishmen. ...",
				"Their fins are said to allow humans to walk on water! Please bring us 100 of these fish fin. ...",
				"Third, if the plan of walking on water should fail, we need enchanted chicken wings to prevent the testers from drowning. Please bring me two. ...",
				"Last but not least, just drop by with 100 pieces of blue cloth and I will happily show you how to make a turban. ...",
				"Did you understand everything I told you and are willing to handle this task?",
			}, cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon, 1)
			npcHandler:say("Excellent! Come back to me once you have collected 100 pieces of ape fur.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 3 then
			local targetMessage = config[topic[playerId]]
			if not player:removeItem(targetMessage.itemId, targetMessage.count) then
				npcHandler:say("That is a shameless lie.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end
			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon, player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) + 1)
			if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) == 5 then
				player:addOutfitAddon(150, 2) -- female addon
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			npcHandler:say(targetMessage.text[3], cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 4 then
			if player:getMoney() + player:getBankBalance() >= 100 then
				player:setStorageValue(Storage.Quest.U8_1.TheTravellingTrader.Mission03, 2)
				player:addItem(169, 1)
				player:removeMoneyBank(100)
				npcHandler:say("Here it is.", cid)
			else
				npcHandler:say("You don't have enough money.", cid)
			end
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] ~= 0 then
		npcHandler:say("What a pity.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

local function onReleaseFocus(cid)
	local playerId = cid:getId()
	topic[playerId] = nil
end

keywordHandler:addKeyword({ "drink" }, StdModule.say, { npcHandler = npcHandler, text = "I can offer you lemonade, camel milk, and water. If you'd like to see my offers, ask me for a {trade}." })
keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, text = "Are you looking for food? I have bread, cheese, ham, and meat. If you'd like to see my offers, ask me for a {trade}." })

npcHandler:setMessage(MESSAGE_GREET, "Daraman's blessings, |PLAYERNAME|. Welcome to the Enlightened Oasis. Sit down, have a {drink} or some {food}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings. Come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:addModule(FocusModule:new())
