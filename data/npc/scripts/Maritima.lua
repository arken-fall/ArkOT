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

	if msgcontains(msg, "quara") then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 41 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.QuaraInky) < 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.QuaraSplasher) < 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.QuaraSharptooth) < 1 then
			npcHandler:say({
				"The quara in this area are a strange race that seeks for inner perfection rather than physical one. ...",
				"Considering that they are quara, they are rather peaceful as long no one enters their territory. ...",
				"However, recently the quara got mad because their area is flooded with toxic sewage from the city. If you could inform someone about it, they might stop the sewage and the quara could return to their own business.",
			}, cid)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 42)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission07, 3) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.QuaraState, 1)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
