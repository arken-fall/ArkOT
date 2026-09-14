local function onUse(player, item, itemEx)
    if player:getStorageValue(941119) < 1 then
        local newItem = Game.createItem(2088, 1)
        newItem:setActionId(5010)
        player:addItemEx(newItem)
        player:setStorageValue(941119, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You picked up a silver key.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already took the key.")
    end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(50258)
realmapEvent1:register()
