local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh no! Was that really me? This is so embarassing, I have no idea what has gotten into me. Was that the fighting spirit you gave me?")
	end

	return true
end

keywordHandler:addKeyword({ "gelagos" }, StdModule.say, { npcHandler = npcHandler, text = "This... person... makes me want to... say something bad... must... control myself. <sweats>" })

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if table.contains({ "recruitment", "violence", "outfit", "addon" }, msg) then
		if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) < 1 then
			npcHandler:say({
				"Convincing Ajax that it is not always necessary to use brute force... this would be such an achievement. Definitely a hard task though. ...",
				"Listen, I simply have to ask, maybe a stranger can influence him better than I can. Would you help me with my brother?",
			}, cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "brother is right. fist not always good.") then
		if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 3 then
			npcHandler:say("Oh! He really said that? I am so proud of you, |PLAYERNAME|. These are really good news. Everything would be great... if only there wasn't this {person} near my house.", cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "person") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say({
				"This... person... makes me want to... say something bad... must... control myself. <sweats> I really don't know what to do anymore. ...",
				"I wonder if Ajax has an idea. Could you ask him about Gelagos?",
			}, cid)
			npcHandler.topic[playerId] = 4
		end
	elseif msgcontains(msg, "fighting spirit") then
		if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 5 then
			if player:removeItem(5884, 1) then
				npcHandler:say("Fighting spirit? What am I supposed to do with this fi... - oh! I feel strange... ME MIGHTY! ME WILL CHASE OFF ANNOYING KIDS!GROOOAARR!! RRRRRRRRRRRRAAAAAAAGE!!", cid)
				player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 6)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "red piece of cloth") then
		if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 7 then
			npcHandler:say("Have you really managed to fulfil the task and brought me 50 pieces of red cloth and 50 pieces of green cloth?", cid)
			npcHandler.topic[playerId] = 8
		end
	elseif msgcontains(msg, "rolls of spider silk") then
		if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 8 then
			npcHandler:say("Oh, did you bring 10 rolls of spool of yarn for me?", cid)
			npcHandler.topic[playerId] = 9
		end
	elseif msgcontains(msg, "warriors sweat") then
		if player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 9 then
			npcHandler:say("Were you able to get hold of a flask with pure warrior's sweat?", cid)
			npcHandler.topic[playerId] = 10
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Really! That is such an incredibly nice offer! I already have a plan. You have to teach him that sometimes words are stronger than fists. ...",
				"Maybe you can provoke him with something to get angry, like saying... 'MINE!' or something. But beware, I'm sure that he will try to hit you. ...",
				"Don't do this if you feel weak or ill. He will probably want to make you leave by using violence, but just stay strong and refuse to give up. ...",
				"If he should ask what else is necessary to make you leave, tell him to 'say please'. Afterwards, do leave and return to him one hour later. ...",
				"This way he might learn that violence doesn't always help, but that a friendly word might just do the trick. ...",
				"Have you understood everything I told you and are really willing to take this risk?",
			}, cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say("You are indeed not only well educated, but also very courageous. I wish you good luck, you are my last hope.", cid)
			player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 4 then
			npcHandler:say("Again, I have to thank you for your selfless offer to help me. I hope that Ajax can come up with something, now that he has experienced the power of words.", cid)
			player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 4)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 6 and npcHandler.topic[playerId] == 0 then
			npcHandler:say({
				"I'm impressed... I am sure this was Ajax' idea. I would love to give him a present, but if I leave my hut to gather ingredients, hewill surely notice. ...",
				"Would you maybe help me again, one last time, my friend? I assure you that your efforts will not be in vain.",
			}, cid)
			npcHandler.topic[playerId] = 6
		elseif npcHandler.topic[playerId] == 6 then
			npcHandler:say({
				"Great! You see, I really would love to sew a nice shirt for him. I just need a few things for that, so please listen closely: ...",
				"He loves green and red, so I will need about 50 pieces of red cloth - like the material heroes make their capes of - and 50 pieces of the green cloth Djinns like. ...",
				"Secondly, I need about 10 rolls of spider silk yarn. I think mermaids can yarn silk of large spiders to create a smooth thread. ...",
				"The only remaining thing needed would be a bottle of warrior's sweat to spray it over the shirt... he just loves this smell. ...",
				"Have you understood everything I told you and are willing to handle this task?",
			}, cid)
			npcHandler.topic[playerId] = 7
		elseif npcHandler.topic[playerId] == 7 then
			npcHandler:say("Thank you, my friend! Come back to me once you have collected 50 pieces of red cloth and 50 pieces of green cloth.", cid)
			player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 7)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 8 then
			if player:getItemCount(5910) >= 50 and player:getItemCount(5911) >= 50 then
				npcHandler:say("Terrific! I will start to trim it while you gather 10 rolls of spider silk. I'm sure that Ajax will love it.", cid)
				player:removeItem(5910, 50)
				player:removeItem(5911, 50)
				player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 8)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 9 then
			if player:removeItem(5886, 10) then
				npcHandler:say("I'm impressed! You really managed to get spool of yarn for me! I will immediately start to work on this shirt. Please don't forget to bring me warrior's sweat!", cid)
				player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 9)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 10 then
			if player:removeItem(5885, 1) then
				npcHandler:say("Good work, |PLAYERNAME|! Now I can finally finish this present for Ajax. Because you were such a great help, I have also a present for you. Will you accept it?", cid)
				player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 10)
				npcHandler.topic[playerId] = 0
			end
		elseif player:getStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon) == 10 then
			npcHandler:say("I have kept this traditional barbarian wig safe for many years now. It is now yours! I hope you will wear it proudly, friend.", cid)
			player:addOutfitAddon(147, 2)
			player:addOutfitAddon(143, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:setStorageValue(Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon, 11)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my humble hut, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care!")
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Bron. Pleased to meet you, |PLAYERNAME|." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am a barbarian. Me and my brother are the only ones in this region, as far as I know." })
keywordHandler:addKeyword({ "hut" }, StdModule.say, { npcHandler = npcHandler, text = "I am a barbarian. Me and my brother are the only ones in this region, as far as I know." })
keywordHandler:addKeyword({ "cyclops" }, StdModule.say, { npcHandler = npcHandler, text = "Ajax simply won't understand the advantages of a well-regulated lifestyle. We have actually tried to live together, but we start to fight after a few minutes." })
keywordHandler:addKeyword({ "ajax" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, sigh. It is hard to believe that this illiterate savage is my one and only brother." })
keywordHandler:addKeyword({ "savage" }, StdModule.say, { npcHandler = npcHandler, text = "Ajax simply won't understand the advantages of a well-regulated lifestyle. We have actually tried to live together, but we start to fight after a few minutes." })
keywordHandler:addKeyword({ "blood" }, StdModule.say, { npcHandler = npcHandler, text = "Where? Where? I hope my carpet is not ruined. Last time Ajax was here he left a horrible mess." })
keywordHandler:addKeyword({ "mess" }, StdModule.say, { npcHandler = npcHandler, text = "I really don't want to think about it anymore." })
keywordHandler:addKeyword({ "opinion" }, StdModule.say, { npcHandler = npcHandler, text = "We always have different opinions on all sorts of matters. Such as interior decoration. Or violence." })
keywordHandler:addKeyword({ "decoration" }, StdModule.say, { npcHandler = npcHandler, text = "Nice furniture, isn't it?" })
keywordHandler:addKeyword({ "warrior's sweat" }, StdModule.say, { npcHandler = npcHandler, text = "Were you able to get hold of a flask with pure warrior's sweat?" })

npcHandler:addModule(FocusModule:new())
