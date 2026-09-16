local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function endConversationWithDelay(npcHandler, npc, creature)
	addEvent(function()
		npcHandler:unGreet(npc, creature)
	end, 1000)
end

local function greetCallback(cid)
	local player = Player(cid)
	local fire = player:getCondition(CONDITION_FIRE)

	if fire and (player:hasOutfit(156) or player:hasOutfit(152)) then
		return true
	end

	endConversationWithDelay(npcHandler, cid)
	return false
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if msgcontains(msg, "addon") or msgcontains(msg, "outfit") then
		if getPlayerStorageValue(cid, Storage.Atrad) < 1 then
			npcHandler:say("You managed to deceive Erayo? Impressive. Well, I guess, since you have come that far, I might as well give you a task too, eh?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "nose ring") or msgcontains(msg, "ring") then
		if getPlayerStorageValue(cid, Storage.Atrad) == 1 then
			if (getPlayerItemCount(cid, 5804) >= 1) and getPlayerItemCount(cid, 5930) >= 1 then
				npcHandler:say("I see you brought my stuff. Good. I'll keep my promise: Here's katana in return.", cid)
				doPlayerRemoveItem(cid, 5804, 1)
				doPlayerRemoveItem(cid, 5930, 1)
				doPlayerAddOutfit(cid, getPlayerSex(cid) == 0 and 156 or 152, 2)
				setPlayerStorageValue(cid, Storage.Atrad, 2)
				setPlayerStorageValue(cid, Storage.Quest.U7_8.AssassinOutfits.AssassinSecondAddon, 2)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You don't have it...", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Okay, listen up. I don't have a list of stupid objects, I just want two things. A behemoth claw and a nose ring. Got that?", cid)
			npcHandler.topic[playerId] = 3
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say("Good. Come back then you have BOTH. Should be clear where to get a behemoth claw from. There's a horned fox who wears a nose ring. Good luck.", cid)
			setPlayerStorageValue(cid, Storage.Atrad, 1)
			setPlayerStorageValue(cid, Storage.Quest.U7_8.AssassinOutfits.AssassinSecondAddon, 1)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
