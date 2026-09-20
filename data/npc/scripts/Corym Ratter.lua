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

	if player:getStorageValue(HiddenThreats.QuestLine) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"Welcome stranger! You might be surprised that I don't attack you immediately. The point is, that I think you could be useful to me. What you see in front of you is a great mine of the corym! ...",
			"We dig up all what mother earth delivers to us, valuable natural resources. But the yield is getting worse and here I need your {help}.",
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, "We dig up all what mother earth delivers to us, valuable natural resources.")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "help") then
		npcHandler:say("Recently the amount of delivered ores is decreasing. Could you find out the reason, why the situation has become worse?", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
			player:setStorageValue(HiddenThreats.QuestLine, 1)
			player:setStorageValue(HiddenThreats.RatterDoor, 1)
			npcHandler:say("Nice! I have opened the mine for you. But take care of you! The monsters of depth won't spare you.", cid)
			npcHandler.topic[playerId] = 2
		end
	end
	return true
end

-- Greeting message
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
