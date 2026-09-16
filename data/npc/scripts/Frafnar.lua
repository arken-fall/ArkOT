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
		if player:getStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.SweetAsChocolateCake) < 1 then
			npcHandler:say("There is indeed something you could do for me. You must know, I'm in love with Bolfana. I'm sure she'd have a beer with me if I got her a chocolate cake. Problem is that I can't leave this door as I'm on duty. Would you be so kind and help me?", cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.SweetAsChocolateCake) == 2 then
			npcHandler:say("So did you tell her that the cake came from me?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			player:setStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.SweetAsChocolateCake, 1)
			player:setStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.DefaultStart, 1)
			npcHandler:say("Great! She works in the tavern of Beregar. It's situated in the western part of the city. Bring her a chocolate cake and tell her that it was me who sent it.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say({
				"Great! That's my breakthrough. Now she can't refuse to go out with me. I grant you access to the western part of the mine.",
				"So did you tell her that the cake came from me?",
			}, cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] == 3 then
		npcHandler:say("I hope your kidding 'cause I'll find out WHAT you've told her and I can get reeeeaaaalllly angry. I grant you access to the western part of the mine.....for NOW.", cid)
		player:setStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.SweetAsChocolateCake, 3)
		player:setStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.DoorWestMine, 1)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "Don't you see that I'm trying to write a poem? <sighs> So what's the matter?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
