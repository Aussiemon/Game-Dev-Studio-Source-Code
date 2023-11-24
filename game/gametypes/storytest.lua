if not DEBUG_MODE then
	return 
end

local storyTest = {}

storyTest.id = "story test"
storyTest.display = _T("STORYTEST", "Story test")
storyTest.description = _T("STORYTEST_DESC", "A template for quickly testing very specific objectives. DEV ONLY. DON'T TOUCH IF YOU DON'T KNOW WHAT THIS IS.")
storyTest.objectiveList = {}
storyTest.startTime = timeline.DAYS_IN_MONTH * 4
storyTest.orderWeight = 10000
storyTest.startMoney = 1000000
storyTest.THE_INVESTOR_STRING_NAME = _T("INVESTOR_NAME", "The Investor")
storyTest.map = "maptest"
storyTest.restrictActions = {}
storyTest.rivals = {}

function storyTest:startCallback()
	storyTest.baseClass.startCallback(self)
	studio:setReputation(50000)
end

game.registerGameType(storyTest, "story_mode")
