local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Pssst!'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local npc = Npc()
	local playerId = cid:getId()
	local player = Player(cid)

	if player:getStorageValue(Storage.Quest.U8_1.SecretService.AVINMission01) == 1 and player:getItemCount(402) > 0 then
		player:setStorageValue(Storage.Quest.U8_1.SecretService.AVINMission01, 2)
		npcHandler:say("I don't like the way you look. Help me boys!", cid)
		for i = 1, 2 do
			Game.createMonster("Bandit", npc:getPosition())
		end
		npcHandler.topic[playerId] = 0
	else
		npcHandler:setMessage(MESSAGE_GREET, "Pssst! Be silent. Do you wish to {buy} something?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "letter") then
		if player:getStorageValue(Storage.Quest.U8_1.SecretService.AVINMission01) == 2 then
			npcHandler:say("You have a letter for me?", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			if player:removeItem(402, 1) then
				player:setStorageValue(Storage.Quest.U8_1.SecretService.AVINMission01, 3)
				npcHandler:say("Oh well. I guess I am still on the hook. Tell your 'uncle' I will proceed as he suggested.", cid)
			else
				npcHandler:say("You don't have any letter!", cid)
			end
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye. Tell others about... my little shop here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye. Tell others about... my little shop here.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "My grandfather had seen it with his own eyes!" })
keywordHandler:addKeyword({ "berfasmur" }, StdModule.say, { npcHandler = npcHandler, text = "So, you are a new recruit in the ranks of the rebellion! To proof your worthyness, go and get us a magic crystal." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "Shhh! That's of no concern to me." })
keywordHandler:addKeyword({ "gamel" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, you know my name. Please don't tell it to the others." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Names don't matter." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am selling some... things." })

npcHandler:addModule(FocusModule:new())
