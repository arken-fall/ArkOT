-- Core API functions implemented in Lua
dofile('data/lib/core/core.lua')

-- Compatibility library for our old Lua API
dofile('data/lib/compat/compat.lua')

-- Debugging helper function for Lua developers
dofile('data/lib/debugging/dump.lua')

-- Area constants and spell helpers must be available before scripts/lib/combats/ loads
dofile('data/scripts/lib/spell_lib.lua')

-- Creature files register their primal twin as they load, before the scripts
-- folder walks its own lib/
dofile('data/scripts/lib/primal_pack_beast.lua')

-- Real map (SeeingBlue/TimerTim 10.98 pack) libraries: quest storages, helpers,
-- achievements, reward bosses, Lion's Rock and the modal window wrapper
dofile('data/lib/realmap/miscellaneous.lua')
dofile('data/lib/realmap/modalwindow.lua')
dofile('data/lib/realmap/lionrock.lua')
