local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function addTravelKeyword(keyword, text, destination, randomDestination, randomNumber, condition, ringCheck, ringRemove)
	if condition then
		keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "No, no, no, you even are no barb....barba...er.. one of us!!!! Talk to the Jarl first!" }, condition)
	end
	if ringCheck then
		local ring = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Ohh, you got a nice ring there! Ya don't have to pay if you gimme the ring and I promise you I will bring you to the correct spot!*HICKS* Alright?" }, ringCheck)
		ring:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 0, destination = destination }, ringRemove)
		local normalTravel = ring:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "Give me 50 gold and I bring you to " .. keyword .. ". 'kay?" })
		normalTravel:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true })
		if randomNumber then
			normalTravel:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 50, discount = "postman", destination = destination }, randomNumber)
		end
		normalTravel:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 50, discount = "postman", destination = randomDestination }, randomNumber)
	end
	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = text, cost = 50, discount = "postman" })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true })
	if randomNumber then
		travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 50, discount = "postman", destination = destination }, randomNumber)
	end
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 50, discount = "postman", destination = randomDestination }, randomNumber)
end

local randomDestination = { Position(32255, 31197, 7), Position(32225, 31381, 7), Position(32333, 31227, 7), Position(32021, 31294, 7) }
addTravelKeyword("svargrond", "You know a town nicer than this? NICER DICER! Apropos, don't play dice when you are drunk ...", Position(32255, 31197, 7), function()
	return randomDestination[math.random(#randomDestination)]
end, function()
	return math.random(5) > 1
end, function(player)
	return player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) ~= 8
end, function(player)
	return player:getItemCount(3097) > 0
end, function(player)
	return player:removeItem(3097, 1)
end)
addTravelKeyword("okolnir", "It's nice there. Except of the ice dragons which are not very companionable.", Position(32225, 31381, 7), function()
	return randomDestination[math.random(#randomDestination)]
end, function()
	return math.random(5) > 1
end, function(player)
	return player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) ~= 8
end, function(player)
	return player:getItemCount(3097) > 0
end, function(player)
	return player:removeItem(3097, 1)
end)
addTravelKeyword("tyrsung", "*HICKS* Big, big island east of here. Venorian hunters settled there ..... I could bring you north of their camp.", Position(32333, 31227, 7), function()
	return randomDestination[math.random(#randomDestination)]
end, function()
	return math.random(5) > 1
end, function(player)
	return player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) ~= 8
end, function(player)
	return player:getItemCount(3097) > 0
end, function(player)
	return player:removeItem(3097, 1)
end)
addTravelKeyword("camp", "Both of you look like you could defend yourself! If you want to go there, ask me for a passage.", Position(32021, 31294, 7), function()
	return randomDestination[math.random(#randomDestination)]
end, function()
	return math.random(5) > 1
end, function(player)
	return player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) ~= 8
end, function(player)
	return player:getItemCount(3097) > 0
end, function(player)
	return player:removeItem(3097, 1)
end)

-- Kick
keywordHandler:addKeyword({ "kick" }, StdModule.kick, { npcHandler = npcHandler, text = "Get out o' here!*HICKS*", destination = { Position(32468, 31176, 7) } })

keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?" })
keywordHandler:addAliasKeyword({ "trip" })
keywordHandler:addAliasKeyword({ "go" })
keywordHandler:addAliasKeyword({ "sail" })

npcHandler:setMessage(MESSAGE_GREET, "Where are we at the moment? Is this {Svargrond}? NO,*HICKS* it's Helheim! Anyway, where do you want to go?")

npcHandler:addModule(FocusModule:new())
