local gumballMachine = {}

gumballMachine.tileWidth = 1
gumballMachine.tileHeight = 1
gumballMachine.class = "gumball_machine"
gumballMachine.category = {
	"food"
}
gumballMachine.objectType = "food"
gumballMachine.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.KITCHEN] = true
}
gumballMachine.display = _T("GUMBALL_MACHINE", "Gumball machine")
gumballMachine.description = _T("GUMBALL_MACHINE_DESCRIPTION", "Who doesn't love a jaw-breaker gum ball every once in a while?")
gumballMachine.quad = quadLoader:load("gumball_machine")
gumballMachine.scaleX = 1
gumballMachine.scaleY = 1
gumballMachine.cost = 200
gumballMachine.minimumIllumination = 0.2
gumballMachine.sizeCategory = "unhousable"
gumballMachine.requiresEntrance = true
gumballMachine.inheritsRotation = true
gumballMachine.preventsMovement = true
gumballMachine.affectors = {
	{
		"food",
		5
	},
	{
		"comfort",
		1
	}
}
gumballMachine.xDirectionalOffset = 4
gumballMachine.yDirectionalOffset = -4
gumballMachine.icon = "icon_gumball_machine"
gumballMachine.realMonthlyCosts = {
	{
		cost = 5,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "food"
	}
}
gumballMachine.monthlyCosts = monthlyCost.new()
gumballMachine.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.TOILET] = true
}
gumballMachine.matchingRequirements = {}

function gumballMachine:onBeingFaced(employee)
	gumballMachine.baseClass.onBeingFaced(self, employee)
	
	local avatar = employee:getAvatar()
	
	avatar:addAnimToQueue(employee:getAnimationList().eat, 0.75)
	employee:changeSatiety(10)
end

objects.registerNew(gumballMachine, "complex_monthly_cost_object_base")
