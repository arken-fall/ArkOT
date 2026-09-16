local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Grarkharok\'s bestest troll tribe! Yeee, good name!'},
	{text = 'Grarkharok make new tribe here! Me Chief now!'},
	{text = 'Me like to throw rocks, me also like frogs! Yumyum!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local mission = Storage.Quest.U8_2.TrollSabotageQuest
local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "cloak") or msgcontains(msg, "feather") or msgcontains(msg, "swan") or msgcontains(msg, "maiden") then
		if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 12 then
			npcHandler:say("Hahaha! Grarkharok take cloak from pretty girl. Then ... girl is swan. Grarkharok wants eat but flies away. Grarkharok not understand. Not need cloak, too many feathers. Give cloak to To ... Ta ... Tereban in Edron. Getting shiny coins and meat.", cid)
		else
			npcHandler:say("Grarkharok already say everything! Not want talk! Go away!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "kill") or msgcontains(msg, "hurt") or msgcontains(msg, "pain") then
		if player:getStorageValue(Storage.Quest.U8_2.TrollSabotageQuest.Questline) == 1 then
			npcHandler.topic[playerId] = 1
		end
		npcHandler:say("Hrhrhrhr! Me no fear of human! Me Chief Grarkharok!!", cid)
	elseif msgcontains(msg, "lady") or msgcontains(msg, "queen") or msgcontains(msg, "woman") or msgcontains(msg, "cave") or msgcontains(msg, "house") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("You help?? Human know troll lady for Grarkharok??", cid)
			npcHandler.topic[playerId] = 2
		else
			npcHandler:say("Found lady for Grarkharok?!? Must be good-looking, hairy lady, yknow! Go find!!", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("What name of troll lady??", cid)
			npcHandler.topic[playerId] = 3
		elseif npcHandler.topic[playerId] == 100 then
			if player:removeItem(5934, 1) then
				npcHandler:say("Gimme gimme! Yumyumyum! <BUUUURP>.", cid)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You no have dead frog! Bring dead frog!!! Grarkharok hungry!!", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 101 then
			if player:removeItem(3998, 1) then
				npcHandler:say("Gimme gimme! Yumyumyum! <BUUUURP>.", cid)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You no have tasty snake! Bring tasty snake!!! Grarkharok hungry!!", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif npcHandler.topic[playerId] == 3 then
		npcHandler:say("|PLAYERNAME|?!? Sound good! Bring troll lady to Grarkharok!! Here, give troll lady! Take take! Bring lady to Grarkharok for make tribe!! Now GO!", cid)
		npcHandler.topic[playerId] = 0
		player:setStorageValue(mission.Questline, 2)
		player:addItem(7754, 1)
	elseif msgcontains(msg, "frog") then
		npcHandler:say("Have dead frog for Grarkharok??", cid)
		npcHandler.topic[playerId] = 100
	elseif msgcontains(msg, "snake") then
		npcHandler:say("Have tasty snake for Grarkharok??", cid)
		npcHandler.topic[playerId] = 101
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[playerId] == 100 or npcHandler.topic[playerId] == 101 then
			npcHandler:say("Grarkharok angry now!! Want throw rock on human cave down hill again!", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 101 then
		npcHandler:say("Huh?? No understand!", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end
-- basic
keywordHandler:addKeyword({ "tribe" }, StdModule.say, { npcHandler = npcHandler, text = "Me tribe in production! Only need troll lady!" })
keywordHandler:addAliasKeyword({ "troll" })
keywordHandler:addAliasKeyword({ "other" })

keywordHandler:addKeyword({ "gold" }, StdModule.say, { npcHandler = npcHandler, text = "Me no nothing! Need all money to make Grarkharok tribe!" })
keywordHandler:addAliasKeyword({ "crystal" })
keywordHandler:addAliasKeyword({ "platinum" })
keywordHandler:addAliasKeyword({ "money" })
keywordHandler:addAliasKeyword({ "pay" })
keywordHandler:addKeyword({ "boom" }, StdModule.say, { npcHandler = npcHandler, text = "Grarkharok like BOOM, BOOM sound! Go mountain, push rock and BOOM!" })
keywordHandler:addKeyword({ "bottom" }, StdModule.say, { npcHandler = npcHandler, text = "Like it?? Hope troll lady also like it!" })
keywordHandler:addAliasKeyword({ "butt" })
keywordHandler:addKeyword({ "human" }, StdModule.say, { npcHandler = npcHandler, text = "Me no like human. Need quiet to make tribe! Only need troll lady!" })
keywordHandler:addKeyword({ "chief" }, StdModule.say, { npcHandler = npcHandler, text = "Yeye, me stole chief club from Fragratosh, hrhrhrh! Now make me own tribe!" })
keywordHandler:addKeyword({ "fragratosh" }, StdModule.say, { npcHandler = npcHandler, text = "Fragratosh stupid. He chief of me old tribe. No frogs, no snakes, no smashing humans withrocks. Booooooring tribe! Now me make own tribe!!" })
keywordHandler:addKeyword({ "necklace" }, StdModule.say, { npcHandler = npcHandler, text = "Grarkharok no listen to talk of stinky human! Lalalalalala! Like song? Grarkharok made!" })
keywordHandler:addAliasKeyword({ "do" })
keywordHandler:addAliasKeyword({ "reason" })
keywordHandler:addAliasKeyword({ "why" })
keywordHandler:addKeyword({ "destroy" }, StdModule.say, { npcHandler = npcHandler, text = "You have what want! Go go, find lady so be Grarkharok tribe!!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Me be Grarkharok!!" })
keywordHandler:addAliasKeyword({ "grarkharok" })
keywordHandler:addKeyword({ "gurak cha rak" }, StdModule.say, { npcHandler = npcHandler, text = "You say troll speak!! Hmmm, sound like south tribe! You know Ingortrak ?? He chief of big tribe in jungle! Good chief he is!" })
keywordHandler:addKeyword({ "item" }, StdModule.say, { npcHandler = npcHandler, text = "I Tem?!?!? No know! Maybe YOU Tem?" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Me be Grarkharok. No me name Job!" })
keywordHandler:addAliasKeyword({ "nothing" })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Tribe Grarkharok will rules Tibia! Me only need troll lady, then start tribe!" })
keywordHandler:addKeyword({ "mission" }, StdModule.say, { npcHandler = npcHandler, text = "Grarkharok destroy human cave down hill! Human away, my mission done,hrhrhrhrhr!" })
keywordHandler:addAliasKeyword({ "quest" })
npcHandler:setMessage(MESSAGE_GREET, "Me Chief Grarkharok! No do {nothing}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Grarkharok be {chief}!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Grarkharok be {chief}!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
