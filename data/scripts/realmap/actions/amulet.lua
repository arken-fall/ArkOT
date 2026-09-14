local fa_exhaust = {}
local fa_exhaust_time = 60 -- em segundos
local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
 if isHotkey or fromPosition.x == CONTAINER_POSITION and fromPosition.y == 2 then
  local name = player:getName()
  if not fa_exhaust[name] or fa_exhaust[name] <= os.time() then
   if math.random(2) == 1 then
    player:addHealth(1000)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "1000 HP has been restored.")
   else 
    player:addMana(1000)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "1000 MP has been restored.")
   end
   fa_exhaust[name] = os.time() + fa_exhaust_time
  end
 end
 return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(25423)
realmapEvent1:register()
