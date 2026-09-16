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

	if player:getSex() == PLAYERSEX_MALE and msgcontains(msg, "outfit") and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheOrcPowder) >= 34 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) >= 44 then
		if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.FirstOrientalAddon) < 1 then
			npcHandler:say("My scimitar? Yes, that is a true masterpiece. Of course I could make one for you, but I have a small request. Would you fulfil a task for me?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif player:getSex() == PLAYERSEX_MALE and msgcontains(msg, "comb") then
		if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.FirstOrientalAddon) == 1 then
			npcHandler:say("Have you brought a mermaid's comb for Ishina?", cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Listen, um... I know that Ishina has been wanting a comb for a long time... not just any comb, but a mermaid's comb. She said it prevents split ends... or something. ...",
				"Do you think you could get one for me so I can give it to her? I really would appreciate it.",
			}, cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.FirstOrientalAddon, 1)
			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.OrientalDoor, 1)
			npcHandler:say("Brilliant! I will wait for you to return with a mermaid's comb then.", cid)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 3 then
			if not player:removeItem(5945, 1) then
				npcHandler:say("No... that's not it.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end
			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.FirstOrientalAddon, 2)
			player:addOutfitAddon(146, 1) --male addon
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:say("Yeah! That's it! I can't wait to give it to her! Oh - but first, I'll fulfil my promise: Here is your scimitar! Thanks again!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] ~= 0 then
		npcHandler:say("Ah well. Doesn't matter.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

keywordHandler:addKeyword({ "weapons" }, StdModule.say, { npcHandler = npcHandler, text = "I sell the finest weapons in town. If you'd like to see my offers, ask me for a {trade}." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! See the fine {weapons} I sell.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye. Come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
