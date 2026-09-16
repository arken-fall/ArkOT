local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) >= 2 then
		player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.GuardcaughtYou, 1)
		player:removeCondition(CONDITION_OUTFIT)
		player:removeItem(11328, 1)
		player:teleportTo(Position(33361, 31206, 8))
		player:say("The guards have spotted you. You were forcibly dragged into a small cell. It looks like you need to build another disguise.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
