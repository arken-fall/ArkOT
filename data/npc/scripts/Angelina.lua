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

	if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonWand) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The gods must be praised that I am finally saved. I do not have many worldly possessions, but please accept a small reward, do you?")
	elseif player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonWand) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Thanks for saving my life! Should I teleport you out of the Dark Cathedral?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "yes") then
		if player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonWand) < 1 then
			npcHandler:say("I will tell you a small secret now. My friend Lynda in Thais can create a blessed wand. Greet her from me, maybe she will aid you.", cid)
			player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonWand, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, "May the gods bless you.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May the gods bless you.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
