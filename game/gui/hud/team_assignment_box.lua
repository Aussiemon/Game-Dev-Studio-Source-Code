local teamAssignment = {}

teamAssignment.handleEvent = false
teamAssignment.SCROLLBAR_CLASS = "ScrollbarPanel"

function teamAssignment:createAssignmentElement(teamObj)
	local element = gui.create("TeamMembersAssignmentSelection")
	
	element:setTeam(teamObj)
	element:setHeight(56)
	
	return element
end

function teamAssignment:fillWithElements()
	for key, teamObj in ipairs(studio:getTeams()) do
		self.scrollBar:addItem(self:createAssignmentElement(teamObj))
	end
end

gui.register("TeamAssignmentBox", teamAssignment, "AssignmentBox")
