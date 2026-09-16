local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local playerId = cid:getId()
	local player = Player(cid)

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The Druid of Crunor? He told you that a new cave appeared here? That's right. I'm the head of a {project} that tries to find out more about this new {area}.")
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 9 then
		npcHandler:setMessage(MESSAGE_GREET, "Just get out of my way! You killed this beautiful cid. I have nothing more to say. Damn druid of Crunor!")
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) > 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How is your {mission} going?")
	elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The Druid of Crunor? He told you that a new cave appeared here? That's right. I'm the head of a project that tries to find out more about this new area.")
	end

	return true
end
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 3 then
		if msgcontains(msg, "mission") then
			npcHandler:say("The scientists are still missing? You just found some strange green shining mummies and a big oasis? I give you this analysis tool for the water of the oasis. Maybe that's the key. Could you bring me a sample of this water?", cid)
			npcHandler.topic[playerId] = 15
		elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 15 then
			npcHandler:say("Very good. Hopefully analysing this sample will get us closer to the solution of this mistery.", cid)
			player:addItem(25305, 1)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission, 4)
		end
	end

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 5 then
		if msgcontains(msg, "mission") then
			npcHandler:say("Do you have the sample I asked you for?", cid)
			npcHandler.topic[playerId] = 16
		elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 16 then
			npcHandler:say("Thanks a lot. Let me check the result. Well, I think you need the counteragent. Please apply it to the oasis!", cid)
			player:addItem(25304, 1)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission, 6)
		end
	end

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 7 then
		if msgcontains(msg, "mission") then
			npcHandler:say("What has happened? You applied the counteragent to the oasis and then it was destroyed by a sandstorm? Keep on investigating the place.", cid)
			npcHandler.topic[playerId] = 17
		end
	end

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 8 then
		npcHandler:say("Just get out of my way! You killed this beautiful cid. I have nothing more to say. Damn druid of Crunor!", cid)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission, 9)
	end

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 6 then
		if msgcontains(msg, "magnifier") then
			npcHandler:say("{Gareth} told you that there are rumours about fake artefacts in the MoTA? And it is your task to check that with a magnifier? I see. I don't need one right now, so you can have one of mine. You find one in the crate over there.", cid)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 7)
		end
	end

	if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 10 then
		if msgcontains(msg, "artefact") then
			npcHandler:say("So you found out that one artefact in the MoTA is fake? And {Gareth} sent you to me to get a new artefact as a replacement? Sorry, I hardly know you so I don't trust you. I won't help you with that!", cid)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 11)
		end
	end

	if msgcontains(msg, "project") then
		npcHandler:say("The project is called 'Sandy {Cave} Project' and is funded by the {MoTA}. Its goal is the investigation of this {cave}.", cid)
		npcHandler.topic[playerId] = 2
	elseif npcHandler.topic[playerId] == 2 and msgcontains(msg, "mota") then
		npcHandler:say("MoTA is short for the recently founded Museum of Tibian Arts. We work together in close collaboration. New {results} are communicated to the museum instantly.", cid)
		npcHandler.topic[playerId] = 3
	elseif npcHandler.topic[playerId] == 3 and msgcontains(msg, "results") then
		npcHandler:say("We have no scientific results so far to reach our {goal}, because my workers aren't back yet. Should I be {worried}?", cid)
		npcHandler.topic[playerId] = 4
	elseif npcHandler.topic[playerId] == 4 and msgcontains(msg, "worried") then
		npcHandler:say("Then I have to find out why they don't return. But I'm old and my back aches. Would you like to go there and look for my workers?", cid)
		npcHandler.topic[playerId] = 5
	elseif npcHandler.topic[playerId] == 5 and msgcontains(msg, "yes") then
		npcHandler:say("Fantastic! Go there and then tell me what you've seen. I've opened the door for you. Take care of yourself!", cid)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission, 2)
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.AccessDoor, 1)
		npcHandler.topic[playerId] = 0
	elseif npcHandler.topic[playerId] == 2 and msgcontains(msg, "cave") then
		npcHandler:say("We don't know exactly why this cave has now exposed an entry via the {dark pyramid}. It seems that the cave already existed for a long time, however, without a connection to our world. Maybe some smaller earth movements have changed the situation.", cid)
		npcHandler.topic[playerId] = 11
	elseif npcHandler.topic[playerId] == 11 and msgcontains(msg, "dark pyramid") then
		npcHandler:say("We don't know yet to wich extent the cave and the dark pyramid belong together. Thisi s what we try to find out. Maybe the history of this place has to be rewritten.", cid)
		npcHandler.topic[playerId] = 0
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
