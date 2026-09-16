local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Albinius, a worshipper of the {Astral Shapers}." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Precisely time." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I find ways to unveil the secrets of the stars. Judging by this question, I doubt you follow my weekly publications concerning this research." })


-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "messengers" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We were created to communicate the will of the gods to you inhabitants of the world of matter. The gods send us visions and insights which - in turn - we announce to you. ... Sometimes though the gods might decide to grant those visions directly to a recipient. The way how a message is delivered is of no importance. All what matters is the content of a message.",
})
keywordHandler:addKeyword({ "tibiasula" }, StdModule.say, { npcHandler = npcHandler, text = "Fardos and Uman either created or awakened a new godess from her sleep: Tibiasula. She helped Fardos, Uman and Zathroth create the mighty column of Time. ... But then Zathroth killed Tibiasula and Fardos and Uman bonded her body to the column of Time, creating the elements: earth, water, fire and air." })
keywordHandler:addKeyword({ "insights" }, StdModule.say, { npcHandler = npcHandler, text = "In these dire times the gods guide their followers and chosen ones with the help of many means. Sometimes their guidance is subtle, sometimes they send visions of different kinds. Even we messengers do not directly communicate with the gods." })
keywordHandler:addKeyword({ "variphor" }, StdModule.say, { npcHandler = npcHandler, text = "The fiend from beyond. Do not speak or think its name as it might draw its attention on you." })
keywordHandler:addKeyword({ "zathroth" }, StdModule.say, { npcHandler = npcHandler, text = "There is no Zathroth but Uman-Zathroth. They are the unfathomable god of knowledge and magic." })
keywordHandler:addKeyword({ "created" }, StdModule.say, { npcHandler = npcHandler, text = "Some of us used to be beings like you. However, this was a long time ago and we hardly remember it. Others were created by the gods for a specific purpose. ... Even though some of us might look similar to you, each of us is a very specific individual with unique traits that you cannot perceive." })
keywordHandler:addKeyword({ "promise" }, StdModule.say, { npcHandler = npcHandler, text = "Not all is lost. The gods are rallying their forces to be prepared for the war to come. You will not fight alone. What is happening here is only the first step to prepare you." })
keywordHandler:addKeyword({ "prepare" }, StdModule.say, { npcHandler = npcHandler, text = "The gods guide us through visions and dreams. They have shown us an ancient, forgotten power that will help to prepare you for the things to come." })
keywordHandler:addKeyword({ "summary" }, StdModule.say, { npcHandler = npcHandler, text = "The race of the Astral Shapers had a vast knowledge on how to imbue items with magical power. Although most of their art has been forgotten, the knowledge might be recovered by finding Shaper records which include small fractions of their weapons." })
keywordHandler:addKeyword({ "bastesh" }, StdModule.say, { npcHandler = npcHandler, text = "Even the sea will rise to defend the land and the land will shield the sea." })
keywordHandler:addKeyword({ "fiends" }, StdModule.say, { npcHandler = npcHandler, text = "It is not yet time to name them. Even thinking about them may taint you. So watch your thoughts and take care because the enemy is powerful and devious." })
keywordHandler:addKeyword({ "crunor" }, StdModule.say, { npcHandler = npcHandler, text = "Be it man or be it beast, nature must rise to face the coming onslaught." })
keywordHandler:addKeyword({ "fardos" }, StdModule.say, { npcHandler = npcHandler, text = "Fardos the Creator is one of the elder gods, together with Uman Zathroth. Fardos always was driven by the need to create and give life, overflowing with creative power." })
keywordHandler:addKeyword({ "fafnar" }, StdModule.say, { npcHandler = npcHandler, text = "The suns will always shine on Tibia." })
keywordHandler:addKeyword({ "nornur" }, StdModule.say, { npcHandler = npcHandler, text = "Nornur is the god of fate. He is a child of Fardos and the element Air." })
keywordHandler:addKeyword({ "urgith" }, StdModule.say, { npcHandler = npcHandler, text = "Even his endless legions will not be enough to stop the threat. But they might turn the tides of battle." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "The first paladin has visited us many time. Her insights have proven as very useful." })
keywordHandler:addKeyword({ "kirok" }, StdModule.say, { npcHandler = npcHandler, text = "Kirok was created in a attempt to separate Uman and Zathroth." })
keywordHandler:addKeyword({ "banor" }, StdModule.say, { npcHandler = npcHandler, text = "Banor will recruit our forces against the fiends of beyond and you will be his vanguard!" })
keywordHandler:addKeyword({ "hope" }, StdModule.say, { npcHandler = npcHandler, text = "The gods promise new hope in the fight against the fiends from beyond." })
keywordHandler:addKeyword({ "know" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The ancient race of the Astral Shapers were highly talented in charging items with magical energy. They used mighty forges and charging stations to add special and useful properties to items. ... They were wiped out and their cities destroyed but some of their legacy survived. At certain places of power their charging stations have endured the ravages of time. ... Even though their knowledge was shattered, some of it still exists. The so-called Shaper records is a text collection which was written down in ancient times. ... It will be our duty to the gods to unearth this knowledge, find the lost forges and use them to prepare for the battles to come.",
})
keywordHandler:addKeyword({ "gods" }, StdModule.say, { npcHandler = npcHandler, text = "Fear not. The gods are with us. In these days this is even recognisable by the most ignorant." })
keywordHandler:addKeyword({ "uman" }, StdModule.say, { npcHandler = npcHandler, text = "There is no Uman but Uman-Zathroth. They are the unfathomable god of knowledge and magic." })
keywordHandler:addKeyword({ "blog" }, StdModule.say, { npcHandler = npcHandler, text = "May his rage strike down the enemies of creation." })
keywordHandler:addKeyword({ "brog" }, StdModule.say, { npcHandler = npcHandler, text = "Brog is the son of Zathroth and Fafnar is a malovent god. He tried to conquer the realms long ago." })
keywordHandler:addKeyword({ "suon" }, StdModule.say, { npcHandler = npcHandler, text = "The suns will always shine on Tibia." })
keywordHandler:addKeyword({ "toth" }, StdModule.say, { npcHandler = npcHandler, text = "He's the guardian of the dead. He was created by Fardos when it when he saw that Urgith wouldn't keep the dead at their rest but using them as an army of undeath. Therefore Toth is called the Warden of Souls." })

npcHandler:addModule(FocusModule:new())
