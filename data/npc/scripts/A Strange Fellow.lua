local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local npc = Npc()
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03) ~= 1 then
		return true
	end
	if msgcontains(msg, "bill") then
		if npcHandler.topic[playerId] == 6 then
			npcHandler:say("A bill? Oh boy so you are delivering another bill to poor me?", cid)
			npcHandler.topic[playerId] = 7
		end
	elseif msgcontains(msg, "yes") then
		if player:removeItem(3216, 1) and npcHandler.topic[playerId] == 7 then
			npcHandler:say("Ok, ok, I'll take it. I guess I have no other choice anyways. And now leave me alone in my misery please.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03, 2)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "hat") then
		if npcHandler.topic[playerId] < 1 then
			npcHandler:say("Uh? What do you want?!", cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say("What? My hat?? Theres... nothing special about it!", cid)
			npcHandler.topic[playerId] = 3
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say("Stop bugging me about that hat, do you listen?", cid)
			npcHandler.topic[playerId] = 4
		elseif npcHandler.topic[playerId] == 4 then
			npcHandler:say("Hey! Don't touch that hat! Leave it alone!!! Don't do this!!!!", cid)
			npcHandler.topic[playerId] = 5
		elseif npcHandler.topic[playerId] == 5 then
			for i = 1, 5 do
				Game.createMonster("Rabbit", npc:getPosition())
			end
			npcHandler:say("Noooooo! Argh, ok, ok, I guess I can't deny it anymore, I am David Brassacres, the magnificent, so what do you want?", cid)
			npcHandler.topic[playerId] = 6
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
