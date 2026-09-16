local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local tomes = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "rice") and player:getStorageValue(tomes) > 3 then
		npcHandler:say("Aaargh! Cael and his strange thoughts! He bugged me so long about the lizard culture that I eventually agreed to prepare that rice for you if you need it. I need one ripe rice plant to prepare ten rice balls. OK?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:getItemCount(10328) > 0 then
			npcHandler:say(string.format("Here you go. %d rice balls. Hope you buy a beer with them at least.", player:getItemCount(10328) * 10), npc, creature)
			player:addItem(10329, player:getItemCount(10328) * 10)
			player:removeItem(10328, player:getItemCount(10328))
		else
			npcHandler:say("You don't have a ripe rice plant. Thank fire and earth I was spared.", npc, creature)
		end
	end
	return true
end

npcHandler:addModule(FocusModule:new())
