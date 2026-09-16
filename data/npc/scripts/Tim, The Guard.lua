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

	if msgcontains(msg, "trouble") and player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.TimGuard) < 1 and player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission01) ~= -1 then
		npcHandler:say("Ah, well. Just this morning my new toothbrush fell into the toilet.", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "authorities") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("What do you mean? Of course they will immediately send someone with extra long and thin arms to retrieve it! ", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "avoided") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Your humour might let end you up beaten in some dark alley, you know? No, I don't think someone could have prevented that accident! ", cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "gods would allow") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say({
				"It's not a drama!! I think there is just no god who's responsible for toothbrush safety, that's all ...",
				"And even IF through some miracle the stupid toothbrush had jumped out of the toilet into my hand, I honestly doubt I would ever use it again.",
			}, cid)
			npcHandler.topic[playerId] = 0
			if player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.TimGuard) < 1 then
				player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.TimGuard, 1)
				player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission01, player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "It's my duty to protect the city." })

npcHandler:setMessage(MESSAGE_GREET, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE KING!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
