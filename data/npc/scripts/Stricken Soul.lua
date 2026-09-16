local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "This place is... haunted... heed my warning... there are... ghooooooosts here...! Why are you giving me that... look? I am certain, there aaaaaaare ghosts here - I've seen them! Do you believe me?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Gree... tings.")
	end

	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local playerName = player:getName()

	if msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Excellent... I hope they will haaaaaaunt my house no longer. What was your... naaaaaame again, tell me?", cid)
			npcHandler.topic[playerId] = 3
		elseif player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline) < 1 then
			npcHandler:say("Yeeeees... you need to help meeeeeee. I want those ghosts gone... this is my home and I need it to teach my students. Will you take care of the... ghosts?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, playerName) then
		if npcHandler.topic[playerId] == 3 then
			npcHandler:say({
				" Ah yeeeeees, " .. playerName .. ". I will remember you. Now, lessons are every day in the morning and once a week in the evening... ...",
				"Oh, you're not here for this, are you? So about the ghoooosts, yes. You seeeee, there are 3 secret passages here. ...",
				"Thiiiiis is no ordinary house... it is a nexus, a gateway to a once hidden cathedral. Sheltering a small and peaceful society of scholars and monks. Secluded from every distraction. ...",
				"I was one of them and ordered to hold contact to the outside woooorld. But then, something... happened. ...",
				"Outsiders managed to sneak in, infiltrate and influence the society... for the worse. Who knows for what ends. They chaaaaanged... ...",
				"Shortly after, contact was lost... the nexus broken and sealed, ghosts appeared... eeeeeeeverywhere. ...",
				"Find the three passages... one is right here in the cellars, one in the jungles of Tiquanda and one in the deserts of Darama. ...",
				"Restore their connection and open this nexus to access the buried cathedral and find the cause to this... eliminate all remainders there if you must, " .. playerName .. ".",
			}, cid)
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, 1)
			npcHandler.topic[playerId] = 0
		end
	else
		npcHandler:say("Sorry, I didn't understand.", cid)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
