local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'What a beautiful palace. The Kilmareshians are highly skilful architects.'},
	{text = 'The new treaty of amity and commerce with Kilmaresh is of utmost importance.'},
	{text = 'The pending freight from the saffron coasts is overdue.'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "present") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Third.Recovering) == 2 then
			if player:getItemById(31263, true) then
				npcHandler:say("This is a very beautiful ring. Thank you for this generous present!", cid)
				player:removeItem(31263, 1)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Third.Recovering, 3)
			else
				npcHandler:say("Didn't you bring my gift?", cid)
			end
		else
			npcHandler:say("I don't need a present right now. Thank you.", cid)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, friend.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
