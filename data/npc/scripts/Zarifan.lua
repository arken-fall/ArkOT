local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = '<sigh> lost... word...'},
	{text = '<sigh> ohhhh.... memories...'},
	{text = 'The secrets... too many... sleep...'},
	{text = 'Loneliness...'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "magic") and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission70) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission71) < 1 then
		npcHandler:say("...Tell me...the first... magic word.", cid)
		npcHandler.topic[playerId] = 1
	elseif npcHandler.topic[playerId] == 1 and msgcontains(msg, "friendship") then
		npcHandler:say("Yes... YES... friendship... now... second word?", cid)
		npcHandler.topic[playerId] = 2
	elseif npcHandler.topic[playerId] == 2 and msgcontains(msg, "lives") then
		npcHandler:say("Yes... YES... friendship... lives... now third word?", cid)
		npcHandler.topic[playerId] = 3
	elseif npcHandler.topic[playerId] == 3 and msgcontains(msg, "forever") then
		npcHandler:say({
			"Yes... YES... friendship... lives... FOREVER. ...",
			"What you seek.... is buried. Beneath the sand. No graves. ...",
			"Between a triangle of big stones you must dig... in the eastern caves. ...",
			"And say hello... to... my old friend... Omrabas.",
		}, cid)
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission71, 1)
	else
		npcHandler:say("...continue with your mission...", cid)
	end
end

keywordHandler:addKeyword({ "mission" }, StdModule.say, { npcHandler = npcHandler, text = "..what about {magic}.." })

npcHandler:setMessage(MESSAGE_GREET, "... ... hello...magic... words?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
