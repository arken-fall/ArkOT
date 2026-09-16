local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Always be on guard.'},
	{text = 'Hmm.'}
}
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({ "discuss" }, StdModule.say, { npcHandler = npcHandler, text = "I need your help in a matter of utmost {urgency}." })
keywordHandler:addKeyword({ "urgency" }, StdModule.say, { npcHandler = npcHandler, text = "The situation is complicated and it's even hard to say where to {start} best, just to describe it to you." })
keywordHandler:addKeyword({ "start" }, StdModule.say, { npcHandler = npcHandler, text = "You see, several incidents in history can be traced back to a single {source}." })
keywordHandler:addKeyword({ "source" }, StdModule.say, { npcHandler = npcHandler, text = "Things get murkier the further you go down in history, but that's not even necessary. Even today we can discern a certain pattern in recent {events}." })
keywordHandler:addKeyword({ "events" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Well, in Rathleton there was an individual at work, looking for some ancient artefact of power. ...",
	"To cover its escape the creature left another creature, known as the ravager to cover his tracks. But there is {more}.",
} })
keywordHandler:addKeyword({ "more" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Only recently someone was trying to manipulate the elven dream courts into releasing a monstrosity of nightmares, probably planning to control or recruit this creature. ....",
	"But those incidents were just some of {many}.",
} })
keywordHandler:addKeyword({ "many" }, StdModule.say, { npcHandler = npcHandler, text = "The recent rise of lycanthropy, the robbery of certain forbidden arcane texts and the vanishing of at least three dangerous individuals, targeted by the inquisition are just the tip of the {iceberg}." })
keywordHandler:addKeyword(
	{ "iceberg" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"There is a scheming going on behind the scenes. Powerful good people were corrupted. Evil-doers got backup and resources from a hidden ally. ...",
		"Powerful malignant creatures, gathering their kind under their banner and so much more. These things are not happening by chance. There is a pattern, a guiding {hand}.",
	} }
)
keywordHandler:addKeyword({ "hand" }, StdModule.say, { npcHandler = npcHandler, text = "This outside force is moving behind the scenes since ages. Our research suggests that this force probably even {predates} the rise of humanity." })
keywordHandler:addKeyword({ "predates" }, StdModule.say, { npcHandler = npcHandler, text = "Well, we are sure that the puppeteer behind all these events is an organisation. So old that even its name, the Shiron'Fal, has lost its meaning, because the {language} it originates from is long dead." })
keywordHandler:addKeyword(
	{ "language" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"It has a rather complex meaning and as far as we can tell it translates to 'army of those who are many, dedicated to the ultimate time of mayhem and despair'. ...",
		"Other, more handy names are army of the last battlefield, army of the last days, legion of mayhem, dread legion or simply the {legion}.",
	} }
)
keywordHandler:addKeyword(
	{ "legion" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"We know little for sure. You can look into our books to see some of our sources. But most are vague and some even contradictory. ...",
		"To summarise what we know, let me tell you this: The Shiron'Fal is an extremely old organisation. It seeks to accumulate power for some unknown but certainly sinister {goal}.",
	} }
)
keywordHandler:addKeyword({ "goal" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"For this purpose, the members gather knowledge, artefacts and powerful individuals. The members are formidable at certain fields of expertise. They are cunning and powerful and act with no regard for others, with no remorse or mercy. ...",
		"As they are doing this since ages, they must have acquired tremendous powers and knowledge. Their members often operate alone but are usually well funded with the necessary resources. ...",
		"Whatever their endgame might be, each of their operations pose a grave danger to the whole world and have to be {stopped}.",
	},
})
keywordHandler:addKeyword({ "stopped" }, StdModule.say, { npcHandler = npcHandler, text = "Here is where you come into play. We could identify the most recent plot of the Shiron'Fal and already had some {clashes}." })
keywordHandler:addKeyword({ "clashes" }, StdModule.say, { npcHandler = npcHandler, text = "In our efforts to hinder their plot, we achieved mixed results at best. But now things are escalating fast and we have to {hurry}." })
keywordHandler:addKeyword({ "hurry" }, StdModule.say, { npcHandler = npcHandler, text = "Our resources are already stretched thin, so we need your help with the most recent {problem}." })
keywordHandler:addKeyword({ "problem" }, StdModule.say, { npcHandler = npcHandler, text = "The legion tries to use a new form of twisted rituals to raise the bodies of well-known {knights}." })
keywordHandler:addKeyword({ "knights" }, StdModule.say, { npcHandler = npcHandler, text = {
	"The knights they aim at were tainted in life by their actions or happenstance. ...",
	"This leaves their bodies vulnerable to their special breed of necromancy that would raise them as powerful {lich}-knights.",
} })
keywordHandler:addKeyword({ "lich" }, StdModule.say, { npcHandler = npcHandler, text = "These powerful undead were a terrible threat on their own but it seems even they are just part of some larger {scheme} that we cannot make out yet." })
keywordHandler:addKeyword({ "scheme" }, StdModule.say, { npcHandler = npcHandler, text = "We are still working feverishly to uncover their goals but for now more imminent {threats} are at hand." })
keywordHandler:addKeyword({ "threats" }, StdModule.say, { npcHandler = npcHandler, text = "Death cultists of the Shiron'Fal are trying to locate the bodies of fallen knights and raise them in blasphemous {rituals}." })
keywordHandler:addKeyword({ "rituals" }, StdModule.say, { npcHandler = npcHandler, text = "The churches of the gods worked hand in hand to supply us with the means to {purge} the graves of those knights." })
keywordHandler:addKeyword({ "purge" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Reaching the graves will not be without danger and if you encounter the death cultists you will have to fight them. Even worse, they might have even succeeded in some cases. ...",
		"As a newly risen lich-knight is not able to leave the site of its resurrection for some time, you might have to fight some of them. ...",
		"Let us pray that you never come too {late} or else some of the fiends might be able to leave their crypts.",
	},
})
keywordHandler:addKeyword({ "locations" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"We have located twelve graves that have to be secured: In the old northern Edron graveyard, in the dark cathedral of the plains of havoc, in the ghostlands, on Cormaya, Somewhere in the Femor Hills, on Vengoth, ...",
		"in the graveyard of Darashia, in the old temple north of Thais, at the entrance to the orcland, one is on the southern ice islands, in a mountain on Kilmaresh, one on an island north-east of Ankrahmun.",
	},
})

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Jack Springer." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am an Inquisitor." })

npcHandler:addModule(FocusModule:new())
