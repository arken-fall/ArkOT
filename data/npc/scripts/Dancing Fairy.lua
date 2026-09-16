local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "spell") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) == 1 and player:getStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple) == 1 then
			npcHandler:say({
				"So, you are searching for a way to transform Aurita's fishtail into legs temporarily. As you might already have figured out you need some magic for this purpose. There is a place on Feyrist where you can find the arcane energies you need. ...",
				"Northeast from here you'll discover a big lake with a small island. Take a swim there and you will find a magical fountain. If you play the panpipes while standing near this fountain, you will create some magical music notes. ...",
				"Collect them and give them to Aurita. Each of those notes will grant her a walk on the beach with Taegen.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 2)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say({
				"Each of those notes will grant her a walk on the beach with Taegen.",
			}, cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"That's very kind of you, my friend! Listen: I know there is a spell to transform my fishtail into legs. It is a temporary effect, so I could return to the ocean as soon as the spell ends. Unfortunately I don't know how to cast this spell. ...",
				"But there is a fairy who once told me about it. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 1)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say("Then not.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Nature's blessing!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path always be even.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May your path always be even.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
