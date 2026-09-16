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

	if msgcontains(msg, "yes") and npcHandler.topic[playerId] == 0 then
		npcHandler:say({
			"There are three questions. First: What is the name of the princess who fell in love with a Thaian nobleman during the regency of pharaoh Uthemath? Second: Who is the author of the book ,The Language of the Wolves'? ...",
			"Third: Which ancient Tibian race reportedly travelled the sky in cloud ships? Can you answer these questions?",
		}, cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("So I ask you: What is the name of the princess who fell in love with a Thaian nobleman during the regency of pharaoh Uthemath?", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "Tahmehe") and npcHandler.topic[playerId] == 2 then
		npcHandler:say("That's right. Listen to the second question: Who is the author of the book ,The Language of the Wolves'?", cid)
		npcHandler.topic[playerId] = 3
	elseif msgcontains(msg, "Ishara") and npcHandler.topic[playerId] == 3 then
		npcHandler:say("That's right. Listen to the third question: Which ancient Tibian race reportedly travelled the sky in cloud ships?", cid)
		npcHandler.topic[playerId] = 4
	elseif msgcontains(msg, "Svir") and npcHandler.topic[playerId] == 4 then
		npcHandler:say("That is correct. You satisfactorily answered all questions. You may pass and enter Gelidrazah's lair.", cid)
		npcHandler.topic[playerId] = 0
		player:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.GelidrazahAccess, 1)
	else
		npcHandler:say("I don't know what you are talking about.", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Have you come to answer Gelidrazah's questions?")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See you, |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new())
