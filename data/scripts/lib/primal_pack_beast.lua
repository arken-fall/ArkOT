-- The Primal Ordeal's pack beasts are weaker, loot-less twins of ordinary
-- creatures, registered from the very table the creature registered itself
-- with, so a creature file ends with RegisterPrimalPackBeast(monster).

local function copy(value)
	if type(value) ~= "table" then
		return value
	end

	local copied = {}
	for key, item in pairs(value) do
		copied[key] = copy(item)
	end
	return copied
end

function RegisterPrimalPackBeast(template)
	local name = template.name or template.description:gsub("an ", ""):gsub("a ", ""):titleCase()
	local primal = Game.createMonsterType(name .. " (Primal)")
	local beast = copy(template)

	beast.name = "Primal Pack Beast"
	beast.description = "a primal pack beast"
	beast.experience = 0
	beast.loot = {}
	beast.maxHealth = math.floor(beast.maxHealth * 0.7)
	beast.health = beast.maxHealth
	beast.raceId = nil
	beast.bestiary = nil
	beast.corpse = 0

	primal:register(beast)
end
