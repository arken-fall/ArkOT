local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "Oh well. I am cursed to live in this unworthy shape but I still hope that the curse will be lifted one day." })
keywordHandler:addKeyword({ "best kisser" }, StdModule.say, { npcHandler = npcHandler, text = "You probably have the potential. If your kiss does not lift the curse, travel the world to learn more about kissing." })
keywordHandler:addKeyword({ "princess" }, StdModule.say, { npcHandler = npcHandler, text = "An evil witch has cursed me to live as a pig until the best kisser in the world gives me a kiss." })
keywordHandler:addKeyword({ "kissing" }, StdModule.say, { npcHandler = npcHandler, text = "Learn as much about kissing as you can. I'm sure you can learn the basics in the major cities. To refine your skill you might need to travel to the countryside, explore sparsely populated areas and even face some dangers." })
keywordHandler:addKeyword({ "curse" }, StdModule.say, { npcHandler = npcHandler, text = "An evil witch has cursed me to live as a pig until the best kisser in the world gives me a kiss." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Shantalla." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you think I'd wear a watch?" })
keywordHandler:addKeyword({ "lift" }, StdModule.say, { npcHandler = npcHandler, text = "Only a kiss of the king of all kissers will break the curse." })
keywordHandler:addKeyword({ "oink" }, StdModule.say, { npcHandler = npcHandler, text = "Don't kill me! I taste bad!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Once I was a beautiful princess but now I'm only an ordinary pig without much dignity!" })
keywordHandler:addKeyword({ "pig" }, StdModule.say, { npcHandler = npcHandler, text = "It's just the appearance. Inside I am still the beautiful princess I used to be." })

npcHandler:addModule(FocusModule:new())
