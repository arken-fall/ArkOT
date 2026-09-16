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

	if msgcontains(msg, "supplies") then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission01) == 1 then
			npcHandler:say({
				"What!? I bet, Baa'leal sent you! ...",
				"I won't tell you anything! Shove off!",
			}, cid)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission01, 2)
		else
			npcHandler:say("I won't talk about that.", cid)
		end
	elseif msgcontains(msg, "ankrahmun") then
		npcHandler:say({
			"Yes, I've lived in Ankrahmun for quite some time. Ahh, good old times! ...",
			"Unfortunately I had to relocate. <sigh> ...",
			"Business reasons - you know.",
		}, cid)
	end
	return true
end

keywordHandler:addKeyword({ "prison" }, StdModule.say, { npcHandler = npcHandler, text = "You mean that's a JAIL? They told me it's the finest hotel in town! THAT explains the lousy roomservice!" })
keywordHandler:addKeyword({ "jail" }, StdModule.say, { npcHandler = npcHandler, text = "You mean that's a JAIL? They told me it's the finest hotel in town! THAT explains the lousy roomservice!" })
keywordHandler:addKeyword({ "cell" }, StdModule.say, { npcHandler = npcHandler, text = "You mean that's a JAIL? They told me it's the finest hotel in town! THAT explains the lousy roomservice!" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my little kingdom, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, visit me again. I will be here, promised.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, visit me again. I will be here, promised.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I am great! Free food, free room, and now and then someone coming down here to ask me silly questions. Wouldn't you love that, too?" })
keywordHandler:addKeyword({ "criminal" }, StdModule.say, { npcHandler = npcHandler, text = "Bah, I did nothing serious. I just had a little fun. In Ankrahmun nobody would have cared about these kind of things..." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah sure, I go out with him all the time... NOT." })
keywordHandler:addKeyword({ "citizen" }, StdModule.say, { npcHandler = npcHandler, text = "Rich enough to spare a little, don't you agree? Well, they didn't agree." })
keywordHandler:addKeyword({ "noodles" }, StdModule.say, { npcHandler = npcHandler, text = "I bet one could get some fine ransom, if he dognaps this furball." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "At least I am safe from them down here." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "By the gods, he visits us 'criminals' now and then to 'save' us. Who is going to save me from this boredom on two legs?" })
keywordHandler:addKeyword({ "money" }, StdModule.say, { npcHandler = npcHandler, text = "Gold got me in here. But I'd offer you some gold for keys." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "I love the city. I just wish I could see some other part of it now and then." })
keywordHandler:addKeyword({ "party" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah! Come in and let's have a party." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "Bah, the king's pawns. I spit on them." })
keywordHandler:addKeyword({ "gold" }, StdModule.say, { npcHandler = npcHandler, text = "Gold got me in here. But I'd offer you some gold for keys." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "I love the city. I just wish I could see some other part of it now and then." })
keywordHandler:addKeyword({ "slay" }, StdModule.say, { npcHandler = npcHandler, text = "Hey, most people I killed were even worse than me." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "I hardly hear any news down here." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Geee, someone stole my watch. Bad company down here." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Yeah, a king is a man that can rob people by law, and not by night like me." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Partos, but you can call me Party." })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "I sort of collect them. Broken key rings, that is. You never know. If you wanna trade, you know where to find me." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Guess it! I'll give you a hint: I am not in this cell to clean it up! ... I wish I had never left Ankrahmun..." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "The gods seldom show up down here, so don't ask me." })

npcHandler:addModule(FocusModule:new())
