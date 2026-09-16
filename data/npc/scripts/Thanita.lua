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

	-- Check if NPC can interact with the cid
	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Check if the msg contains "mission"
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) == 1 and player:removeItem(140, 1) then
			npcHandler:say({
				"Oh great! Supplies from Carlin! Let me see ...<she digs into the parcel>...ahh, nothing meaningful at all, like always. Well, before I give you the password for the delivery, you have to help me! ...",
				"I have massive problems with the goblin tribe that lives here. You look strong enough to face their leader but you need to be smart to lure him out. ...",
				"I heard they don't like fire very much, maybe that's worth a try. Their beds are mostly made of straw which is known as easily inflammable. ...",
				"The entrance to their cave is at the pond south east of here.",
			}, cid)
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 2)
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Door, 2)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) == 3 then
			npcHandler:say("Impressive!! I could need someone like you here at the watchtower! Okay, the password you need to tell Bunny is ' password* '. Come back and visit me if you like to!", cid)
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 4)
			npcHandler.topic[playerId] = 0
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "How could you sneak up on me like this? I thought you were one of THEM! Well, since you are not, what brings you to this wilderness?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take good care of yourself traveller. Would be a shame to lose such a courageous wanderer to those green monsters.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take good care of yourself traveller. Would be a shame to lose such a courageous wanderer to those green monsters.")

npcHandler:addModule(FocusModule:new())
