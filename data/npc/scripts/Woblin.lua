local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Stinky Old Nasty.'},
	{text = 'Mine precious!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "precious") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) < 1 then
			npcHandler:say("Me not give key! Key my precious now!", cid)
			npcHandler.topic[playerId] = 0
		end
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) == 1 then
			npcHandler:say(
				"Me not give key! Key my precious now! \z
				By old goblin law all that one has in his pockets for two days is family heirloom! \z
				Me no part with my precious ... hm unless you provide Woblin with some {reward}!", cid
			)
			npcHandler.topic[playerId] = 1
		end
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) >= 4 then
			npcHandler:say("You can keep lousy key! Didn't like it anymore anyway.", cid)
			npcHandler.topic[playerId] = 0
		end
	end

	if msgcontains(msg, "reward") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say(
				"Me good angler but one fish eludes me since many many weeks. I call fish ''Old Nasty''. \z
				You might catch him in this cave, in that pond there. Bring me {Old Nasty} and I'll give you key!", cid
			)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 2)
			npcHandler.topic[playerId] = 0
		end
	end

	if msgcontains(msg, "old nasty") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) >= 2 then
			npcHandler:say("You bring me Old Nasty?", cid)
			npcHandler.topic[playerId] = 2
		end
	end

	if msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 2 then
			if player:getItemCount(21402) >= 1 then
				if player:removeItem(21402, 1) then
					npcHandler:say("You did it! That's my old arch enemy! Here take lousy key. Didn't like it anymore anyway.", cid)
					local TheDormKey = player:addItem(21392, 1)
					TheDormKey:setActionId(103)
					player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 4)
					npcHandler.topic[playerId] = 0
				end
			else
				npcHandler:say("You have not Old Nasty! Odd, you stink just like him though!", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	end

	return true
end

keywordHandler:addKeyword({ "goblins" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "No part of clan. Me prefer company of {precious}. Or mirror image. Always nice to see pretty me!",
})
keywordHandler:addKeyword({ "minotaur" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Me not like minos either. Huge mean bullies! Woblin peaceful here.",
})
keywordHandler:addKeyword({ "troll" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Me not like trolls. Big furry stinky trolls!",
})
keywordHandler:addKeyword({ "dwarf", "dwarves" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Mean short people, make Woblin's clan do slave work for them.",
})
keywordHandler:addKeyword({ "cyclops" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Ugly stomping giants, always busy hammering stone.",
})
keywordHandler:addKeyword({ "quest" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "What you on quest for? Go leave Woblin alone with {precious}.",
})
keywordHandler:addKeyword({ "help" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Fish good. Fish quiet and tasty. Woblin try to catch fishes, but... hm you could earn yourself {reward}!",
})
keywordHandler:addKeyword({ "trade", "offer" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Me not trade! Goods my precious now! By old goblin law all that one has in his pockets for two days is family heirloom! Me no part with my goods ... hm unless you provide Woblin with some {reward}!",
})
keywordHandler:addKeyword({ "key" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Lost what? Key?",
})

npcHandler:setMessage(MESSAGE_GREET, "Hi there human!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
