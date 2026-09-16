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

	if msgcontains(msg, "mission") then
		if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 4 then
			npcHandler:say({
				"One of my sisters, in the disguise of a nightingale, told me that Alkestios would send you. There is a problem which is not concerning me but a wolf mother on the small island Cormaya. ...",
				"As we, the fae, consider ourselves guardians and protectors of plants and animals, it is important for me to help this wolf. Unfortunately, I can't do it myself because at the moment I'm bound to this vessel, this snake. ...",
				"Thus I can't cross the ocean to reach Cormaya. Will you help me?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(ThreatenedDreams.Mission01[1]) == 10 then
			npcHandler:say("The wolf's ghost has found peace. Thank you, human being. However, there is someone else who needs help: A sister of mine who's bereft of something very precious. You'll find her in the guise of a swan at a small river south-east of here.", cid)
			player:setStorageValue(ThreatenedDreams.Mission01[1], 11)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("You are not on that mission.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"Nature's blessings! You may find the desperate wolf mother in the south of Cormaya. You will know the place because there is a big stone that looks like a grumpy face. ...",
				"At night it will weep bloody tears and only at night you will meet the ghost there. Take this talisman so you may be able to talk with animals and even plants and stones. Just don't expect that all of them will answer you.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission01[1], 5)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say("Then not.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Nature's blessing, traveler!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
