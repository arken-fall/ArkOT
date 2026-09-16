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

	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest) == 2 and player:removeItem(136, 1) then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest, 3)
			npcHandler.topic[playerId] = 0
			player:addItem(5710, 1)
			player:addItem(3035, 10)
			player:addExperience(100, true)
			npcHandler:say("Yessss! Now I only need to build my own small brewery, figure out the secret recipe, duplicate the dwarvish brew and BANG I'll be back in business! Here take this as a reward.", cid)
		elseif player:getStorageValue(Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest) < 1 then
			npcHandler.topic[playerId] = 1
			npcHandler:say("Shush!! I don't want everybody to know what I am up to. Listen, things are not going too well, I need a new attraction. Do you want to help me?", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest, 1)
			player:addItem(138, 1)
			npcHandler:say("Good! Listen closely. Take this bottle and go to Kazordoon. I need a sample of their very special brown ale. You may find a cask in their brewery. Come back as soon as you got it.", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Hard Rock Racing Track, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
