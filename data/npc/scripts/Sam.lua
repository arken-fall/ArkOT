local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Hello there, adventurer! Need a deal in weapons or armor? I\'m your man!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "adorn") or msgcontains(msg, "outfit") or msgcontains(msg, "addon") then
		local addonProgress = player:getStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet)
		if addonProgress == 5 then
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 6)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 6)
			player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmetTimer, os.time() + 7200) -- 2 hours
			npcHandler:say("Oh, Gregor sent you? I see. It will be my pleasure to adorn your helmet. Please give me some time to finish it.", cid)
		elseif addonProgress == 6 then
			if player:getStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmetTimer) < os.time() then
				player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.MissionHelmet, 0)
				player:setStorageValue(Storage.Quest.U7_8.KnightOutfits.AddonHelmet, 7)
				player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
				player:addOutfitAddon(131, 2)
				player:addOutfitAddon(139, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:say("Just in time, |PLAYERNAME|. Your helmet is finished, I hope you like it.", cid)
			else
				npcHandler:say("Please have some patience, |PLAYERNAME|. Forging is hard work!", cid)
			end
		elseif addonProgress == 7 then
			npcHandler:say("I think it's one of my masterpieces.", cid)
		else
			npcHandler:say("Sorry, but without the permission of Gregor I cannot help you with this matter.", cid)
		end
	elseif msgcontains(msg, "old backpack") or msgcontains(msg, "backpack") then
		if player:getStorageValue(Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc) < 1 then
			npcHandler:say("What? Are you telling me you found my old adventurer's backpack that I lost years ago??", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "2000 steel shields") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) ~= 29 or player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Contract) == 2 then
			npcHandler:say("My offers are weapons, armors, helmets, legs, and shields. If you'd like to see my offers, ask me for a {trade}.", cid)
			return true
		end

		npcHandler:say("What? You want to buy 2000 steel shields??", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "contract") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Contract) == 0 then
			npcHandler:say("Have you signed the contract?", cid)
			npcHandler.topic[playerId] = 4
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			if player:removeItem(3244, 1) then
				npcHandler:say({
					"Thank you very much! This brings back good old memories! Please, as a reward, travel to Kazordoon and ask my old friend Kroox to provide you a special dwarven armor. ...",
					"I will mail him about you immediately. Just tell him, his old buddy Sam is sending you.",
				}, cid)
				player:setStorageValue(Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc, 1)
				player:addAchievement("Backpack Tourist")
			else
				npcHandler:say("You don't have it...", cid)
			end
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say("I can't believe it. Finally I will be rich! I could move to Edron and enjoy my retirement! But ... wait a minute! I will not start working without a contract! Are you willing to sign one?", cid)
			npcHandler.topic[playerId] = 3
		elseif npcHandler.topic[playerId] == 3 then
			player:addItem(129, 1)
			npcHandler:say("Fine! Here is the contract. Please sign it. Talk to me about it again when you're done.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 4 then
			if not player:removeItem(128, 1) then
				npcHandler:say("You don't have a signed contract.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Contract, 1)
			npcHandler:say("Excellent! I will start working right away! Now that I am going to be rich, I will take the opportunity to tell some people what I REALLY think about them!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Then no.", cid)
		elseif table.contains({ 2, 3, 4 }, npcHandler.topic[playerId]) then
			npcHandler:say("This deal sounded too good to be true anyway.", cid)
		end
		npcHandler.topic[playerId] = 0
	end
	return true
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the blacksmith. If you need weapons or armor - just ask me." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my shop, adventurer |PLAYERNAME|! I {trade} with weapons and armor.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and come again, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and come again.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "It is rumoured to be a weapon beyond mortal craftsmanship." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "A threat for mankind! Buy weapons to be ready to face him." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "The king supports Tibia's economy a lot." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, I know that guy. He's a good customer at Frodo's. We don't really chat though." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "He is a monk of some kind!" })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, text = "Below our city are the sewers and I heard about a passage to the deeper dungeons." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah, these awful beasts. They live in the forests near the city and in the sewers and dungeons." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "A warrior who is a joy for Banor." })
keywordHandler:addKeyword({ "harkath" }, StdModule.say, { npcHandler = npcHandler, text = "A warrior who is a joy for Banor." })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Don't ask me. I have never been there." })
keywordHandler:addKeyword({ "sandals" }, StdModule.say, { npcHandler = npcHandler, text = "Sandals? I don't sell those. I only wear some myself, they're in the chest beside my bed. But they're not for sale, of course!" })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "Sorcerers seldom need my skills." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "A fine warrior." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "His guild relies heavily on my wares." })
keywordHandler:addKeyword({ "donald" }, StdModule.say, { npcHandler = npcHandler, text = "The McRonalds are the local farmers, aren't they?" })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "I never visited his ... cave or whatever it's called." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "Oswald isn't one of the most liked people in this city." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "I don't like crowded places like his bar." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "I just know some rumours that he is a follower of evil." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, I hardly know her." })
keywordHandler:addKeyword({ "sewer" }, StdModule.say, { npcHandler = npcHandler, text = "Below our city are the sewers and I heard about a passage to the deeper dungeons." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "Uhm! <blushes>" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Samuel, but you can call me Sam." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "The king supports Tibia's economy a lot." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He is funny now and then." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He can tell a tale or two about his adventures with baxter in their younger days." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "I supply the army with weapons and armor." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "I know nothing of interest." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "I was named after my grandfather." })

npcHandler:addModule(FocusModule:new())
