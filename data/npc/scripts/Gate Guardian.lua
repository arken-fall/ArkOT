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

	if msgcontains(msg, "mission") or msgcontains(msg, "pass") then
		if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 13 then
			npcHandler:say("You want entranzzze to zzze zzzity?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Mh, zzzezzze paperzzz zzzeem legit, I have orderzzz to let you pazzz. Zzzo be it.", cid)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 22)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission05, 2) --Questlog, Wrath of the Emperor "Mission 05: New in Town"
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Position(33114, 31197, 7), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Chhhhzzz. Ugly humanzzz! You better have a good reazzzon to be here!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
