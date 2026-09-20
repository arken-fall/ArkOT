-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local mounts = {
         
	[1] = {name = "Sparkion", ID = 94},
	
    
    }
 function onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
    player:registerEvent("VibrantEgg")
 
    local title = "Choose your mount!"
    local message = "You will receive the mount you select!"
 
    local window = ModalWindow(1001, title, message)
        if player:getItemCount(26194) >= 1 then 
                window:addButton(100, "Confirm")
                window:setDefaultEnterButton(100)
        else
                window:setDefaultEnterButton(101)
end
    window:addButton(101, "Cancel")
    window:setDefaultEscapeButton(101)
   
    for i = 1, #mounts do
                local o = mounts[i].name
                if not player:hasMount(mounts[i].ID) then
                        window:addChoice(i, o)
                end
    end
       
        if window:getChoiceCount() == 0 then
        window:setMessage("YOU HAVE ALL MOUNTS, THEN CLICK CANCEL!")
                --add achievement
    end
 
    window:sendToPlayer(player)
    return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(26194)
realmapEvent1:register()
