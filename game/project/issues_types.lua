local p0 = {}

p0.id = "p0"
p0.display = _T("P0_ISSUES", "P0 issues")
p0.displayLowercase = _T("P0_ISSUE", "P0 issue")
p0.icon = "issue_p0"
p0.description = _T("P0_ISSUE_DESCRIPTION", "P0 issues are critical bugs. They must be fixed before the game is released, as they impact the review score the most.\nMost common types are:\n\tCrashes\n\tGameplay blockers")
p0.discoverChance = 40
p0.generateChance = 12
p0.salesImpact = 0.05
p0.salesImpactExponent = 2
p0.opinionLoss = 0.5
p0.opinionRegain = 0.37
p0.priority = 3
p0.scoreImpact = 0.1
p0.scoreImpactExponent = 2
p0.fixTime = {
	max = 2,
	min = 1
}

issues:registerNew(p0)

local p1 = {}

p1.id = "p1"
p1.display = _T("P1_ISSUES", "P1 issues")
p1.displayLowercase = _T("P1_ISSUE", "P1 issue")
p1.icon = "issue_p1"
p1.description = _T("P1_ISSUE_DESCRIPTION", "P1 issues are major bugs. Ideally they should be fixed before releasing the game, as they provide an unpleasant gameplay experience.\nMost common types are:\n\tPerformance drops\n\tGameplay issues\n\tAI issues\n\tUsability issues")
p1.discoverChance = 35
p1.generateChance = 10
p1.priority = 2
p1.salesImpact = 0.02
p1.salesImpactExponent = 1.5
p1.opinionLoss = 0.3
p1.opinionRegain = 0.2
p1.scoreImpact = 0.05
p1.scoreImpactExponent = 1.5
p1.fixTime = {
	max = 1,
	min = 0.5
}

issues:registerNew(p1)

local p2 = {}

p2.id = "p2"
p2.display = _T("P2_ISSUES", "P2 issues")
p2.displayLowercase = _T("P1_ISSUE", "P1 issue")
p2.icon = "issue_p2"
p2.description = _T("P2_ISSUE_DESCRIPTION", "P2 issues are minor bugs. These issues do not affect game score by much, but should still be taken care of as they often make up for the majority of issues.\nMost common types are:\n\tVisual issues\n\tAudio issues\n\tMinor bugs")
p2.discoverChance = 30
p2.generateChance = 15
p2.priority = 1
p2.salesImpact = 0.0025
p2.salesImpactExponent = 1.1
p2.opinionLoss = 0.1
p2.opinionRegain = 0.06
p2.scoreImpact = 0.01
p2.scoreImpactExponent = 1.1
p2.fixTime = {
	max = 0.5,
	min = 0.1
}

issues:registerNew(p2)
