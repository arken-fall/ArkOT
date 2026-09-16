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

	if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 30 then
		npcHandler:setMessage(MESSAGE_GREET, "Have you the {animal cure}?")
	elseif player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 31 then
		npcHandler:setMessage(MESSAGE_GREET, "Have you killed {morik}?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello, what brings you here?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 29 then
			npcHandler:say({
				"Why should I do something for another human being? I have been on my own for all those years. Hmm, but actually there is something I could need some assistance with. ... ",
				"If you help me to solve my problems, I will help you with your mission. Do you accept?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 32 then
			npcHandler:say("You have kept your promise. Now, it's time to fulfil my part of the bargain. What kind of animals shall I raise? {Warbeasts} or {cattle}?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "animal cure") then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 30 and player:removeItem(8819, 1) then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 31)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.MorikSummon, 0)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission05, 4) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("Thank you very much. As I said, as soon as you have helped me to solve both of my problems, we will talk about your mission. Have you killed {morik}?", cid)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Come back when you have the cure.", cid)
		end
	elseif msgcontains(msg, "cattle") then
		if npcHandler.topic[playerId] == 2 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.TamerinStatus, 1)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission05, 6) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("So be it!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "warbeast") then
		if npcHandler.topic[playerId] == 2 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.TamerinStatus, 2)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission05, 7) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("So be it!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "morik") then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 31 and player:removeItem(8820, 1) then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 32)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission05, 5) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("So he finally got what he deserved. As I said, as soon as you have helped me to solve both of my problems, we will talk about your {mission}.", cid)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Come back when you got rid with Morik.", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 30)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission05, 3) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler:say("I ask you for two things! For one thing, I need an animal cure and for another thing, I ask you to get rid of the gladiator Morik for me.", cid)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
