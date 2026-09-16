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

	if msgcontains(msg, "eleonore") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.APoemForTheMermaid) == 2 and player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove) < 1 then
			npcHandler:say("I heard the birds sing about her beauty. But how could a human rival the enchanting beauty of a {mermaid}?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "mermaid") or msgcontains(msg, "marina") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Oh yes, I noticed that lovely mermaid. From afar of course. I would not dare to step into the eyes of such a lovely cid. ...",
				"... I guess I am quite shy. Oh my, if I were not blue, I would turn red now. If there would be someone to arrange a {date} with her.",
			}, cid)
			npcHandler.topic[playerId] = 2
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove) == 2 then
			npcHandler:say("Oh my. Its not easy to impress a mermaid I guess. Please get me a {love poem}. I think elves are the greatest poets so their city seems like a good place to look for one.", cid)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove, 3)
		end
	elseif msgcontains(msg, "date") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Will you ask the mermaid Marina if she would date me?", cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say("Thank you. How ironic, a human granting a djinn a wish.", cid)
			npcHandler.topic[playerId] = 0
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove, 1)
		elseif npcHandler.topic[playerId] == 4 then
			if player:removeItem(6119, 1) then
				npcHandler:say("Excellent. Here, with this little spell I enable you to recite the poem like a true elven poet. Now go and ask her for a date again.", cid)
				player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove, 4)
				player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.APoemForTheMermaid, 3)
				npcHandler.topic[playerId] = 0
			else
				npcHandler.topic[playerId] = 0
				npcHandler:say("You don't have it...", cid)
			end
		end
	elseif msgcontains(msg, "love poem") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove) == 3 then
			npcHandler:say("Did you get a love poem from Ab'Dendriel?", cid)
			npcHandler.topic[playerId] = 4
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, dear visitor |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
