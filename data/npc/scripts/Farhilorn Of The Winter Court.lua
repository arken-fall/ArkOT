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

	if msgcontains(msg, "fight") then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission) < 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheWinterCourt) == 1 then
			npcHandler:say("We allow able champions of all races to fight for our cause against the challenges of the {arena}. So are you interested? I'm not interested in fancy'wordplay, so a simple {yes} or {no} will suffice!", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("You are now able to enter the teleport.", cid)
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission, 1)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say("As you wish.", cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "arena") then
		npcHandler:say("This place has always been a site where the champions of summer and winter have clashed in battle. Over the centuries this spectacle has drawn many creatures here to watch, participate and indulge in less savory activities.", cid)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello fighter. I guess you are here to {fight} for our noble {cause}.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
