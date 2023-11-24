local paperHolder = {}

paperHolder.tileWidth = 1
paperHolder.tileHeight = 1
paperHolder.class = "toilet_paper"
paperHolder.category = "sanitary"
paperHolder.objectType = "toilet_paper"
paperHolder.roomType = nil
paperHolder.display = _T("PAPER_HOLDER", "Paper holder")
paperHolder.description = _T("PAPER_HOLDER_DESCRIPTION", "Three-ply anti chocolate finger insurance!\nMandatory part of a restroom.")
paperHolder.quad = quadLoader:load("toilet_paper_holder")
paperHolder.scaleX = 2
paperHolder.scaleY = 2
paperHolder.cost = 20
paperHolder.requiresEntrance = false
paperHolder.requiresWallInFront = true
paperHolder.xOffset = 0
paperHolder.yOffset = 0
paperHolder.xDirectionalOffset = 14
paperHolder.yDirectionalOffset = -14
paperHolder.addRotation = -90
paperHolder.icon = "icon_toilet_paper_holder"
paperHolder.realMonthlyCosts = {
	{
		cost = 6,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "miscellaneous"
	}
}
paperHolder.monthlyCosts = monthlyCost.new()

objects.registerNew(paperHolder, "complex_monthly_cost_object_base")
