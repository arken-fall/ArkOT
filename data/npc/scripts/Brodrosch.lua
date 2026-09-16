local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Passage to Cormaya! Unforgettable steamboat ride!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "ticket") then
		if Player(cid):getStorageValue(Storage.WagonTicket) >= os.time() then
			npcHandler:say("Your weekly ticket is still valid. Would be a waste of money to purchase a second one", cid)
			return true
		end

		npcHandler:say("Do you want to purchase a weekly ticket for the ore wagons? With it you can travel freely and swiftly through Kazordoon for one week. 250 gold only. Deal?", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] > 0 then
		local player = Player(cid)
		if npcHandler.topic[playerId] == 1 then
			if not player:removeMoneyBank(250) then
				npcHandler:say("You don't have enough money.", cid)
				npcHandler.topic[playerId] = 0
				return true
			end

			player:setStorageValue(Storage.WagonTicket, os.time() + 7 * 24 * 60 * 60)
			npcHandler:say("Here is your stamp. It can't be transferred to another person and will last one week from now. You'll get notified upon using an ore wagon when it isn't valid anymore.", cid)
		end
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "no") and npcHandler.topic[playerId] > 0 then
		npcHandler:say("No then.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, text, cost, discount, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({ keyword }, StdModule.say, {
			npcHandler = npcHandler,
			text = {
				"Well, you might be just the hero they need there. To tell you the truth, some our most reliable ore mines have started to run low. ...",
				"This is why we developed new steamship technologies to be able to further explore and cartograph the great subterraneous rivers. Our brothers have established a base on a continent far, far away. ...",
				"We call that the far, far away base. But since it will hopefully become a flourishing mine one day, most of us started to call it {Farmine}. The dwarfs there could really use some help right now.",
			},
		}, condition, action)
	end

	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = { text[1] }, cost = cost, discount = discount })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, text = text[2], cost = cost, discount = discount, destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = text[3], reset = true })
end

addTravelKeyword("farmine", { "Do you seek a ride to Farmine for |TRAVELCOST|?", "Full steam ahead!", "We would like to serve you some time." }, 210, { "postman", "new frontier" }, function(player)
	local destination = Position(33025, 31553, 14)
	if player:getStorageValue(TheNewFrontier.Mission05[1]) == 2 then --if The New Frontier Quest 'Mission 05: Getting Things Busy' complete then Stage 3
		destination.z = 10
	elseif player:getStorageValue(TheNewFrontier.Mission03) >= 2 then --if The New Frontier Quest 'Mission 03: Strangers in the Night' complete then Stage 2
		destination.z = 12
	end
	return destination
end, function(player)
	return player:getStorageValue(TheNewFrontier.FarmineFirstTravel) < 1
end, function(player)
	if player:getStorageValue(TheNewFrontier.FarmineFirstTravel) < 1 then
		player:setStorageValue(TheNewFrontier.FarmineFirstTravel, 1)
	end
end)

addTravelKeyword("cormaya", { "Do you seek a ride to Cormaya for |TRAVELCOST|?", "Full steam ahead!", "We would like to serve you some time." }, 160, { "postman" }, Position(33311, 31989, 15), function(player)
	if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01) == 4 then
		player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01, 5)
	end
end)

addTravelKeyword("gnomprona", { "Would you like to travel to Gnomprona for |TRAVELCOST|?", "Full steam ahead!", "Then not." }, 200, "postman", Position(33516, 32856, 14))
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want me take you to {Cormaya}, {Farmine} or to {Gnomprona}?" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! May earth protect you on the rocky grounds. If you need a {passage}, I can help you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
