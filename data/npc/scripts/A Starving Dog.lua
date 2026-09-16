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

	if msgcontains(msg, "meat") then
		if player:removeItem(3577, 1) then
			npcHandler:say("<munch>", cid)
			if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Mission01) == 1 then
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline, 2)
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.Mission01, 2) -- Questlog The Ice Islands Quest, Befriending the Musher
			end
			npcHandler:releaseFocus(cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "")
keywordHandler:addGreetKeyword({ "sniffler" }, { npcHandler = npcHandler, text = "<sniff>" })
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
