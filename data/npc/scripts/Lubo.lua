local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Stop by and rest a while, tired adventurer! Have a look at my wares!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Citizen outfit addon
	local addonProgress = player:getStorageValue(Storage.Quest.U7_8.CitizenOutfits.AddonBackpack)
	if msgcontains(msg, "addon") or msgcontains(msg, "outfit") or (addonProgress == 1 and msgcontains(msg, "leather")) or ((addonProgress == 1 or addonProgress == 2) and msgcontains(msg, "backpack")) then
		if addonProgress < 1 then
			npcHandler:say("Sorry, the backpack I wear is not for sale. It's handmade from rare minotaur leather.", cid)
			npcHandler.topic[playerId] = 1
		elseif addonProgress == 1 then
			npcHandler:say("Ah, right, almost forgot about the backpack! Have you brought me 100 pieces of minotaur leather as requested?", cid)
			npcHandler.topic[playerId] = 3
		elseif addonProgress == 2 then
			if player:getStorageValue(Storage.Quest.U7_8.CitizenOutfits.AddonBackpackTimer) < os.time() then
				npcHandler:say("Just in time! Your backpack is finished. Here you go, I hope you like it.", cid)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.MissionBackpack, 0)
				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.AddonBackpack, 3)
				player:addOutfitAddon(136, 1)
				player:addOutfitAddon(128, 1)
			else
				npcHandler:say("Uh... I didn't expect you to return that early. Sorry, but I'm not finished yet with your backpack. I'm doing the best I can, promised.", cid)
			end
		elseif addonProgress == 3 then
			npcHandler:say("Sorry, but I can only make one backpack per person, else I'd have to close my shop and open a leather manufactory.", cid)
		end
		return true
	end
	if npcHandler.topic[playerId] == 1 then
		if msgcontains(msg, "backpack") or msgcontains(msg, "minotaur") or msgcontains(msg, "leather") then
			npcHandler:say("Well, if you really like this backpack, I could make one for you, but minotaur leather is hard to come by these days. Are you willing to put some work into this?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "yes") then
			player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.AddonBackpack, 1)
			player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.MissionBackpack, 1)
			npcHandler:say("Alright then, if you bring me 100 pieces of fine minotaur leather I will see what I can do for you. You probably have to kill really many minotaurs though... so good luck!", cid)
			npcHandler:releaseFocus(cid)
		else
			npcHandler:say("Sorry, but I don't run a welfare office, you know... no pain, no gain.", cid)
		end
		npcHandler.topic[playerId] = 0
	elseif npcHandler.topic[playerId] == 3 then
		if msgcontains(msg, "yes") then
			if player:getItemCount(5878) < 100 then
				npcHandler:say("Sorry, but that's not enough leather yet to make one of these backpacks. Would you rather like to buy a normal backpack for 10 gold?", cid)
			else
				npcHandler:say("Great! Alright, I need a while to finish this backpack for you. Come ask me later, okay?", cid)

				player:removeItem(5878, 100)

				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.MissionBackpack, 2)
				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.AddonBackpack, 2)
				player:setStorageValue(Storage.Quest.U7_8.CitizenOutfits.AddonBackpackTimer, os.time() + 2 * 60 * 60)
			end
		else
			npcHandler:say("I know, it's quite some work... don't lose heart, just keep killing minotaurs and you'll eventually get lucky. Would you rather like to buy a normal backpack for 10 gold?", cid)
		end
		npcHandler.topic[playerId] = 0
	end

	-- The paradox tower quest
	if msgcontains(msg, "crunor's cottage") then
		npcHandler:say("Ah yes, I remember my grandfather talking about that name. This house used to be an inn a long time ago. My family bought it from some of these flower guys.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "flower guys") then
		npcHandler:say("Oh, I mean druids of course. They sold the cottage to my family after some of them died in an accident or something like that.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "accident") then
		npcHandler:say("As far as I can remember the story, a pet escaped its stable behind the inn. It got somehow involved with powerful magic at a ritual and was transformed in some way.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "stable") then
		if player:getStorageValue(Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo) == 3 then
			-- Questlog: The Feared Hugo (Completed)
			player:setStorageValue(Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo, 4)
		end
		npcHandler:say("My grandpa told me, in the old days there were some behind this cottage. Nothing big though, just small ones, for chicken or rabbits.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am selling equipment for adventurers. If you need anything, let me know." })
keywordHandler:addKeyword({ "dog" }, StdModule.say, { npcHandler = npcHandler, text = "This is Ruffy my dog, please don't do him any harm." })
keywordHandler:addKeyword({ "offer" }, StdModule.say, { npcHandler = npcHandler, text = "I sell torches, fishing rods, worms, ropes, water hoses, backpacks, apples, and maps." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Lubo, the owner of this shop." })
keywordHandler:addKeyword({ "maps" }, StdModule.say, { npcHandler = npcHandler, text = "Oh! I'm sorry, I sold the last one just five minutes ago." })
keywordHandler:addKeyword({ "hat" }, StdModule.say, { npcHandler = npcHandler, text = "My hat? Hanna made this one for me." })
keywordHandler:addKeyword({ "finger" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, you sure mean this old story about the mage Dago, who lost two fingers when he conjured a dragon." })
keywordHandler:addKeyword({ "pet" }, StdModule.say, { npcHandler = npcHandler, text = "There are some strange stories about a magicians pet names. Ask Hoggle about it." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my adventurer shop, |PLAYERNAME|! What do you need? Ask me for a {trade} to look at my wares.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "mountain" }, StdModule.say, { npcHandler = npcHandler, text = "It is said that once there lived a great magician on the top of this mountain." })
keywordHandler:addKeyword({ "magician" }, StdModule.say, { npcHandler = npcHandler, text = "I don't remember his name, but it's said that his banner was the black eye." })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, text = "If you want to buy weapons, you'll have to go to a town or city." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "There's a lot of magic flowing in the mountain to the north." })
keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, text = "I sell the best apples in Tibia." })
keywordHandler:addKeyword({ "inn" }, StdModule.say, { npcHandler = npcHandler, text = "Frodo runs a nice inn in the near town Thais." })

npcHandler:addModule(FocusModule:new())
