local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local topic = {}

local config = {
	["50 blue cloth"] = { storageValue = 1, text = { "Brought the 50 pieces of blue cloth?", "Good. Get me 50 pieces of green cloth now." }, itemId = 5912, count = 50 },
	["50 green cloth"] = { storageValue = 2, text = { "Brought the 50 pieces of green cloth?", "Good. Get me 50 pieces of red cloth now." }, itemId = 5910, count = 50 },
	["50 red cloth"] = { storageValue = 3, text = { "Brought the 50 pieces of red cloth?", "Good. Get me 50 pieces of brown cloth now." }, itemId = 5911, count = 50 },
	["50 brown cloth"] = { storageValue = 4, text = { "Brought the 50 pieces of brown cloth?", "Good. Get me 50 pieces of yellow cloth now." }, itemId = 5913, count = 50 },
	["50 yellow cloth"] = { storageValue = 5, text = { "Brought the 50 pieces of yellow cloth?", "Good. Get me 50 pieces of white cloth now." }, itemId = 5914, count = 50 },
	["50 white cloth"] = { storageValue = 6, text = { "Brought the 50 pieces of white cloth?", "Good. Get me 10 spools of yarn now." }, itemId = 5909, count = 50 },
	["10 spools of yarn"] = { storageValue = 7, text = { "Brought the 10 spools of yarn?", "Thanks. That's it, you're done. Good job, |PLAYERNAME|. I keep my promise. Here's my old assassin head piece." }, itemId = 5886, count = 10 },
	["10 yarn"] = { storageValue = 7, text = { "Brought the 10 spools of yarn?", "Thanks. That's it, you're done. Good job, |PLAYERNAME|. I keep my promise. Here's my old assassin head piece." }, itemId = 5886, count = 10 },
}

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "addon") then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 156 or 152) and player:getStorageValue(Storage.Quest.U7_8.AssassinOutfits.AssassinFirstAddon) < 1 and player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.Shipwrecked) == 2 then
			npcHandler:say("Vescu gave you an assassin outfit? Haha. Noticed it lacks the head piece? You look a bit silly. Want my old head piece?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif config[msg] and npcHandler.topic[playerId] == 0 then
		if player:getStorageValue(Storage.Quest.U7_8.AssassinOutfits.AssassinFirstAddon) == config[msg].storageValue then
			npcHandler:say(config[msg].text[1], cid)
			npcHandler.topic[playerId] = 3
			topic[playerId] = msg
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Thought so. Could use some help anyway. Listen, I need stuff. Someone gave me a strange assignment - sneak into Thais castle at night and shroud it with cloth without anyone noticing it. ...",
				"I wonder why anyone would want to shroud a castle, but as long as long as the guy pays, no problem, I'll do the sneaking part. Need a lot of cloth though. ...",
				"Gonna make it colourful. Bring me 50 pieces of {blue cloth}, 50 pieces of {green cloth}, 50 pieces of {red cloth}, 50 pieces of {brown cloth}, 50 pieces of {yellow cloth} and 50 pieces of {white cloth}. ...",
				"Besides, gonna need 10 {spools of yarn}. Understood?",
			}, cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.Quest.U7_8.AssassinOutfits.AssassinFirstAddon, 1)
			npcHandler:say("Good. Start with the blue cloth. I'll wait.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 3 then
			local targetMessage = config[topic[playerId]]
			if not player:removeItem(targetMessage.itemId, targetMessage.count) then
				npcHandler:say("You don't have the required items.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U7_8.AssassinOutfits.AssassinFirstAddon, player:getStorageValue(Storage.Quest.U7_8.AssassinOutfits.AssassinFirstAddon) + 1)
			if player:getStorageValue(Storage.Quest.U7_8.AssassinOutfits.AssassinFirstAddon) == 8 then
				player:addOutfitAddon(156, 1)
				player:addOutfitAddon(152, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			npcHandler:say(targetMessage.text[2], cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] > 0 then
		npcHandler:say("Maybe another time.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

local function onReleaseFocus(cid)
	local playerId = cid:getId()
	topic[playerId] = nil
end

npcHandler:setMessage(MESSAGE_GREET, "What the... I mean, of course I sensed you.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:addModule(FocusModule:new())
