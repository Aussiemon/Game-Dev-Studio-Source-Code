local counter = {}

counter.tileWidth = 1
counter.tileHeight = 1
counter.class = "kitchen_counter"
counter.objectType = "decor"
counter.category = "food"
counter.display = _T("KITCHEN_COUNTER", "Counter")
counter.description = _T("KITCHEN_COUNTER_DESCRIPTION", "Kitchen-specific table. Can house small objects, like microwaves and coffee machines.")
counter.quad = quadLoader:load("kitchen_counter")
counter.quadSurround = quadLoader:load("kitchen_counter_surround")
counter.quadLeft = quadLoader:load("kitchen_counter_left")
counter.quadRight = quadLoader:load("kitchen_counter_right")
counter.matchType = "counter"
counter.scaleX = 1
counter.scaleY = 1
counter.minimumIllumination = 0
counter.canHouse = {
	small_desk_object = true
}
counter.cost = 50
counter.preventsMovement = true
counter.icon = "icon_kitchen_counter"
counter.xDirectionalOffset = 6
counter.yDirectionalOffset = -6
counter.leftOffset = 3
counter.rightOffset = 4

function counter:shouldIgnoreRoomChecking(checkedBy)
	return true
end

objects.registerNew(counter, "joinable_object_base")
