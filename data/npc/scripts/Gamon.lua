local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Any time\'s a good time to buy some furniture!'}
}
npcHandler:addModule(VoiceModule:new(voices))

-- Wooden Stake
local stakeKeyword = keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "Making a stake from a chair? Are you insane??! I won't waste my chairs on you for free! You will have to pay for it, but since I consider your plan a blasphemy, it will cost 5000 gold pieces. Okay?" }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) ~= -1
end)

stakeKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Argh... my heart aches! Alright... a promise is a promise. Here - take this wooden stake, and now get lost.", ungreet = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 5000
end, function(player)
	player:removeMoneyBank(5000)
	player:addItem(5941, 1)
end)

stakeKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "You can't even pay for that.", reset = true })
stakeKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "Phew. No chair-killing.", reset = true })

-- Others
npcHandler:setMessage(MESSAGE_GREET, "Nice to meet you, Mister |PLAYERNAME|! Looking for furniture? You've come to the right place!")
npcHandler:setMessage(MESSAGE_FAREWELL, "You'll come back. They all do.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Have a look. Most furniture comes in handy kits. Just use them in your house to assemble the furniture. Do you want to see only a certain type of furniture?")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "the first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "A thaian folklore tale." })
keywordHandler:addKeyword({ "marsh willow" }, StdModule.say, { npcHandler = npcHandler, text = "You can't get any better wood in this world. And it has got a nice smell to it, too. There is nothing nicer than a marsh willow campfire." })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "Excellent! Never felt better in my life!" })
keywordHandler:addKeyword({ "merchants" }, StdModule.say, { npcHandler = npcHandler, text = "Now those people really talk business. There is a new era dawning." })
keywordHandler:addKeyword({ "rebellion" }, StdModule.say, { npcHandler = npcHandler, text = "Well - a few paranoid souls think that Venore wants to gain independence from Thais. Nothing more than rumours." })
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "He's incredibly slow. Just your average postman, I guess." })
keywordHandler:addKeyword({ "watching" }, StdModule.say, { npcHandler = npcHandler, text = "Look! They are doing it again! And they are always smiling!" })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "Ecle- who? No... can't say I know him." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "That old monk has probably never left that overcrowded town here." })
keywordHandler:addKeyword({ "smiling" }, StdModule.say, { npcHandler = npcHandler, text = "Yes! Smiling! How a professional sales artist such as myself is supposed to work in such an atmosphere is beyond me!" })
keywordHandler:addKeyword({ "quality" }, StdModule.say, { npcHandler = npcHandler, text = "Our furniture is produced by the finest carpenters on the continent using the rare wood of the Venorean marsh willow!" })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "The place where it all happens. That town really rocks! Thais could learn a lot about interior decoration from Venore!" })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "I've said it a thousand times! That place needs a complete refurbishing!" })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Druids are obsessed with trees and the bane of any carpenter." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Those knights know how to party. And after such parties there's always need for new furniture." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "The sorcerers guild could really need someone with taste to redecorate it." })
keywordHandler:addKeyword({ "creeps" }, StdModule.say, { npcHandler = npcHandler, text = "Yes! I can never figure out which is which. And they are always watching me!" })
keywordHandler:addKeyword({ "artist" }, StdModule.say, { npcHandler = npcHandler, text = "Yes! Selling is a form of art! The elaborate combination of rhetoric and acting which serves to create a sublime longing for the infinite, embodied by second class furniture." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "Thais is obsessed with its past. Everybody here is so proud of their history. Bah! Thais might have a long history, but it has no idea when it comes to interior decoration." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Tibia is a wonderful place full of business opportunities." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "She's pretty, but I am the kind of man who enjoys a long and healthy life." })
keywordHandler:addKeyword({ "guild" }, StdModule.say, { npcHandler = npcHandler, text = "Now those people really talk business. There is a new era dawning." })
keywordHandler:addKeyword({ "power" }, StdModule.say, { npcHandler = npcHandler, text = "There are a few rumours about a rebellion, but that is all they are." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My friends call me Gamon. My fans call me the incredible Gammy!" })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Any time's a good time to buy some furniture." })
keywordHandler:addKeyword({ "shop" }, StdModule.say, { npcHandler = npcHandler, text = "I am Thais's foremost furniture salesman. Are you interested in my offers?" })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "His Royal Highness will start to appreciate the superior quality of our stock soon enough!" })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He sells stuff of inferior quality. Nothing compared to venores high quality goods." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "Bozo! Damn that clown! He keeps making fake orders. It isn't funny to deliver a wardrobe to an address that doesn't even exist, you know!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am Thais's foremost furniture salesman. Are you interested in my offers?" })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "I heard rumours he has some special offers for customers who know to ask for the correct things." })
keywordHandler:addKeyword({ "rug" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, silly me! Rugs are out of stock at the moment! But we expect a new shipment anytime. Just watch out for the next update!... Of our inventory I mean." })

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "topsy" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, those twins. Strange people they are. Oh, they are great to work with, of course. Excellent quality, competetive prices! But well... they give me the creeps!" })
keywordHandler:addKeyword({ "turvy" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, those twins. Strange people they are. Oh, they are great to work with, of course. Excellent quality, competetive prices! But well... they give me the creeps!" })
keywordHandler:addKeyword({ "twins" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, those twins. Strange people they are. Oh, they are great to work with, of course. Excellent quality, competetive prices! But well... they give me the creeps!" })

npcHandler:addModule(FocusModule:new())
