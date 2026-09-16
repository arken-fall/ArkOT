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

	if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15) == 3 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"He murdered me. I shouldn't have trusted him! The money! All that money blinded me! To the east I brought his stuff. In night and darkness, covered by some kind of magic of his. The minotaurs did not bother us, like he promised. ...",
			"His ... his true name is Shargon and he is a priest of some kind. He belongs to a powerful secret society and is looking for something on their behalves. ...",
			"We brought his stuff to a hideout, I'll mark it on your map! The things that I've seen there! Horrible, horrible things! I fled, but he found me, killed me. He murdered me!",
		})
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16, 1)
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hi!")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message) end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
