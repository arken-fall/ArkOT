local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({ lookType = 348 })
condition:setTicks(-1)

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "exit") then
		if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.ZumtahStatus) ~= 1 then
			if npcHandler.topic[playerId] < 1 then
				npcHandler:say("You are searching for the way out? Do you want to go home? Are you homesick, nostalgic, allergic? I am sorry. You will stay. Muhahahaha. Haha. Are you giving up then?", cid)
				npcHandler.topic[playerId] = 1
			elseif npcHandler.topic[playerId] == 3 then
				npcHandler:say("A what? I don't even know what you're talking about, human. If you aren't just giving up - will you kindly change the topic please?", cid)
				npcHandler.topic[playerId] = 4
			elseif npcHandler.topic[playerId] == 6 then
				npcHandler:say("Haha, no! No. Why don't you just stop asking me that and start enjoying your stay here?", cid)
				npcHandler.topic[playerId] = 7
			elseif npcHandler.topic[playerId] == 10 then
				npcHandler:say("Oh, you mean - if I have ever been out of here in those 278 years? Well, I - I can't remember. No, I can't remember. Sorry.", cid)
				npcHandler.topic[playerId] = 11
			elseif npcHandler.topic[playerId] == 11 then
				npcHandler:say("No, I really can't remember. I enjoyed my stay here so much that I forgot how it looks outside of this hole. Outside. The air, the sky, the light. Oh well... well.", cid)
				npcHandler.topic[playerId] = 12
			elseif npcHandler.topic[playerId] == 12 then
				npcHandler:say({ "Oh yes, yes. I... I never really thought about how you creatures feel in here I guess. I... just watched all these beings die here. ...", "I... enjoyed this torture so much that I forgot time and everything around me. ...", "I feel - sorry. Yes, sorry." }, cid)
				npcHandler.topic[playerId] = 13
			elseif npcHandler.topic[playerId] == 13 then
				npcHandler:say({
					"Oh, excuse me of course, you... wanted to go. Like all... the others. I am sorry, so sorry. You... you can leave. Yes. You can go. You are free. I shall stay here and help every poor soul which ever gets thrown in here from this day onward. ...",
					"Yes, I will redeem myself. Maybe in another 278 years. ...",
					"If you want to go, just ask for an {exit} and I will transform you into a cid small enough to fit through that hole over there.",
				}, cid)
				npcHandler.topic[playerId] = 14
			elseif npcHandler.topic[playerId] == 14 then
				npcHandler:say({ "Alright, as I said you are free now. There will not be an outside for the next three centuries, but you - go. ...", "Oh and I recovered the strange crate you where hiding in, it will wait for you at the exit since you can't carry it as... a beetle, muhaha. Yes, you shall now crawl through the passage as a beetle. There you go." }, cid)
				npcHandler.topic[playerId] = 0
				player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.ZumtahStatus, 1)
				player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.PrisonReleaseStatus, 1)
				player:addCondition(condition)
			end
		else
			npcHandler:say("It's you, why did they throw you in here again? Anyway, I will just transform you once more. I also recovered your crate which will wait for you at the exit. There, feel free to go.", cid)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.PrisonReleaseStatus, 1)
			player:addCondition(condition)
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("I've already told you that you can't get out. What's the problem? Do you even see an exit?", cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 4 then
			npcHandler:say("You are starting to get on my nerves. Is this the only topic you know?", cid)
			npcHandler.topic[playerId] = 5
		elseif npcHandler.topic[playerId] == 7 then
			npcHandler:say("But there is no escape, I said NO. You've already asked several times and my answer will stay the same. What is this? Are you trying to test me?", cid)
			npcHandler.topic[playerId] = 8
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("Muhahaha. Where? I can only see a dark cave with nothing than bones and a djinn in it. You mean that small hole there? Muhahaha.", cid)
			npcHandler.topic[playerId] = 3
		elseif npcHandler.topic[playerId] == 5 then
			npcHandler:say("Pesky, persistent human.", cid)
			npcHandler.topic[playerId] = 6
		elseif npcHandler.topic[playerId] == 8 then
			npcHandler:say("Muhahaha. Then I will give you a test. How many years do you think have I been here? {89}, {164} or {278}?", cid)
			npcHandler.topic[playerId] = 9
		end
	elseif msgcontains(msg, "278") and npcHandler.topic[playerId] == 9 then
		npcHandler:say("Correct human, and that is not nearly how high you would need to count to tell all the lost souls I've seen dying here. I AM PERPETUAL. Muahahaha.", cid)
		npcHandler.topic[playerId] = 10
	elseif (msgcontains(msg, "164") or msgcontains(msg, "89")) and npcHandler.topic[playerId] == 9 then
		npcHandler:say("Wrong answer human! Muahahaha.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end
--Basic
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I wait. I wait for someone like you to come here. I wait for them to grow disconsolate. I wait for them to despair. And I wait for them to die. Muhahaha." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Zumtah, Zumtah the impeccable, Zumtah the marvellous, Zumtah the... the... eternal." })
keywordHandler:addAliasKeyword({ "djinn" })
keywordHandler:addAliasKeyword({ "zumtah" })
keywordHandler:addKeyword({ "zao" }, StdModule.say, { npcHandler = npcHandler, text = "The land you are currently dwelling in, human. Don't you have any sense of your surroundings?" })
keywordHandler:addKeyword({ "humans" }, StdModule.say, { npcHandler = npcHandler, text = "I have seen many of them. I have seen many of them die. In here, with me. Perhaps you will be pleased to meet them. Not long and you will join their ranks. Muhaha." })
keywordHandler:addKeyword({ "lizard" }, StdModule.say, { npcHandler = npcHandler, text = "Pesky creatures. Many of them have been brought here, many of them died here. Humans, lizards, beasts, they all die the same. Down here, with me. Muhahaha." })
keywordHandler:addKeyword({ "zalamon" }, StdModule.say, { npcHandler = npcHandler, text = "What? What do you mean by that?" })
keywordHandler:addKeyword({ "emperor" }, StdModule.say, { npcHandler = npcHandler, text = "Hmm, an old one. I don't care much about politics or power, as here, he has none. Here, only I have power. Muhaha." })
keywordHandler:addKeyword({ "resistance" }, StdModule.say, { npcHandler = npcHandler, text = "What are you talking about, such things do not matter down here. Down here alone, isolated and broken. Muhaha." })
npcHandler:setMessage(MESSAGE_GREET, "Another visitor to this constricted, cosy, calm realm, perfect except for an {exit}. Muhaha.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Muhahaha.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
