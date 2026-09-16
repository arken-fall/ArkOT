local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) < 1 then
			npcHandler:say({
				"Yes, there is something. I'm in love with Taegen, but he is a faun. As such he's inhabiting the forests, dancing with fairies. And I, being a mermaid, am living in the ocean, swimming with the fish between coral reefs. ...",
				"But I lost my heart to Taegen, I can't help it. We would love to spend some time together, but not just sitting on the beach. ...",
				"I'd love to show him my homestead beneath the waves. I have an idea but I can't do it alone. Would you help me?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 1 then
			npcHandler:say({
				"There is a fairy who once told me about this spell. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, cid)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) >= 2 and player:getStorageValue(ThreatenedDreams.Mission03[1]) <= 3 then
			npcHandler:say({
				"The spell works! I already took a walk on the beach last night in the moonlight. Please talk to Taegen now, he may have another request.",
			}, cid)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say({
				"Thank you again, friend! Taegen and I we're so happy now.",
			}, cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "starlight vial") or msgcontains(msg, "empty starlight vial") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) == 4 then
			if player:getStorageValue(ThreatenedDreams.Mission03.EmptyStarlightVial) < 1 then
				npcHandler:say({
					"Thank you, friend! Please take the starlight vial. It is made of a very rare kind of enchanted glass and magical metals, so it is able to preserve starlight. ...",
					"A long time ago a pixie knight of Maelyrra carried it with her. But when she was flying above the waves she accidentally dropped it and it sunk. I found it but now you may take it and use it to help Feyrist.",
				}, cid)
				player:addItem(25731, 1)
				player:setStorageValue(ThreatenedDreams.Mission03.EmptyStarlightVial, 1)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say({
					"I already gave you the empty starlight vial.",
				}, cid)
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"That's very kind of you, my friend! Listen: I know there is a spell to transform my fishtail into legs. It is a temporary effect, so I could return to the ocean as soon as the spell ends. Unfortunately I don't know how to cast this spell. ...",
				"But there is a fairy who once told me about it. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission03[1], 1)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 1)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say("Then not.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path always be even.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May your path always be even.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
