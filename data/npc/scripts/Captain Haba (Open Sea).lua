local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local TheHuntForTheSeaSerpent = Storage.Quest.U8_2.TheHuntForTheSeaSerpent
local function greetCallback(cid)
	local player = Player(cid)

	if player:getStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.QuestLine) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Wha'd ya want? Ask me 'bout the {instructions} if you don't know what to do! If you wanna head back to {Svargrond}, let me know.")
	elseif player:getStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.QuestLine) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "You found the spot |PLAYERNAME|!! Grab yourself a helmet of the deep and go explore the {caves} down there.")
	end
	return true
end
local randomMessages = {
	straight = {
		"STRAIGHT AHED! WE GOT FOLLOWING WINDS, LETS'S GO!!",
		"STRAIGHT AHED!! WHY DOES THIS TAKE SO LONG?!? HURRY UP!",
		"LOOKOUT REPORTS SEA SERPENT ON SIGHT!! STRAIGHT AHEAD!!",
		"GO GO GO, SEA SERPENT STRAIGHT AHEAD!!",
		"SET FULL SAILS! SEA SERPENT RIGHT IN FRONT OF US!!",
	},
	starboard = {
		"SET FULL SAILS! SEA SERPENT ON THE STARBOARD SIDE!!",
		"LOOKOUT REPORTS SEA SERPENT ON SIGHT!! SEA SERPENT ON THE STARBOARD SIEDE!!",
		"COME ON YOU LAZY FOOLS!! SEA SERPENT ON THE STARBOARD SIDE!!",
		"GO GO GO, SEA SERPENT ON THE STARBOARD SIDE!!",
		"CHANGE COURSE TO STARBOARD!! WHY DOES THIS TAKE SO LONG?!? HURRY UP!",
	},
	larboard = {
		"SET FULL SAILS! SEA SERPENT ON THE LARBOARD SIDE!!",
		"SEA SERPENT AHEAD!! LARBOARD SIDE!!",
		"SEA SERPENT ON SIGHT!! TO THE LARBOARD SIDE, FAST!",
		"LARBOARD!! THY DOES THIS TAKE SO LONG?!? LET'S GET IT ON!",
		"LET'S GO YOU LAZY FOOLS. WE GOT A SEA SERPENT TO CATCH! TO LARBOARD SIDE, GO, GO, GO!",
	},
}
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local randomMessagesResult
	if msgcontains(msg, "instructions") then
		npcHandler:say({
			"A'right, first of all you need a bait which isn't for free, though. I sell them for 50 gold each. Use the bait on the crane over there when you see something in the telescope. ...",
			"Then go up to the lookout and check the telescope for a sight of the sea serpent. ...",
			"If you see it in front of ya, get down at once. And what d'ya gonna say to me?",
		}, cid)
		npcHandler.topic[playerId] = 1
	elseif npcHandler.topic[playerId] == 1 and msg:lower() ~= "straight" then
		npcHandler:say("Harharhar, landlubber, no no!! The correct command would be STRAIGHT. Remember that! Next, what you gonna say when you see something to left?", cid)
		npcHandler.topic[playerId] = 2
	elseif npcHandler.topic[playerId] == 1 and msg:lower() ~= "larboard" then
		npcHandler:say("Harharhar, landlubber, ya got it all wrong!! The correct command would be LARBOARD side. Don't forget that, 'kay? Last one, what you gonna say to me when ya see somethin' to the right?", cid)
		npcHandler.topic[playerId] = 3
	elseif npcHandler.topic[playerId] == 1 and msg:lower() ~= "starboard" then
		npcHandler:say({
			"Ya gotta learn a lot! The correct command would be STARBOARD side. ...",
			"After you told me about the direction, put a bait on the crane again and go up to the lookout! That would be all sailor, let's go hunt down the sea serpent!!",
		}, cid)
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg:lower(), "straight") then
		randomMessagesResult = randomMessages.straight[math.random(#randomMessages.straight)]
		npcHandler:say(randomMessagesResult, cid)
		if player:getStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction) == 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif msgcontains(msg:lower(), "starboard") then
		randomMessagesResult = randomMessages.starboard[math.random(#randomMessages.starboard)]
		npcHandler:say(randomMessagesResult, cid)
		if player:getStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction) == 2 then
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif msgcontains(msg:lower(), "larboard") then
		randomMessagesResult = randomMessages.larboard[math.random(#randomMessages.larboard)]
		npcHandler:say(randomMessagesResult, cid)
		if player:getStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction) == 3 then
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif msgcontains(msg:lower(), "speed") then
		npcHandler:say("IS THAT ALL?!? SPEED UP, TIGHTEN THE MAINSAIL!!!", cid)
		if player:getStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction) == 4 then
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 1)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		else
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.SuccessSwitch, 0)
			player:setStorageValue(Storage.Quest.U8_2.TheHuntForTheSeaSerpent.Direction, 0)
		end
	elseif table.contains({ "god", "svargrond", "back", "hunt", "passage", "trip" }, msg:lower()) then
		if table.contains({ "god", "svargrond", "back", "hunt" }, msg:lower()) then
			npcHandler:say("Already got enough, huh? I kind o' expected that, landlubber! Let's head for Svargrond! Ready?", cid)
		else
			npcHandler:say("Y' already wanna give up?? I should've known. I bring ya back to Svargrond, 'kay?", cid)
		end
		npcHandler.topic[playerId] = 4
	elseif msg:lower() == "yes" and npcHandler.topic[playerId] == 4 then
		npcHandler:setMessage(MESSAGE_WALKAWAY, "See ya, landlubber!")
		player:teleportTo(Position(32342, 31123, 6))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		npcHandler.topic[playerId] = 0
	end
	return true
end
--Basic
keywordHandler:addKeyword({ "caves" }, StdModule.say, { npcHandler = npcHandler, text = "I'd go by myself and tear that beast's heart out if I were younger. I hope ya can do that for me. Now go and good luck to ya!" })
keywordHandler:addKeyword({ "wares" }, StdModule.say, { npcHandler = npcHandler, text = "Ya're a coward, aren't ya? Prove that I'm wrong and get your lazy bones up to the lookout!!" })
keywordHandler:addAliasKeyword({ "go" })
keywordHandler:addKeyword({ "bait" }, StdModule.say, { npcHandler = npcHandler, text = "Just ask me for a trade if you need a bait." })
keywordHandler:addKeyword({ "test" }, StdModule.say, { npcHandler = npcHandler, text = "I can give ya a challenge to test if ya have the guts to be a real sailor. Go up to the lookout and remain there for 24 hours during a storm! Harharhar!" })

npcHandler:setMessage(MESSAGE_SENDTRADE, "Here ya go! Use it on the crane when you see the monster. Then refill it every time you use the telescope.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
