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

	if msgcontains(msg, "cookie") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Lorbas) ~= 1 then
			npcHandler:say("You want me to eat this cookie?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Lorbas, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say("Well, you don't mind if I play around with this antidote rune a bit ... UHHH, YOU LOU ... uhm that was so ... funny, haha ... ha. Mhm, you better leave now.", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(npc, cid)
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("I see.", cid)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, dear traveller.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
