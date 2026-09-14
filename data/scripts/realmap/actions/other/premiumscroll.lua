local function doPlayerAddPremiumPoints(cid, count)
    db.query('UPDATE znote_accounts SET points = points+'.. count ..' WHERE account_id = ' .. getAccountNumberByPlayerName(getCreatureName(cid)) .. ' LIMIT 1')
end

local function onUse(cid, item, fromPosition, itemEx, toPosition) 
    doPlayerAddPremiumPoints(cid, 100)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have recived 100 Shop Credits to your balance.")
    doSendMagicEffect(getCreaturePosition(cid), 28)
    doRemoveItem(item.uid,1)
    return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(16101)
realmapEvent1:register()
