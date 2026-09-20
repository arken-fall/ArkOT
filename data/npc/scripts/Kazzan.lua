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

local function greetCallback(npc, cid, msg)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 35 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.ScaredKazzan) ~= 1 and player:getOutfit().lookType == 65 then
		player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.ScaredKazzan, 1)
		npcHandler:say("WAAAAAHHH!!!", cid)
		endConversationWithDelay(npcHandler, cid)
		return false
	end

	npcHandler:say("Feel welcome in the lands of the children of the enlightened Daraman, |PLAYERNAME|.", cid)
	npcHandler:setInteraction(npc, cid)

	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") and player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) < 1 then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor) < 1 and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.EfreetDoor) < 1 then
			npcHandler:say("Do you know the location of the djinn fortresses in the mountains south of here?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif npcHandler.topic[playerId] == 1 and msgcontains(msg, "yes") then
		npcHandler:say({
			"Alright. The problem is that I want to know at least one of them on my side. You never know. I don't mind if it's the evil Efreet or the Marid. ...",
			"Your mission will be to visit one kind of the djinns and bring them a peace-offering. Are you interested in that mission?",
		}, cid)
		npcHandler.topic[playerId] = 2
	elseif npcHandler.topic[playerId] == 2 and msgcontains(msg, "yes") then
		npcHandler:say({
			"Very good. I hope you are able to convince one of the fractions to stand on our side. If you haven't done yet, you should first go and look for old Melchior in Ankrahmun. ...",
			"He knows many things about the djinn race and he may have some hints for you.",
		}, cid)
		if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart) <= 0 then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
		end
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest, 1)
		-- Entregando
	elseif player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) == 3 then
		npcHandler:say("Well, I don't blame you for that. I am sure you did your best. Now we can just hope that peace remains. Here, take this small gratification for your effort to help and Daraman may bless you!", cid)
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest, player:getStorageValue(Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest) + 1)
		player:addItem(3035, 20)
	end

	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
