local staircase = {}

staircase.class = "staircase"
staircase.tileWidth = 1
staircase.tileHeight = 3
staircase.category = "general"
staircase.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.KITCHEN] = true
}
staircase.display = _T("OBJECT_STAIRCASE", "Staircase")
staircase.description = _T("OBJECT_STAIRCASE_DESCRIPTION", "Staircases connect floors, allowing employees to move between them.\nYou weren't hoping they'd climb on their own, were you?")
staircase.icon = "icon_staircase"
staircase.quad = quadLoader:load("object_staircase_up")
staircase.spriteUp = quadLoader:load("object_staircase_up")
staircase.spriteDown = quadLoader:load("object_staircase_down")
staircase.scaleX = 1
staircase.scaleY = 1
staircase.cost = 400
staircase.minimumIllumination = 0
staircase.preventsMovement = true

function staircase:getDisplayText()
	if self:isTransitionUp() then
		return _T("OBJECT_STAIRCASE_UP", "Staircase up")
	end
	
	return _T("OBJECT_STAIRCASE_DOWN", "Staircase down")
end

objects.registerNew(staircase, "floor_transition_object_base")
