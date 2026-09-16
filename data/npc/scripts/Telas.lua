local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "farmine") and player:getStorageValue(TheNewFrontier.Questline) == 14 then
		if player:getStorageValue(TheNewFrontier.Mission05.Telas) == 1 then
			npcHandler:say("I have heard only little about this mine. I am a bit absorbed in my studies. But what does this mine have to do with me?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("You are starting this discussion again? Why should I listen to you this time, do you have anything to convince me to let you even try?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "reason") or msgcontains(msg, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.TelasKeyword) <= 2 and player:getStorageValue(TheNewFrontier.Mission05.Telas) == 1 then
		if npcHandler.topic[playerId] == 1 then
			if msgcontains(msg, "reason") and player:getStorageValue(TheNewFrontier.Mission05.TelasKeyword) == 1 then
				npcHandler:say("Well it sounds like a good idea to test my golems in some real environment. I think it is acceptable to send some of them to Farmine.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Telas, 3)
			elseif msgcontains(msg, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.TelasKeyword) == 2 then
				npcHandler:say("Well, of course my worker golems are quite usefull and it might indeed be a good idea to see who they operate on realistic conditions. I will send some to farmine soon.", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Telas, 3)
			end
			player:setStorageValue(TheNewFrontier.Mission05.TelasKeyword, 3)
		end
	elseif msgcontains(msg, "plea") and player:getStorageValue(TheNewFrontier.Mission05.TelasKeyword) == 3 and player:getStorageValue(TheNewFrontier.Mission05.Telas) == 1 then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Well, if the situation is that desperate I think it is possible to send some of the golems to help the poor dwarfs out of their misery.", cid)
			player:setStorageValue(TheNewFrontier.Mission05.Telas, 3)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			if player:getStorageValue(TheNewFrontier.Mission05.Telas) == 2 and player:removeItem(10027, 1) then
				npcHandler:say("Oh how nice of you. I might have misjudged you. So let us return to this matter of worker golems. Do you have any better arguments this time?", cid)
				player:setStorageValue(TheNewFrontier.Mission05.Telas, 1)
				npcHandler.topic[playerId] = 1
			end
		end
	else
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and player:getStorageValue(TheNewFrontier.Mission05.Telas) == 1 then
			npcHandler:say("Wrong Word.", cid)
			player:setStorageValue(TheNewFrontier.Mission05.Telas, 2)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
