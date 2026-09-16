local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "looking" }, StdModule.say, { npcHandler = npcHandler, text = "I need the help of some competent {adventurers} to handle a threat to all creation." })
keywordHandler:addKeyword({ "value" }, StdModule.say, { npcHandler = npcHandler, text = "This leaves us with no choice but to take action into our own {hands}." })
keywordHandler:addKeyword({ "threat" }, StdModule.say, { npcHandler = npcHandler, text = "I guess you know about the {background} and there is no need to tell you that the forces from beyond managed to acquire the parts of the godbreaker in a coup." })
keywordHandler:addKeyword({ "disassembled" }, StdModule.say, { npcHandler = npcHandler, text = "The secret locations of the godbreaker {parts} were revealed and due to trickery, the minions of Variphor aquired all of them." })
keywordHandler:addKeyword({ "obscure" }, StdModule.say, { npcHandler = npcHandler, text = "Those pieces of knowledge come in several forms and shapes. For most I can give you more or less specific hints where to start your {search}." })
keywordHandler:addKeyword({ "hands" }, StdModule.say, { npcHandler = npcHandler, text = "You have to {find} the veiled hoard of Zathroth, breach it and destroy the knowledge how to use the godbreaker." })
keywordHandler:addKeyword(
	{ "adventurer" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"Of course the first to ask would be the famous Avar Tar, but I heard he's already on a quest of his own and ...",
		"Well, let's say our last collaboration did not end too well. In fact, I'd be not even surprised if he pretended to not even know me. ...",
		"So I have to look elsewhere to handle this new {threat}.",
	} }
)
keywordHandler:addKeyword({ "background" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The goodbreaker was created in ancient times, when the war between the gods and their minions was on its height. Its creation took aeons and incredible sacrifices. ...",
		"Each part had to be crafted perfectly, to emulate the gods, so it would share 'the same place' with them. ...",
		"Mere mortals can not even perceive it in his whole but only recognize the part of it that is the physical representation in our world. ...",
		"If it was meant to be used as an actual weapon, as the ultimate threat, or if Zathroth was just tempted to use his knowledge in the ultimate way - to create something that could undo himself - we don't know. ...",
		"However in the end even Zathroth deemed it too much of a threat but instead of destroying the contraption once and for all, it was {disassembled} and hidden away.",
	},
})
keywordHandler:addKeyword(
	{ "parts" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"The parts alone do them no good. To assemble the parts, great skill, immense power and forbidden knowledge are necessary. ...",
		"The skill will be supplied by the fallen Yalahari and the power by Variphor itself. ...",
		"The only thing they are still lacking is the knowledge to assemble and operate the {godbreaker}.",
	} }
)
keywordHandler:addKeyword({ "godbreaker" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The godbreaker is a complex artifact. Incantation woven into incantation. The powers bound into it are so immense that the slightest mishandling could prove disastrous. ...",
		"o figure out how it works, let alone how it can be operated safely, could require several centuries of tireless study. And even then this information would be only partial. ...",
		"Yet the creation and operation of the godbreaker is just the kind of forbidden {knowledge} Zathroth values most, so it was compiled and stored.",
	},
})
keywordHandler:addKeyword({ "knowledge" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Of course the dangers of such knowledge were obvious. It was hidden in a sacred place devoted to Zathroth and dangerous knowledge. ...",
		"The hidden library, the forbidden hoard, the shrouded trove of knowledge or the veiled hoard of forbidden knowledge, the place has many names in many {myths}.",
	},
})
keywordHandler:addKeyword({ "myths" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The myths agree that the place is well hidden, extremely guarded and contains some of the most powerful pieces of knowledge in this world and probably beyond. ...",
		"However the knowledge about the godbreaker now poses a threat to all existence. In the hands of Variphor it can cause disaster in previously unknown ways. The gods themselves are in {peril}.",
	},
})
keywordHandler:addKeyword({ "peril" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Regardless of the dangers, the cult of Zathroth refused to destroy the knowledge of the godbreaker for good. ...",
	"They {value} dangerous knowledge that much, that they are unable to part from it, even when faced with the utter destruction of creation.",
} })
keywordHandler:addKeyword(
	{ "find" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"I know it's asked much but it's no longer a matter of choice. ...",
		"The enemy is moving and I have reports that suggest the minions of Variphor are actively searching for Zathroth's library. They must not be allowed to succeed. ...",
		"We must be the first to {reach} the hoard and make sure the enemy doesn't get the information he needs.",
	} }
)
keywordHandler:addKeyword({ "reach" }, StdModule.say, { npcHandler = npcHandler, text = {
	"I'd recommend to follow the few leads me and my associates could gather so far. ...",
	"Old myths, some {rumors} about old texts and other pieces of knowledge that I could use to figure out where to locate the hidden library and how to enter it.",
} })
keywordHandler:addKeyword({ "rumors" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Hints about the shrouded hoard are numerous, though most are general mentions in texts that deal with Zathroth. But there are other sources. ...",
		"Like texts about ancient liturgies of Zathroth and historical documents that might give us clues. I already compiled everything of value from the sources that were openly available. ...",
		"To gather the more {obscure} parts of knowledge, however, I'll need your help.",
	},
})

npcHandler:setMessage(MESSAGE_GREET, "Greetings seekers of knowledge. You seem to be just the person I'm {looking} for.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

-- npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
--

npcHandler:addModule(FocusModule:new())
