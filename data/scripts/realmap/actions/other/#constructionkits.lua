-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local constructionKits = {
	[3901] = 1666, [3902] = 1670, [3903] = 1652, [3904] = 1674, [3905] = 1658,
	[3906] = 3813, [3907] = 3817, [3908] = 1619, [3909] = 12799, [3910] = 2105,
	[3911] = 1614, [3912] = 3806, [3913] = 3807, [3914] = 3809, [3915] = 1716,
	[3916] = 1724, [3917] = 1732, [3918] = 1775, [3919] = 1774, [3920] = 1750,
	[3921] = 3832, [3922] = 2095, [3923] = 2098, [3924] = 2064, [3925] = 2582,
	[3926] = 2117, [3927] = 1728, [3928] = 1442, [3929] = 1446, [3930] = 1447,
	[3931] = 2034, [3932] = 2604, [3933] = 2080, [3934] = 2084, [3935] = 3821,
	[3936] = 3811, [3937] = 2101, [3938] = 3812, [5086] = 5046, [5087] = 5055,
	[5088] = 5056, [6114] = 6111, [6115] = 6109, [6372] = 6356, [6373] = 6371,
	[8692] = 8688, [9974] = 9975, [11126] = 11127, [11133] = 11129, [11124] = 11125,
	[11205] = 11203, [14328] = 1616, [14329] = 1615, [16075] = 16020, [16099] = 16098,
	[20254] = 20295, [20255] = 20297, [20257] = 20299
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local kit = constructionKits[item.itemid]
	if not kit then
		return false
	end

	if fromPosition.x == CONTAINER_POSITION then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Put the construction kit on the floor first.")
	elseif not fromPosition:getTile():getHouse() then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You may construct this only inside a house.")
	else
		item:transform(kit)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:addAchievementProgress('Interior Decorator', 1000)
	end

	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(3901, 3902, 3903, 3904, 3905, 3906, 3907, 3908, 3909, 3910, 3911, 3912, 3913, 3914, 3915, 3916, 3917, 3918, 3919, 3920, 3921, 3922, 3923, 3924, 3925, 3926, 3927, 3928, 3929, 3930, 3931, 3932, 3933, 3934, 3935, 3936, 3937, 3938, 5086, 5087, 5088, 6114, 6115, 6373, 8692, 9974, 11124, 11126, 11133, 11205, 14328, 14329, 16075, 16099, 20254, 20255, 20257)
realmapEvent1:register()
