local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'My house! Uahahahaha <sniffs>.'},
	{text = 'Dear gods! My precious house, DESTROYED!!'},
	{text = 'Oh no!! What am I supposed to do now?!?'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid
	local mission = Storage.Quest.U8_2.TrollSabotage
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "mission") or msgcontains(msg, "quest") then
		if player:getStorageValue(Storage.Quest.U8_2.TrollSabotageQuest.Questline) < 1 then
			npcHandler:say({
				"I'm not sure but I suppose that an evil troll lives in the mountains here! I saw him rummaging in the ruins of my house. ...",
				"I took a closer look and found my family casket ripped open. It contained a precious necklace. If I had it back, I could sell it and start over! ...",
				"Could you look for this mean beast, find out why he did and either get me some money ormy necklace to rebuild my business?",
			}, cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(Storage.Quest.U8_2.TrollSabotageQuest.Questline) == 2 and player:removeItem(7754, 1) then
			npcHandler:say("Thank you sooo much <sniffs>. Well, you know I lost everything, but recently I found this strange rope here. I don't need it, here take it!", cid)
			player:setStorageValue(Storage.Quest.U8_2.TrollSabotageQuest.Questline, 3)
			player:addItem(646, 1)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Great! Finally, some light at the end of the tunnel! Come back and ask me for the quest when you solved this mystery!", cid)
			player:setStorageValue(Storage.Quest.U8_2.TrollSabotageQuest.Questline, 1)
		end
	end
	return true
end
-- basic
keywordHandler:addKeyword({ "ankrahmun" }, StdModule.say, { npcHandler = npcHandler, text = "The only animal to catch there is the cobra and most people don't like to keep one as a pet." })
keywordHandler:addKeyword({ "bat" }, StdModule.say, { npcHandler = npcHandler, text = "Who wants such an animal as a pet?!?!" })
keywordHandler:addAliasKeyword({ "bug" })
keywordHandler:addAliasKeyword({ "lion" })
keywordHandler:addAliasKeyword({ "wolf" })
keywordHandler:addAliasKeyword({ "deer" })
keywordHandler:addAliasKeyword({ "rotworm" })
keywordHandler:addAliasKeyword({ "slime" })
keywordHandler:addAliasKeyword({ "squirrel" })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "Those amazons denied making business with me. You know the reason?!? I tell you, the reason was that I am MALE! Ridiculous!" })
keywordHandler:addKeyword({ "cat" }, StdModule.say, { npcHandler = npcHandler, text = "For sure, I would have offered cats!" })
keywordHandler:addKeyword({ "daniel" }, StdModule.say, { npcHandler = npcHandler, text = "He gave me the permission to open up a pet shop here. I paid him almost everything I got!" })
keywordHandler:addAliasKeyword({ "steelsoul" })
keywordHandler:addKeyword({ "dog" }, StdModule.say, { npcHandler = npcHandler, text = "I made contact with Svargrond! A guy named Buddel wanted to sell me a three-headed dog. I haven't seen it yet, but imagine how much money I could make by breeding such a pet!!" })
keywordHandler:addKeyword({ "edron" }, StdModule.say, { npcHandler = npcHandler, text = "I like it here, at least the town. I was warned that there are nasty creatures outside the town walls but I didn't expect anything to happen so close to town!" })
keywordHandler:addKeyword({ "farm" }, StdModule.say, { npcHandler = npcHandler, text = "I was always good with animals. My parents had a farm, the McRonalds farm. Maybe you know it. Anyway, I had the idea that people may like to have animals as companions and so one led to another." })
keywordHandler:addAliasKeyword({ "pet" })
keywordHandler:addAliasKeyword({ "country" })
keywordHandler:addKeyword({ "frog" }, StdModule.say, { npcHandler = npcHandler, text = "I'd go mad listening to this 'ribbit' the whole time. But each to his own!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm new here in Edron. I wanted to open up a pet shop. But now I'm ruined, uahahahaha <sniffs>." })
keywordHandler:addAliasKeyword({ "mood" })
keywordHandler:addAliasKeyword({ "work" })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "I need to write a letter to the king. I'm not sure if those 2 million gold coins that Daniel Steelsoul demanded from me weren't too much." })
keywordHandler:addAliasKeyword({ "tibianus" })
keywordHandler:addKeyword({ "liberty bay" }, StdModule.say, { npcHandler = npcHandler, text = "I'm there from time to time, catching frogs. People like their bright colours." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Jerom but no need to remember my name. All my belongings are destroyed and stolen. I'll be gone soon!" })
keywordHandler:addKeyword({ "parrot" }, StdModule.say, { npcHandler = npcHandler, text = "Raymond Striker offered me a contract to export parrots from Meriana but I won't need them anymore now that I'm ruined." })
keywordHandler:addKeyword({ "port hope" }, StdModule.say, { npcHandler = npcHandler, text = "Not a very good spot to catch animals. At least no animals that pass off as pets." })
keywordHandler:addKeyword({ "races" }, StdModule.say, { npcHandler = npcHandler, text = "Yesterday I would have said that I like all creatures of Tibia but TODAY my life has changed! When I catch this stinking troll!!" })
keywordHandler:addKeyword({ "rat" }, StdModule.say, { npcHandler = npcHandler, text = "True, why not keep a rat as a pet! They can eat your trash, live inside your walls and you don't have to worry if one dies ! Could be a huge success....if I weren't ruined!!!!" })
keywordHandler:addKeyword({ "revenge" }, StdModule.say, { npcHandler = npcHandler, text = "That would be a mission for a hero." })
keywordHandler:addKeyword({ "ship" }, StdModule.say, { npcHandler = npcHandler, text = "Well, I don't see any other way than going back to my home country now." })
keywordHandler:addKeyword({ "snake" }, StdModule.say, { npcHandler = npcHandler, text = "Good idea! Easy to catch and once the owner has been bitten, he can't sue me anymore, hehehe!!.... but wait....I forgot....I'm ruined, uahahahaha <sniffs>." })
keywordHandler:addAliasKeyword({ "spider" })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "I never make profit in Thais and most of the time I get robbed. I stopped visiting Thais for business some years ago." })
keywordHandler:addKeyword({ "trade" }, StdModule.say, { npcHandler = npcHandler, text = "I don't have anything to earn a living with, everything is destroyed! Otherwise I could offer you pets." })
keywordHandler:addAliasKeyword({ "merchant" })
keywordHandler:addKeyword({ "troll" }, StdModule.say, { npcHandler = npcHandler, text = "I saw a troll rummaging in the remains of my house last night! I'm sure this creature is behind that! But I am too weak to take revenge." })
keywordHandler:addAliasKeyword({ "rock" })
keywordHandler:addKeyword({ "what" }, StdModule.say, { npcHandler = npcHandler, text = "I've been to town and on my way back I heard a deafening sound. Then I saw that the sound came from a huge rock smashing my house." })
keywordHandler:addAliasKeyword({ "happen" })
keywordHandler:addAliasKeyword({ "house" })
keywordHandler:addAliasKeyword({ "accident" })
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")
npcHandler:setMessage(MESSAGE_GREET, "Hello. Sorry, but I'm not in the best {mood} today.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
