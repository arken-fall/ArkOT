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

	if msgcontains(msg, "fugio") then
		if player:getStorageValue(Storage.Quest.U7_24.FamilyBrooch.Brooch) == 1 then
			npcHandler:say(
				"To be honest, I fear the omen in my dreams may be true. \z
					Perhaps Fugio is unable to see the danger down there. \z
					Perhaps ... you are willing to investigate this matter?", cid
			)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "diary") then
		if player:getStorageValue(Storage.Quest.U7_24.TheWhiteRavenMonastery.Diary) == 1 then
			npcHandler:say("Do you want me to inspect a diary?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "holy water") then
		local cStorage = player:getStorageValue(Storage.Quest.U8_1.RestInHallowedGround.Questline)
		if cStorage == 1 then
			npcHandler:say("Who are you to demand holy water from the White Raven Monastery? Who sent you??", cid)
			npcHandler.topic[playerId] = 3
		elseif cStorage == 2 then
			npcHandler:say("I already filled your vial with holy water.", cid)
		end
	elseif msgcontains(msg, "amanda") and npcHandler.topic[playerId] == 0 then
		if player:getStorageValue(Storage.Quest.U8_1.RestInHallowedGround.Questline) == 1 then
			npcHandler:say("Ahh, Amanda from Edron sent you! I hope she's doing well. So why did she send you here?", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Thank you very much! From now on you may open the warded doors to the catacombs.", cid)
			player:setStorageValue(Storage.Quest.U7_24.TheWhiteRavenMonastery.Diary, 1)
			player:setStorageValue(Storage.Quest.U7_24.TheWhiteRavenMonastery.Door, 1)
		elseif npcHandler.topic[playerId] == 2 then
			if not player:removeItem(3212, 1) then
				npcHandler:say("Uhm, as you wish.", cid)
				return true
			end

			npcHandler:say("By the gods! This is brother Fugio's handwriting and what I read is horrible indeed! You have done our order a great favour by giving this diary to me! Take this blessed Ankh. May it protect you in even your darkest hours.", cid)
			player:addItem(3214, 1)
			player:setStorageValue(Storage.Quest.U7_24.TheWhiteRavenMonastery.Diary, 2)
		end
	elseif npcHandler.topic[playerId] == 3 then
		if not msgcontains(msg, "amanda") then
			npcHandler:say("I never heard that name and you won't get holy water for some stranger.", cid)
			npcHandler.topic[playerId] = 0
			return true
		end

		player:addItem(133, 1)
		player:setStorageValue(Storage.Quest.U8_1.RestInHallowedGround.Questline, 2)
		npcHandler:say("Ohh, why didn't you tell me before? Sure you get some holy water if it's for Amanda! Here you are.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "no") and table.contains({ 1, 2 }, npcHandler.topic[playerId]) then
		npcHandler:say("Uhm, as you wish.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Feel free to tell me what has brought you here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Costello." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm the abbot of the White Raven Monastery on the Isle of the Kings." })
keywordHandler:addKeyword({ "isle" }, StdModule.say, { npcHandler = npcHandler, text = "We founded our monastery to guard the royal tombs and to gather wisdom and knowledge." })
keywordHandler:addKeyword({ "wisdom" }, StdModule.say, { npcHandler = npcHandler, text = "You may enter the library upstairs. Don't go any further upstairs, though, as this area is reserved for members of our order." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "That's the name of our world and its major continent." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "They created Tibia and all life on it." })
keywordHandler:addKeyword({ "life" }, StdModule.say, { npcHandler = npcHandler, text = "There are many different life forms in our world: plants, citizens, and monsters." })
keywordHandler:addKeyword({ "plant" }, StdModule.say, { npcHandler = npcHandler, text = "Just walk around, you'll see grass, trees, bushes and beautiful flowers." })
keywordHandler:addKeyword({ "white raven" }, StdModule.say, { npcHandler = npcHandler, text = "The legend tells us of a white raven which led the ship of the first monk of our order here. He discovered this isle and the caves beneath it." })
keywordHandler:addKeyword({ "order" }, StdModule.say, { npcHandler = npcHandler, text = "We founded our monastery to guard the royal tombs and to gather wisdom and knowledge." })
keywordHandler:addKeyword({ "caves" }, StdModule.say, { npcHandler = npcHandler, text = "Anselm, the first monk of our order, discovered them while looking for a suitable burial place for his king." })
keywordHandler:addKeyword({ "anselm" }, StdModule.say, { npcHandler = npcHandler, text = "He was a humble and pious man, and he was chosen by the royal family of Thais to find a resting place for their dead." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "The deceased leaders of the Thaian empire rest beneath this monastery in tombs and crypts." })
keywordHandler:addKeyword({ "knowledge" }, StdModule.say, { npcHandler = npcHandler, text = "You may enter the library upstairs. Don't go any further upstairs, though, as this area is reserved for members of our order." })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "I was informed you have won the trust of the fisher Windtrouser so your passage should be granted." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "Don't mention this servant of evil here." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "Sadly we have only little knowledge about this topic." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, we rarely hear anything new here." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "There are really too many of them in Tibia. But who are we to question the wisdom of the gods?" })
keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You aren't looking that bad. Sorry, I can't help you" })

npcHandler:addModule(FocusModule:new())
