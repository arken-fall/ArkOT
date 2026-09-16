local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local config = {
	{ position = Position(32474, 31947, 7), type = 2, description = "Tree 1" },
	{ position = Position(32515, 31927, 7), type = 2, description = "Tree 2" },
	{ position = Position(32458, 31997, 7), type = 2, description = "Tree 3" },
}

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(TheNewFrontier.Questline) == 4 then
			npcHandler:say({
				"Ha! Men and wood you say? Well, I might be able to relocate some of our miners to the base. Acquiring wood is an entirely different matter though. ... ",
				"I can't spare any men for woodcutting right now but I have an unusual idea that might help. ... ",
				"As you might know, this area is troubled by giant beavers. Once a year, the miners decide to have some fun, so they lure the beavers and jump on them to have some sort of rodeo. ... ",
				"However, I happen to have some beaver bait left from the last year's competition. ... ",
				"If you place it on trees on some strategic locations, we could let the beavers do the work and later on, I'll send men to get the fallen trees. ... ",
				"Does this sound like something you can handle? ",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(TheNewFrontier.Mission02.Beaver1) == 1 and player:getStorageValue(TheNewFrontier.Mission02.Beaver2) == 1 and player:getStorageValue(TheNewFrontier.Mission02.Beaver3) == 1 then
			npcHandler:say("Yes, I can hear them even from here. It has to be a legion of beavers! I'll send the men to get the wood as soon as their gnawing frenzy has settled! You can report to Ongulf that men and wood will be on their way!", cid)
			player:setStorageValue(TheNewFrontier.Questline, 6)
			player:setStorageValue(TheNewFrontier.Mission02[1], 3) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
		else
			npcHandler:say("If you place the beaver bait on trees on some strategic locations, we could let the beavers do the work and later on, I'll send men to get the fallen trees.", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"So take this beaver bait. It will work best on dwarf trees. I'll mark the three trees on your map. Here .. here .. and here! So now mark those trees with the beaver bait. ...",
				"If you're unlucky enough to meet one of the giant beavers, try to stay calm. Don't do any hectic moves, don't yell, don't draw any weapon, and if you should carry anything wooden on you, throw it away as far as you can.",
				"Just great, another disturbance. Just what I need.",
			}, cid)
			player:setStorageValue(TheNewFrontier.Questline, 5)
			player:setStorageValue(TheNewFrontier.Mission02[1], 2) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			player:addItem(9843, 1)
			for i = 1, #config do
				player:addMapMark(config[i].position, config[i].type, config[i].description)
			end
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			if player:removeMoneyBank(100) then
				player:addItem(9843, 1)
				npcHandler:say("Here you go.", cid)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You dont have enough of gold coins.", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "buy flask") or msgcontains(msg, "flask") then
		if player:getStorageValue(TheNewFrontier.Questline) == 5 then
			npcHandler:say("You want to buy a Flask with Beaver Bait for 100 gold coins?", cid)
			npcHandler.topic[playerId] = 2
		else
			npcHandler:say("Im out of stock.", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Just great, another disturbance. Just what I need.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
