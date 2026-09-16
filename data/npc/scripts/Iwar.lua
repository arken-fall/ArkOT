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

	local valuePicture = 10000

	if msgcontains(msg, "has the cat got your tongue?") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 4 then
		npcHandler:say("Nice. You like your picture, haa? Give me 10,000 gold and I will deliver it to the museum. Do you {pay}?", cid)
		npcHandler.topic[playerId] = 2
		npcHandler.topic[playerId] = 2
	elseif msgcontains(msg, "pay") or msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			if (player:getMoney() + player:getBankBalance()) >= valuePicture then
				npcHandler:say("Well done. The picture will be delivered to the museum as last as possible.", cid)
				npcHandler.topic[playerId] = 0
				npcHandler.topic[playerId] = 0
				player:removeMoneyBank(valuePicture)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 5)
			else
				npcHandler:say("You don't have enough money.", cid)
				npcHandler.topic[playerId] = 1
				npcHandler.topic[playerId] = 1
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hiho Storm Killer! Welcome to Kazordoon furniture store.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
