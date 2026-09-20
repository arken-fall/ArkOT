local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

if not DELIVERED_PARCELS then
	DELIVERED_PARCELS = {}
end

local response = {
	[0] = "It's a pipe! What can be more relaxing for a gnome than to smoke his pipe after a day of duty at the front. At least it's a chance to do something really dangerous after all!",
	[1] = "Ah, a letter from home! Oh - I had no idea she felt that way! This is most interesting!",
	[2] = "It's a model of the gnomebase Alpha! For self-assembly! With toothpicks...! Yeeaah...! I guess.",
	[3] = "A medal of honour! At last they saw my true worth!",
}

local function initializeParcelDelivery(player)
	local playerGuid = player:getGuid()
	if not DELIVERED_PARCELS[playerGuid] then
		DELIVERED_PARCELS[playerGuid] = {}
	end

	return DELIVERED_PARCELS[playerGuid]
end

local function greetCallback(cid)
	local npc = Npc()
	local player = Player(cid)
	local playerGuid = player:getGuid()
	local deliveredParcels = initializeParcelDelivery(player)
	local parcelStatus = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main)

	if table.contains({ -1, 4 }, parcelStatus) or table.contains(deliveredParcels, npc:getId()) then
		return false
	end

	npcHandler:setMessage(MESSAGE_GREET, "Do you have something to deliver?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	local npc = Npc()
	local player = Player(cid)
	local playerGuid = player:getGuid()
	local deliveredParcels = initializeParcelDelivery(player)
	local parcelStatus = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main)

	if msgcontains(msg, "something") and not table.contains({ -1, 4 }, parcelStatus) then
		if table.contains(deliveredParcels, npc:getId()) then
			return true
		end

		if not player:removeItem(19219, 1) then
			npcHandler:say("But you don't have it...", cid)
			return npcHandler:releaseFocus(cid)
		end

		npcHandler:say(response[parcelStatus], cid)
		player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Lower_Parcel_Main, parcelStatus + 1)
		table.insert(deliveredParcels, npc:getId())
		npcHandler:releaseFocus(cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
