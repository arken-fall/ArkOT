local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
local function greetCallback(npc, cid, msg)
	local player = Player(cid)

	if player:getStorageValue(HiddenThreats.CorymRescued07) < 0 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"My hero! A friend of mine sent you to liberate me? A true friend! I am poor but nevertheless I give you this as little reward.",
		})
		player:setStorageValue(HiddenThreats.CorymRescueMission, player:getStorageValue(HiddenThreats.CorymRescueMission) + 1)
		player:setStorageValue(HiddenThreats.CorymRescued07, 1)
		player:addItem(3029, 1)
	else
		npcHandler:setMessage(MESSAGE_GREET, "My hero! A friend of mine sent you to liberate me? A true friend!")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	--local player = Player(cid)

	if not npcHandler:isFocused(cid) then
		return false
	end
	return true
end

-- Greeting message
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
