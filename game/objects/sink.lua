local sink = {}

sink.tileWidth = 1
sink.tileHeight = 1
sink.class = "sink"
sink.category = "sanitary"
sink.objectType = "sink"
sink.roomType = nil
sink.display = _T("SINK", "Sink")
sink.description = _T("SINK_DESCRIPTION", "For hygienic purposes.\nMandatory part of a restroom.")
sink.quad = quadLoader:load("sink")
sink.scaleX = 1
sink.scaleY = 1
sink.cost = 20
sink.requiresEntrance = true
sink.requiresWallInFront = true
sink.preventsMovement = true
sink.icon = "icon_toilet_sink"
sink.yDirectionalOffset = -12
sink.xDirectionalOffset = 12
sink.realMonthlyCosts = {
	{
		cost = 6,
		divideByObjectCount = true,
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

objects.registerNew(sink, "complex_monthly_cost_object_base")
