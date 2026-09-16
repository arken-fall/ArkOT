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

	if msgcontains(msg, "guezt") then
		if player:getStorageValue(TheNewFrontier.Questline) == 23 then
			npcHandler:say({
				"Ziz iz not for you to azk. I work for zomeone of immenze power. He haz an {offer} for you.",
			}, cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "offer") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("You are ztill a captive and your life is forfeit. Zere might be a way for you to ezcape if you agree to {work} for my mazter.", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "work") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say({
				"Zere iz a great tournament of ztrengz each decade. It determinez ze granted privilegez for zertain individualz of power for ze comming decade. ...",
				"My mazter wantz to zurprize hiz opponentz by an unexpected move. He will uze warriorz from ze outzide, zomeone zat no one can azzezz. ...",
				"One of ziz warriorz could be you. Or you could ztay here and rot in ze dungeon. Are you interezted in ziz deal?",
			}, cid)
			npcHandler.topic[playerId] = 3
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say({
				"You are zmart for a zoftzkin, but before you begin to feel too zmart, you should know zat we will zeal our deal wiz you drinking a ztrong poizon zat will inevitably kill you if you want to trick me and not attend ze tournament. ...",
				"Zo are you ready to drink ziz poizon here?",
			}, cid)
			npcHandler.topic[playerId] = 4
		elseif npcHandler.topic[playerId] == 4 then
			npcHandler:say({
				"Excellent! Now you may leave ziz area zrough ze teleporter to ze norz. It will bring you to a hidden boat. Ziz boat will take you to ze tournament izle. ...",
				"Zere you'll learn anyzing you need to know about ze great tournament.",
			}, cid)
			player:setStorageValue(TheNewFrontier.Questline, 24)
			player:setStorageValue(TheNewFrontier.Mission08, 2) --Questlog, The New Frontier Quest "Mission 08: An Offer You Can't Refuse"
			player:setStorageValue(TheNewFrontier.Mission09[1], 1) --Questlog, The New Frontier Quest "Mission 08: An Offer You Can't Refuse"
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end
npcHandler:setMessage(MESSAGE_GREET, "Be greeted my .. {guezt}.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
