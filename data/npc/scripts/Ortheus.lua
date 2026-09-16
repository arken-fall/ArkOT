local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid
	if msg == "cookie" then
		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Ortheus) < 0 then
			npcHandler:say("A cookie? Well... I have to admit I haven't had one for ages. Can I have it?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("It'd be better for you to leave now.", cid)
		end
	elseif msg == "yes" then
		if npcHandler.topic[playerId] == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Well thanks, it looks tasty, I'll just take a bi - COUGH! Are you trying to poison me?? Get out of here before I forget myself!", cid)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Ortheus, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			if player:removeItem(2880, 17) then -- mug of tea
				npcHandler:say("Wow. These polite young adventurers nowadays. Thank you.", cid)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("Hmmm, you don't have tea with you.", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msg == "tea" then
		npcHandler:say("Have you actually brought me a mug of tea??", cid)
		npcHandler.topic[playerId] = 2
	elseif msg == "no" then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("What a pity.", cid)
			npcHandler.topic[playerId] = 0
		end
	end
end
--Basic
keywordHandler:addKeyword({ "magicians" }, StdModule.say, { npcHandler = npcHandler, text = "I can't imagine a better place to live." })
keywordHandler:addKeyword({ "live" }, StdModule.say, { npcHandler = npcHandler, text = "Though the city has seen better days, the quality of life is still much better than in most other cities." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Hm, good question. Maybe old, wise man?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm used to being called old man. Simple as that." })
keywordHandler:addKeyword({ "vampire" }, StdModule.say, { npcHandler = npcHandler, text = "I don't know what you're talking about." })
keywordHandler:addKeyword({ "blood" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, it's a bit messy down there. Sorry." })
keywordHandler:addKeyword({ "julius" }, StdModule.say, { npcHandler = npcHandler, text = "Doesn't ring a bell." })
keywordHandler:addKeyword({ "armenius" }, StdModule.say, { npcHandler = npcHandler, text = "He rarely comes here." })
keywordHandler:addKeyword({ "maris" }, StdModule.say, { npcHandler = npcHandler, text = "A man of the seas." })
keywordHandler:addKeyword({ "lisander" }, StdModule.say, { npcHandler = npcHandler, text = "He used to visit me for a chat, but ever since that new tavern opened I haven't seen him much anymore." })
keywordHandler:addKeyword({ "serafin" }, StdModule.say, { npcHandler = npcHandler, text = "He sometimes delivers fruit and vegetables to this quarter." })
keywordHandler:addKeyword({ "yalahar" }, StdModule.say, { npcHandler = npcHandler, text = "Though the city has seen better days, the quality of life is still much better than in most other cities." })
keywordHandler:addKeyword({ "quarter" }, StdModule.say, { npcHandler = npcHandler, text = "I can't imagine a better place to live" })
keywordHandler:addKeyword({ "alori mort" }, StdModule.say, { npcHandler = npcHandler, text = "Whatever that's supposed to mean." }, function(player)
	return player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 1
end)
keywordHandler:addKeyword({ "reward" }, StdModule.say, { npcHandler = npcHandler, text = "I don't have anything that I could give you as a reward. Guess you aren't so selfless after all, huh?" })
keywordHandler:addKeyword({ "augur" }, StdModule.say, { npcHandler = npcHandler, text = "They try to protect the city and do a decent job. Well - no, a poor job, I mean a poor job." })
keywordHandler:addKeyword({ "mission" }, StdModule.say, { npcHandler = npcHandler, text = "You can bring me a mug of tea if you want to." })
keywordHandler:addAliasKeyword({ "quest" })

npcHandler:setMessage(MESSAGE_GREET, "What's your business here with the {magicians}, |PLAYERNAME|?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
