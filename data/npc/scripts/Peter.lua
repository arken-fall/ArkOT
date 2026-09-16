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

	if msgcontains(msg, "report") then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 7 or player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 13 then
			npcHandler:say("A report? What do they think is happening here? <gives an angry and bitter report>. ", cid)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) + 1)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission02, player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission02) + 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			npcHandler.topic[playerId] = 0
		end
	elseif table.contains({ "pass", "gate" }, msg:lower()) then
		npcHandler:say("Pass the gate? If it must be. Are you headed for the {factory} or the former {trade quarter}?", cid)
		npcHandler.topic[playerId] = 1
	elseif msgcontains(msg, "factory") then
		if npcHandler.topic[playerId] == 1 then
			local destination = Position(32859, 31302, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[playerId] = 0
		end
	else
		npcHandler:say("Listen, I don't get paid enough to chat with citizens. Move on.", cid)
	end
	return true
end

-- Travel without the need to say "pass", remove or comment this two lines if you want to keep the rpg
keywordHandler:addKeyword({ "factory" }, StdModule.travel, { npcHandler = npcHandler, destination = Position(32859, 31302, 7) })
keywordHandler:addKeyword({ "trade" }, StdModule.travel, { npcHandler = npcHandler, destination = Position(32854, 31302, 7) })

local function onTradeRequest(cid)
	local player = Player(cid)
	local playerId = cid
	if npcHandler.topic[playerId] == 1 then
		local destination = Position(32854, 31302, 7)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		npcHandler.topic[playerId] = 0
		npcHandler:say("Be on your guard. Some people are nice, some... aren't.", cid)
	end
	return true
end
--Basic
keywordHandler:addKeyword({ "alchemist quarter" }, StdModule.say, { npcHandler = npcHandler, text = "There it's even more smelly than in the factory quarter. Smells a bit like rotten eggs." })
keywordHandler:addKeyword({ "arena quarter" }, StdModule.say, { npcHandler = npcHandler, text = "You don't look as if you would last one second there." })
keywordHandler:addKeyword({ "augur" }, StdModule.say, { npcHandler = npcHandler, text = "One day I will walk into the office of my superior and announce my resignment. Probably not long from now." })
keywordHandler:addKeyword({ "cemetery quarter" }, StdModule.say, { npcHandler = npcHandler, text = "Good idea. Go for a walk there. Preferably six feet down." })
keywordHandler:addKeyword({ "factory quarter" }, StdModule.say, { npcHandler = npcHandler, text = "It's too noisy and smelly." })
keywordHandler:addKeyword({ "foreign quarter" }, StdModule.say, { npcHandler = npcHandler, text = "Go there if you wanna get beaten up." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Sergeant first class of the Yalaharian Guard Force. But I don't care about ranks and titles." })
keywordHandler:addAliasKeyword({ "official" })
keywordHandler:addKeyword({ "magician quarter" }, StdModule.say, { npcHandler = npcHandler, text = "I can't stand those arrogant fools." })
keywordHandler:addKeyword({ "mission" }, StdModule.say, { npcHandler = npcHandler, text = "Leave me alone with your 'mission' unless you have precise orders from my superiors." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Peter." })
keywordHandler:addKeyword({ "sunken quarter" }, StdModule.say, { npcHandler = npcHandler, text = "That quara brood should be extinguished." })
keywordHandler:addKeyword({ "trade quarter" }, StdModule.say, { npcHandler = npcHandler, text = "The leader of their pack is the biggest criminal among them all." })
keywordHandler:addKeyword({ "quarter" }, StdModule.say, { npcHandler = npcHandler, text = "Count them yourself." })
keywordHandler:addKeyword({ "yalahar" }, StdModule.say, { npcHandler = npcHandler, text = "You're here. So what?" })

npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye citizen!")
npcHandler:setMessage(MESSAGE_GREET, "Hello. Unless you have official business here or want to pass the gate, please move on.")
npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
