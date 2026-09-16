local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Id like to take a walk with Aurita.'},
	{text = 'I miss Aurita golden hair.*sigh*'},
	{text = 'Pas in boldly tyll thow com to an hall the feyrist undir sky ... *sings*'}
}
npcHandler:addModule(VoiceModule:new(voices))

-- On buy npc shop message
-- On sell npc shop message
-- On check npc shop message (look item)
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
				"Yes, there is something. It's a bit embarassing, you must promise not to tell anyone else. I'm in love with Aurita. Well, that wouldn't be a reson to be ashamed, but she is a mermaid. ...",
				"A faun on the other hand is inhabiting the forests, dancing with fairies and, well, nymphs. But I lost my heart to the lovely Aurita. I can't help it. We would love to spend some time together, but not just sitting on the beach. ...",
				"I'd love to show her the deep forest I love so much. I have an idea but I can't do it alone. Would you help me?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 1 then
			npcHandler:say({
				"There is a fairy who once told me about this spell. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, cid)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 2 and player:getItemCount(25782) >= 1 then
			npcHandler:say({
				"We are so happy. Now Aurita can take a walk on the beach. But I still can't visit her secret underwater grotto. To achieve this, we need something else: a very rare plant called raven herb. ...",
				"If eaten it allows an air breathing cid to breathe underwater for a while. Please find this plant for me. But know that you'll only find it at night. It resembles a common fern but its leaves are of a lighter green.",
			}, cid)
			player:removeItem(25782, 1)
			player:setStorageValue(ThreatenedDreams.Mission03[1], 3)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 4)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say({
				"Thank you! We are so happy. Now Aurita can take a walk on the beach. And I can visit her secret underwater grotto.",
			}, cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "sun catcher") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) == 3 then
			npcHandler:say({
				"Have you found some raven herb?",
			}, cid)
			npcHandler.topic[playerId] = 2
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 4 then
			npcHandler:say({
				"Thank you again, mortal being. A sun catcher is similar to a dream catcher but other than the latter it can preserve sunlight rather than bad dreams. I can craft one out of enchanted branches of a fairy tree as well as several enchanted gems. ...",
				"The branches are no problem, I will find some in the forest. But I don't have any gems. If you bring me some, I can craft a sun catcher for you. Do you have gems?",
			}, cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"That's very kind of you, my friend! Listen: I know there is a spell to transform her fishtail into legs. It is a temporary effect, so she could return to the ocean as soon as the spell ends. Unfortunately I don't know how to cast this spell. ...",
				"But there is a fairy who once told me about it. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission03[1], 1)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			if player:getItemCount(5953) > 0 then
				npcHandler:say({
					"Thank you, friend! Now I can visit Aurita in her underwater grotto!",
				}, cid)
				player:removeItem(5953, 1)
				npcHandler.topic[playerId] = 3
				player:setStorageValue(ThreatenedDreams.Mission03[1], 4)
			else
				npcHandler:say({
					"Please find this plant for me. But know that you'll only find it at night. It resembles a common fern but its leaves are of a lighter green.",
				}, cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 3 then
			if player:getStorageValue(ThreatenedDreams.Mission03.DarkSunCatcher) == 1 then
				npcHandler:say({
					"I already crafted one sun catcher for you.",
				}, cid)
			elseif player:getItemCount(675) >= 2 and player:getItemCount(676) >= 2 and player:getItemCount(677) >= 2 and player:getItemCount(678) >= 2 and player:getStorageValue(ThreatenedDreams.Mission03.DarkSunCatcher) < 1 then
				npcHandler:say({
					"Alright, I will craft a sun catcher for you.",
				}, cid)
				player:removeItem(675, 2)
				player:removeItem(676, 2)
				player:removeItem(677, 2)
				player:removeItem(678, 2)
				player:addItem(25733, 1)
				player:setStorageValue(ThreatenedDreams.Mission03.DarkSunCatcher, 1)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say({
					"I don't have any gems. If you bring me some, I can craft a sun catcher for you. Do you have gems?",
				}, cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say("Then not.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, mortal being!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May enlightenment be your path, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May enlightenment be your path, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, " Im carving bolts and arrows and i also craft bows anda spears.If you'd like to buy some ammunition, take a look.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
