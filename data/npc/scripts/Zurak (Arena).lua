local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "trip") or msgcontains(msg, "passage") then
		if player:getStorageValue(TheNewFrontier.Questline) >= 24 then
			npcHandler:say("You want trip to Izzle of Zzao?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("You need permission to travel to.", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("It'zz done your travel to.", cid)
			local destination = Position(33158, 31227, 7)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Zzoftzzkinzz zzo full of fear.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "hurry") or msgcontains(msg, "job") then
		npcHandler:say("Me zzimple ferryman. I arrange {trip} to Zzao.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
