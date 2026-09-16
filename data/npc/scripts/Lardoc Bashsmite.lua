local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "work" }, StdModule.say, { npcHandler = npcHandler, text = "Here's the situation: a tide of hazardous bugs, the gnomes named them {diremaws}, threatens our base. Then there is some kind of {growth} which seems connected to them somehow. We need to get rid of both." })
keywordHandler:addKeyword({ "worth" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"You're already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you'll still need to help the dwarves and gnomes of this outpost to show your worth. ...",
		"We also found suspicious devices carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what's happening all around us. ... ",
		"If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.",
	},
})
keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Leading the charge! It's a war down here. I maintain the outer defences and supplies which are organised back in Kazordoon and also by the gnomes. ...",
		"I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you're capable, you'll get an oportunity to help destroying the weird machines, pumping lava into the caves leading to the most dangerous enemies.",
		"But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it's our obligation to annihilate them.",
	},
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Bashsmite. That's all you need to know." })

npcHandler:setMessage(MESSAGE_GREET, "Since you are obviously not one of my relatives who pays me a long overdue visit, we should get {work} right away. We'll see if you can prove your {worth} to our alliance.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

-- npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
-- npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
