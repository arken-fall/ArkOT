local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)

	if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RascacoonShortcut) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"Hello my friend. What a delight to see you, even on a {busy} day. I see you already talked to my agent. I'm willing to lend you my boat if you want to take a {shortcut}. ...",
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello my friend. What a delight to see you, even on a busy day. You can check your status or ask me about the location of ongoing raids.")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "name") then
		npcHandler:say("I am Eustacio. At your service.", cid)
	elseif msgcontains(msg, "time") then
		npcHandler:say("It's just the time to make a fortune.", cid)
	elseif msgcontains(msg, "busy") or msgcontains(msg, "job") then
		npcHandler:say(" I am an aspiring businessman, who thrives to climb the ladder of success in the Venorean society.", cid)
	elseif msgcontains(msg, "shortcut") then
		if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RascacoonShortcut) == 1 then
			npcHandler:say({
				"You are trustworthy enough to take my boat. My agent made sure it takes me to their island. Do you want to take it?",
			}, cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			cid:teleportTo(Position(33774, 31347, 7))
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
