local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "If you're willing to help us, we could need an escort for arriving {ordnance}, help with {charting} the cave system and someone needs to get some heat {measurements} fast." })
keywordHandler:addKeyword({ "worthy" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"You're already known amongst the gnomes, member of the Bigfoot Brigade. I will make sure that the alliance learns of your deeds but you'll still need to help the dwarves and gnomes of this outpost to show your worth. ...",
		"We also found {suspicious devices} carried by all kinds of creatures down here. Down here, they are of extreme worth to us since they could contain the key to what's happening all around us. ...",
		"If you can aquire any, return them to me and I make sure to tell the others of your generosity. Return to me afterwards to check on your current {status}.",
	},
})
keywordHandler:addKeyword({ "base" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Gnomish supplies and ingenuity have helped to establish and fortify this outpost. ...",
	"Our knowledge of the enemy and it's tactics would be of more use if the dwarves would listen to us somewhat more. But gnomes have learned to live with the imperfection of the other races.",
} })
keywordHandler:addKeyword({ "efforts" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Our surveys of the area showed us some spikes in heat and seismic activity at very specific places. ...",
		"We conclude this is no coincidence and the enemy is using devices to pump up the lava to flood the area. We have seen it before and had to retreat each time. ...",
		"This time though we might have a counter prepared - given me manage to pierce their defences.",
	},
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Gnomus." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm the main gnomish contact for this base. I coordinate our efforts with those of the dwarves to ensure everything is running smoothly." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, member of the Bigfoot Brigade. We could really use some {help} from you right now. You should prove {worthy} to our alliance.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

-- npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
-- npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
-- npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
