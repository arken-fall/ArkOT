local entrance = ItemEvent()

function entrance.onStepOn(creature, item, toPosition, fromPosition)
	return Entrance_onStepIn(creature, item, toPosition, fromPosition)
end

entrance:type("stepon")
entrance:aid(47710)
entrance:register()
