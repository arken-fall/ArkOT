local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Ah.'},
	{text = 'We need more volunteers!'},
	{text = 'And they call this "deep"...'},
	{text = 'Preparation is paramount.'}
}
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "Well, the biggest problem we need to address are the ever charging {subterraneans} around here. And on top of that, there's the threat of the Lost, who quite made themselves at {home} in these parts." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Maintainin' this whole operation, the dwarven involvement 'course. Don't know about them gnomes but if I ain't gettin' those dwarves in line, there'll be chaos down here. I also oversee the {defences} and {counterattacks}." })
keywordHandler:addKeyword({ "defences" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The attacks of the enemy forces are fierce but we hold our ground. ... ",
		"I'd love to face one of their generals in combat but as their masters they cowardly hide far behind enemy lines and I have other duties to fulfil. ... ",
		"I envy you for the chance to thrust into the heart of the enemy, locking weapons with their jaws... or whatever... and see the fear in their eyes when they recognise they were bested.",
	},
})
keywordHandler:addKeyword({ "counterattacks" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"I welcome a fine battle as any dwarf worth his beard should do. As long as it's a battle against something I can hit with my trusty axe. ...",
		"But here the true {enemy} eludes us. We fight wave after wave of their lackeys and if the gnomes are right the true enemy is up to something far more sinister. ",
	},
})
keywordHandler:addKeyword({ "enemy" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"I have no idea what kind of creeps are behind all this. Even the gnomes don't and they have handled that stuff way more often. ...",
		"But even if we knew nothing more about them, the fact alone that they employ the help of those mockeries of all things dwarfish, marks them as an enemy of the dwarves and it's our obligation to annihilate them.",
	},
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Klom Stonecutter's the name. " })

npcHandler:setMessage(MESSAGE_GREET, {
	"Greetings. A warning straight ahead: I don't like loiterin'. If you're not here to {help} us, you're here to waste my time. Which I consider loiterin'. Now, try and prove your {worth} to our alliance. ... ",
	"I have sealed some of the areas far too dangerous for anyone to enter. If you can prove you're capable, you'll get an opportunity to help destroy the weird machines, pumping lava into the caves leading to the most dangerous enemies.",
})
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

-- npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
-- npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
