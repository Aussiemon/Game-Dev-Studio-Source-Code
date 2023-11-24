local sink = {}

sink.tileWidth = 1
sink.tileHeight = 1
sink.class = "kitchen_sink"
sink.objectType = "kitchen_sink"
sink.category = "food"
sink.roomType = studio.ROOM_TYPES.KITCHEN
sink.display = _T("KITCHEN_SINK", "Kitchen sink")
sink.description = _T("KITCHEN_SINK_DESCRIPTION", "Those dishes ain't gonna clean themselves!")
sink.matchType = "counter"
sink.quad = quadLoader:load("kitchen_sink")
sink.quadSurround = quadLoader:load("kitchen_sink_surround")
sink.quadLeft = quadLoader:load("kitchen_sink_left")
sink.quadRight = quadLoader:load("kitchen_sink_right")
sink.scaleX = 1
sink.scaleY = 1
sink.cost = 100
sink.preventsMovement = true
sink.icon = "icon_kitchen_sink"
sink.xDirectionalOffset = 8
sink.yDirectionalOffset = -8
sink.leftOffset = 3
sink.rightOffset = 4
sink.realMonthlyCosts = {
	{
		cost = 2,
		multiplyByEmployeeCount = true,
		type = "water"
	}
}
sink.monthlyCosts = monthlyCost.new()
sink.affectors = {
	{
		"water",
		2
	}
}

local joinableObjectBase = objects.getClassData("joinable_object_base")

sink.getTextureQuad = joinableObjectBase.getTextureQuad
sink.getValidQuad = joinableObjectBase.getValidQuad
sink.updateValidQuad = joinableObjectBase.updateValidQuad
sink.hasMatchInDirection = joinableObjectBase.hasMatchInDirection
sink.getDrawPosition = joinableObjectBase.getDrawPosition

objects.registerNew(sink, "complex_monthly_cost_object_base")
