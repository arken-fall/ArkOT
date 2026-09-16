local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Hum hum, huhum'},
	{text = 'Silly lil\' human'}
}
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local msg = string.lower(msg)
	local isYes = (msg == "yes")

	-- uth'lokr
	if msgcontains(msg, "uth'lokr") then
		local stor = player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops)

		-- Step 1 - Deal with A Sweaty Cyclops
		if stor < 1 then
			npcHandler:say("Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?", cid)
			npcHandler.topic[playerId] = 1
			return true
		end

		-- Bast skirt delivery (storage == 1)
		if stor == 1 then
			npcHandler:say("Lil' one bring three bast skirts.", cid)
			npcHandler.topic[playerId] = 4
			return true
		end

		-- Dragon shield Trade (storage == 2)
		if stor == 2 then
			npcHandler:say("Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?", cid)
			npcHandler.topic[playerId] = 6
			return true
		end
	end

	-- Yes Handlers (uth'lokr (bast skirts))
	-- uth'lokr - Step 1
	if isYes and npcHandler.topic[playerId] == 1 then
		npcHandler:say("Wait. Me work no cheap is. Do favour for me first, yes?", cid)
		npcHandler.topic[playerId] = 2
		return true
	end

	-- uth'lokr - Step 2
	if isYes and npcHandler.topic[playerId] == 2 then
		npcHandler:say("Me need gift for woman. We dance, so me want to give her bast skirt. But she big is. So I need many to make big one. Bring three okay? Me wait.", cid)
		player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.DefaultStart, 1)
		player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops, 1)
		npcHandler.topic[playerId] = 3
		return true
	end

	-- bast skirts delivery
	if isYes and npcHandler.topic[playerId] == 4 then
		if player:removeItem(3560, 3) then
			npcHandler:say("Good good! Woman happy will be. Now me happy too and help you.", cid)
			player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops, 2)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("Lil' one bring three bast skirts.", cid)
			npcHandler.topic[playerId] = 3
		end
		return true
	end

	----------------------------------------------------------------------------
	-- uth'kean (crown armor -> piece of royal stell)
	if msgcontains(msg, "uth'kean") then
		if player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Very noble. Shiny. Me like. But breaks so fast. Me can make from shiny armour. Lil' one want to trade?", cid)
			npcHandler.topic[playerId] = 5
			return true
		end
	end

	if isYes and npcHandler.topic[playerId] == 5 then
		if player:removeItem(3381, 1) then
			npcHandler:say("Cling clang!", cid)
			player:addItem(5887, 1)
			npcHandler.topic[playerId] = 0
		end
		return true
	end

	-- uth'lokr (dragon shield -> piece of draconian steel)
	if isYes and npcHandler.topic[playerId] == 6 then
		if player:removeItem(3416, 1) then
			npcHandler:say("Cling clang!", cid)
			player:addItem(5889, 1)
			npcHandler.topic[playerId] = 0
		end
		return true
	end

	-- za'ralator (devil helmet -> piece of hell steal)
	if msgcontains(msg, "za'ralator") then
		if player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Hellsteel is. Cursed and evil. Dangerous to work with. Me can make from evil helmet. Lil' one want to trade?", cid)
			npcHandler.topic[playerId] = 7
			return true
		end
	end

	if isYes and npcHandler.topic[playerId] == 7 then
		if player:removeItem(3356, 1) then
			npcHandler:say("Cling clang!", cid)
			player:addItem(5888, 1)
			npcHandler.topic[playerId] = 0
		end
		return true
	end

	-- uth'prta (giant sword -> huge chunk of crude iron)
	if msgcontains(msg, "uth'prta") then
		if player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Good iron is. Me friends use it much for fight. Me can make from weapon. Lil' one want to trade?", cid)
			npcHandler.topic[playerId] = 8
			return true
		end
	end

	if isYes and npcHandler.topic[playerId] == 8 then
		if player:removeItem(3281, 1) then
			npcHandler:say("Cling clang!", cid)
			player:addItem(5892, 1)
			npcHandler.topic[playerId] = 0
		end
		return true
	end

	-- soul orb
	if msgcontains(msg, "soul orb") then
		if player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Me can make nasty bolt from soul orbs. Trade all?", cid)
			npcHandler.topic[playerId] = 9
			return true
		end
	end

	if isYes and npcHandler.topic[playerId] == 9 then
		local count = player:getItemCount(5944)
		if count > 0 then
			player:removeItem(5944, count)

			local total = 0
			for i = 1, count do
				if math.random(100) <= 1 then
					total = total + 200
				else
					total = total + 100
				end
			end

			player:addItem(6528, total)
			npcHandler:say("Cling clang!", cid)
		end
		npcHandler.topic[playerId] = 0
		return true
	end

	-- melt gold ingot
	if msgcontains(msg, "melt") then
		npcHandler:say("Can melt gold ingot for li'l one. You want?", cid)
		npcHandler.topic[playerId] = 10
		return true
	end

	if isYes and npcHandler.topic[playerId] == 10 then
		if player:removeItem(9058, 1) then
			player:addItem(12804, 1)
			npcHandler:say("Whoooosh There!", cid)
			npcHandler.topic[playerId] = 0
		end
		npcHandler.topic[playerId] = 0
		return true
	end

	-- gear whell
	if msgcontains(msg, "gear whell") then
		npcHandler:say("Want to make gear wheel from iron ore?", cid)
		npcHandler.topic[playerId] = 11
		return true
	end

	if isYes and npcHandler.topic[playerId] == 11 then
		if player:removeItem(5880, 1) then
			player:addItem(8775, 1)
			npcHandler:say("Cling clang!", cid)
		end
		npcHandler.topic[playerId] = 0
		return true
	end

	----------------------------------------------------------------------------
	-- Koshei Amulet Quest

	if msgcontains(msg, "amulet") then
		-- quest already done
		if player:kv():get("koshei-amulet-done") then
			npcHandler:say("Lil' one already has mighty amulet. Big Ben no make another!", cid)
			npcHandler.topic[playerId] = 0
			return true
		end

		-- check timer
		if player:kv():get("koshei-amulet-timer") then
			local finishTime = player:kv():get("koshei-amulet-timer")

			-- amulet still not done
			if finishTime > os.time() then
				local remaining = finishTime - os.time()

				-- time conversion
				local hours = math.floor(remaining / 3600)
				local minutes = math.floor((remaining % 3600) / 60)
				local timeStr = ""

				if hours > 0 then
					timeStr = hours .. " hour" .. (hours > 1 and "s" or "")
				end
				if minutes > 0 then
					if timeStr ~= "" then
						timeStr = timeStr .. " and "
					end
					timeStr = timeStr .. minutes .. " minute" .. (minutes > 1 and "s" or "")
				end
				if timeStr == "" then
					timeStr = "less than a minute"
				end

				npcHandler:say("Big Ben still hammering! Come back in " .. timeStr .. "!", cid)
				return true
			end

			-- amulet done
			if finishTime <= os.time() then
				player:addItem(7532, 1)
				npcHandler:say("Ahh, li'l one wants amulet. Here! Have it! Mighty, mighty amulet li'l one has. Don't know what but mighty, mighty it is!!!", cid)
				player:kv():set("koshei-amulet-done", true)
				npcHandler.topic[playerId] = 0
				return true
			end
		end

		-- step 1
		npcHandler:say("Me can do unbroken but Big Ben want gold 5000 and all four pieces. Yes?", cid)
		npcHandler.topic[playerId] = 12
		return true
	end

	-- yes confirmations
	if isYes and npcHandler.topic[playerId] == 12 then
		-- quest already done
		if player:kv():get("koshei-amulet-done") then
			npcHandler:say("Lil' one already did this! Big Ben no make again!", cid)
			npcHandler.topic[playerId] = 0
			return true
		end
		-- if not done yet
		if player:kv():get("koshei-amulet-timer") then
			npcHandler:say("Big Ben already working! Come back later!", cid)
			npcHandler.topic[playerId] = 0
			return true
		end
		-- remove gold and check itens
		if player:removeMoneyBank(5000) then
			if player:getItemCount(7528) > 0 and player:getItemCount(7529) > 0 and player:getItemCount(7530) > 0 and player:getItemCount(7531) > 0 then
				player:removeItem(7528, 1)
				player:removeItem(7529, 1)
				player:removeItem(7530, 1)
				player:removeItem(7531, 1)
				-- timer 24h
				player:kv():set("koshei-amulet-timer", os.time() + 24 * 60 * 60)
				npcHandler:say("Well, well. I do that! Big Ben makes li'l amulet unbroken with big hammer in big hands! No worry! Come back after sun hits the horizon 24 times and ask me for amulet.", cid)
			else
				npcHandler:say("Lil' one not have all pieces.", cid)
			end
		else
			npcHandler:say("Lil' one has not enough money.", cid)
		end
		npcHandler.topic[playerId] = 0
		return true
	end
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am smith." })
keywordHandler:addKeyword({ "smith" }, StdModule.say, { npcHandler = npcHandler, text = "Working steel is my profession." })
keywordHandler:addKeyword({ "steel" }, StdModule.say, { npcHandler = npcHandler, text = "Manny kinds of. Like {Mesh Kaha Rogh'}, {Za'Kalortith}, {Uth'Byth}, {Uth'Morc}, {Uth'Amon}, {Uth'Maer}, {Uth'Doon}, and {Zatragil}." })
keywordHandler:addKeyword({ "zatragil" }, StdModule.say, { npcHandler = npcHandler, text = "Most ancients use dream silver for different stuff. Now ancients most gone. Most not know about." })
keywordHandler:addKeyword({ "uth'doon" }, StdModule.say, { npcHandler = npcHandler, text = "It's high steel called. Only lil' lil' ones know how make." })
keywordHandler:addKeyword({ "za'kalortith" }, StdModule.say, { npcHandler = npcHandler, text = "It's evil. Demon iron is. No good cyclops goes where you can find and need evil flame to melt." })
keywordHandler:addKeyword({ "mesh kaha rogh" }, StdModule.say, { npcHandler = npcHandler, text = "Steel that is singing when forged. No one knows where find today." })
keywordHandler:addKeyword({ "uth'byth" }, StdModule.say, { npcHandler = npcHandler, text = "Not good to make stuff off. Bad steel it is. But eating magic, so useful is." })
keywordHandler:addKeyword({ "uth'maer" }, StdModule.say, { npcHandler = npcHandler, text = "Brightsteel is. Much art made with it. Sorcerers too lazy and afraid to enchant much." })
keywordHandler:addKeyword({ "uth'amon" }, StdModule.say, { npcHandler = npcHandler, text = "Heartiron from heart of big old mountain, found very deep. Lil' lil ones fiercely defend. Not wanting to have it used for stuff but holy stuff." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "Me parents live here before town was. Me not care about lil' ones." })
keywordHandler:addKeyword({ "lil' lil'" }, StdModule.say, { npcHandler = npcHandler, text = "Lil' lil' ones are so fun. We often chat." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "One day I'll go and look." })
keywordHandler:addKeyword({ "teshial" }, StdModule.say, { npcHandler = npcHandler, text = "Is one of elven family or such thing. Me not understand lil' ones and their business." })
keywordHandler:addKeyword({ "cenath" }, StdModule.say, { npcHandler = npcHandler, text = "Is one of elven family or such thing. Me not understand lil' ones and their business." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I called Bencthyclthrtrprr by me people. Lil' ones me call Big Ben." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "You shut up. Me not want to hear." })
keywordHandler:addKeyword({ "fire sword" }, StdModule.say, { npcHandler = npcHandler, text = "Do lil' one want to trade a fire sword?" })
keywordHandler:addKeyword({ "dragon shield" }, StdModule.say, { npcHandler = npcHandler, text = "Do lil' one want to trade a dragon shield?" })
keywordHandler:addKeyword({ "sword of valor" }, StdModule.say, { npcHandler = npcHandler, text = "Do lil' one want to trade a sword of valor?" })
keywordHandler:addKeyword({ "warlord sword" }, StdModule.say, { npcHandler = npcHandler, text = "Do lil' one want to trade a warlord sword?" })
keywordHandler:addKeyword({ "minotaurs" }, StdModule.say, { npcHandler = npcHandler, text = "They were friend with me parents. Long before elves here, they often made visit. No longer come here." })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "Me not fight them, they not fight me." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "Me wish I could make weapon like it." })
keywordHandler:addKeyword({ "cyclops" }, StdModule.say, { npcHandler = npcHandler, text = "Me people not live here much. Most are far away." })

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Hum Humm! Welcume lil' |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye lil' one.")

npcHandler:addModule(FocusModule:new())
