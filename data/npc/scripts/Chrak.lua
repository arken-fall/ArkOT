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

	if msgcontains(msg, "battle") then
		if player:getStorageValue(TheNewFrontier.Questline) == 24 then
			npcHandler:say({
				"Zo you want to enter ze arena, you know ze rulez and zat zere will be no ozer option zan deaz or victory?",
			}, cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(TheNewFrontier.Questline) == 24 then
			npcHandler:say({
				"Ze tournament iz ze ultimate challenge of might and prowrezz. Ze rulez may have changed over ze centuriez but ze ezzence remained ze zame. ...",
				"If you know ze rulez, you might enter ze arena for ze {battle}.",
			}, cid)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(TheNewFrontier.Questline) == 27 then
			npcHandler:say({
				"You have done ze impozzible and beaten ze champion. Your mazter will be pleazed. Hereby I cleanze ze poizon from your body. You are now allowed to leave. ...",
				"For now ze mazter will zee zat you and your alliez are zpared of ze wraz of ze dragon emperor az you are unimportant for hiz goalz. ...",
				"You may crawl back to your alliez and warn zem of ze gloriouz might of ze dragon emperor and hiz minionz.",
			}, cid)
			player:setStorageValue(TheNewFrontier.Questline, 28)
			player:setStorageValue(TheNewFrontier.Mission09[1], 3) --Questlog, "Mission 09: Mortal Combat"
			player:setStorageValue(TheNewFrontier.Mission10[1], 1) --Questlog, "Mission 10: New Horizons"
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("I grant you ze permizzion to enter ze arena. Remember, you'will have to enter ze arena az a team of two. If you are not familiar wiz ze rulez, I can explain zem to you once again.", cid)
			player:setStorageValue(TheNewFrontier.Questline, 25)
			player:setStorageValue(TheNewFrontier.Mission09.ArenaDoor, 1)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetingz, competitor.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
