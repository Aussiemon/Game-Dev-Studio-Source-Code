local barBench = {}

barBench.tileWidth = 2
barBench.tileHeight = 2
barBench.class = "barbell_bench"
barBench.category = "leisure"
barBench.objectType = "leisure"
barBench.display = _T("BARBELL_BENCH", "Barbell bench")
barBench.description = _T("BARBELL_BENCH_DESCRIPTION", "Bench-press in the office during work hours? You're crazy! Not!")
barBench.quad = quadLoader:load("barbell_bench")
barBench.scaleX = 1
barBench.scaleY = 1
barBench.xOffset = 0
barBench.yOffset = 0
barBench.cost = 300
barBench.interestPoints = {
	lifting = 30
}
barBench.icon = "icon_barbell_bench"
barBench.affectors = {
	{
		"comfort",
		1
	}
}
barBench.monthlyCosts = monthlyCost.new()
barBench.baseOffsetX = 24
barBench.baseOffsetY = 24
barBench.roomTypeExclusions = {
	[studio.ROOM_TYPES.TOILET] = true
}

objects.registerNew(barBench, "room_checking_object_base")
