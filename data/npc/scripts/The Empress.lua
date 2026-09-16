local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function greetCallback(cid)
	local player = Player(cid)
	local playerId = cid

	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) == 10 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"You succeeded! Issavi is safe again. Take this as a sign of our grace and gratitude, brave mortal being. It is a precious relic from earlier times. More precisely, it is one of four parts of the relic called the Regalia of Suon. ...",
			"Should you ever find the other three parts, a talented jeweler might be able to combine them and recreate the regalia for you.",
		})
		player:addItem(31573, 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, 11)
	elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.Memories) == 5 then
		player:addItem(31414, 1)
		npcHandler:setMessage(MESSAGE_GREET, {
			"I see. There is enough and adequate evidence that the Ambassador of Rathleton is indeed an arch traitor. So, Eshaya was right. Well done, mortal being. You have proven your loyalty and bravery, therefore allow me to ask you one more favour. ...",
			"The Cult of Fafnar is a serious problem for Issavi. The cultists are roaming the sewers and catacombs beneath the city now and again but this time they are really up to something. ...",
			"As a member of the Sapphire Blade found out, they are planning to cause a major earthquake, that could severely damage or even destroy Issavi. You may wonder how. ...",
			"Well, they want to activate five Fafnar statues which they have already enchanted. They are hidden in the catacombs underneath the city. Please go down and search for the statues. ...",
			"Then use this sceptre to bless them in the name of Suon and Bastesh. This will destroy the disastrous enchantment and Issavi will be safe again.",
		})
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks, 0)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.BlessedStatues, 0)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.Memories, 6)
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
