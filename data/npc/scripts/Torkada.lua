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

	if player:getLevel() < 250 then
		npcHandler:say("You need at least level 250 to start our mission.", cid)
		return false
	end

	local access = player:kv():scoped("rotten-blood-quest"):get("access") or 0
	if access > 0 then
		if player:getStorageValue(Storage.Quest.U13_20.RottenBlood.AccessDoor) ~= 1 then
			player:setStorageValue(Storage.Quest.U13_20.RottenBlood.AccessDoor, 1)
		end
		npcHandler:say("You already have accepted this mission.", cid)
		npcHandler.topic[playerId] = 0
		return true
	end

	msg = msg:lower()
	if msgcontains(msg, "time") then
		npcHandler:say("This expedition is here on an important {mission} for the inquisition", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "mission") and npcHandler.topic[playerId] == 1 then
		npcHandler:say("Are you willing, to bring the fury of the inquisition to that foul place and eradicate all evil you find? Speak, {yes} or {no}?", cid)
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 2 then
		npcHandler.topic[playerId] = 0
		npcHandler:say({
			"So hereby receive the blessings of the gods, provided by me as the voice of the inquisition! ...",
			"Go now and search the ancient temple in the north-west part of the drefian ruins. Slay the evil that lurks there and cleanse the foul place from its taint!",
		}, cid)
		player:kv():scoped("rotten-blood-quest"):set("access", 1)
		player:setStorageValue(Storage.Quest.U13_20.RottenBlood.AccessDoor, 1)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] == 1 then
		npcHandler.topic[playerId] = 0
		npcHandler:say("Ok then not.", cid)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings! This isn't the {time} to chitchat though.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
