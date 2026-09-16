local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- local function creatureSayCallback(npc, creature, type, message)
-- 	local player = Player(creature)
-- 	local playerId = player:getId()
-- 
-- 	if not npcHandler:checkInteraction(npc, creature) then
-- 		return false
-- 	end
-- 
-- 	local categoryTable = itemsTable[message:lower()]
-- 	if MsgContains(message, "mission") then
-- 		if player:getStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline) < 1 then
-- 			npcHandler:setTopic(playerId, 1)
-- 			npcHandler:say({
-- 				"Why yes, there is indeed some minor issue I could need your help with. I was always a friend of nature and it was not recently I discovered the joys of plants, growths, of all the flora around us. ...",
-- 				"Botany my friend. The study of plants is of great importance for our future. Many of the potions we often depend on are made of plants you know. Plants can help us tending our wounds, cure us from illness or injury. ...",
-- 				"I am currently writing an excessive compilation of all the knowledge I have gathered during my time here in Farmine and soon hope to publish it as 'Rabaz' Unabridged Almanach Of Botany'. ...",
-- 				"However, to actually complete my botanical epitome concerning Zao, I would need someone to enter these dangerous lands. Someone able to get closer to the specimens than I can. ...",
-- 				"And this is where you come in. There are two extremely rare species I need samples from. Typically not easy to come by but it should not be necessary to venture too far into Zao to find them. ...",
-- 				"Explore the anterior outskirts of Zao, use my almanach and find the two specimens with missing samples on their pages. The almanach can be found in a chest in my storage, next to my shop. It's the door over there. ...",
-- 				"If you lose it I will have to write a new one and put it in there again - which will undoubtedly take me a while. So keep an eye on it on your travels. ...",
-- 				"Once you find what I need, best use a knife to carefully cut and gather a leaf or a scrap of their integument and press it directly under their appropriate entry into my botanical almanach. ...",
-- 				"Simply return to me after you have done that and we will discuss your reward. What do you say, are you in?",
-- 			}, npc, creature)
-- 		elseif player:getStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline) == 3 then
-- 			npcHandler:setTopic(playerId, 2)
-- 			npcHandler:say("Well fantastic work, you gathered both samples! Now I can continue my work on the almanach, thank you very much for your help indeed. Can I take a look at my book please?", npc, creature)
-- 		end
-- 	elseif MsgContains(message, "yes") then
-- 		if npcHandler:getTopic(playerId) == 1 then
-- 			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
-- 			player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline, 1)
-- 			player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.ChestDoor, 0)
-- 			npcHandler:say("Yes? Yes! That's the enthusiasm I need! Remember to bring a sharp knife to gather the samples, plants - even mutated deformed plants - are very sensitive you know. Off you go and be careful out there, Zao is no place for the feint hearted mind you.", npc, creature)
-- 			npcHandler:setTopic(playerId, 0)
-- 		elseif npcHandler:getTopic(playerId) == 2 then
-- 			if player:removeItem(11699, 1) then
-- 				player:addItem(11700, 1)
-- 				player:addItem(3035, 10)
-- 				player:addExperience(3000, true)
-- 				player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline, 4)
-- 				npcHandler:say({
-- 					"Ah, thank you. Now look at that texture and fine colour, simply marvellous. ...",
-- 					"I hope the sun in the steppe did not exhaust you too much? Shellshock. A dangerous foe in the world of field science and exploration. ...",
-- 					"Here, I always wore this comfortable hat when travelling, take it. It may be of use for you on further reconnaissances in Zao. Again you have my thanks, friend.",
-- 				}, npc, creature)
-- 				npcHandler:setTopic(playerId, 0)
-- 			else
-- 				npcHandler:say("Oh, you don't have my book.", npc, creature)
-- 				npcHandler:setTopic(playerId, 0)
-- 			end
-- 		end
-- 	elseif categoryTable then
-- 		local remainingCategories = npc:getRemainingShopCategories(message:lower(), itemsTable)
-- 		npcHandler:say("Of course, just browse through my wares. You can also look at " .. remainingCategories .. ".", npc, player)
-- 		npc:openShopWindowTable(player, categoryTable)
-- 	end
-- 	return true
-- end

-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Ah, a customer! Please feel free to browse my wares, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
-- npcHandler:setMessage(MESSAGE_SENDTRADE, "Have a look. But perhaps you just want to see my " .. GetFormattedShopCategoryNames(itemsTable) .. ".")

npcHandler:addModule(FocusModule:new())
