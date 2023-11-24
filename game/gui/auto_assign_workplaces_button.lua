local autoAssign = {}

function autoAssign:init()
	events:addReceiver(self)
end

function autoAssign:handleEvent(event, employeeList, assignedAmount)
	if event == employeeAssignment.EVENTS.AUTO_ASSIGNED then
	end
end

function autoAssign:onKill()
	events:removeReceiver(self)
end

function autoAssign:onClick(x, y, key)
	employeeAssignment:assignEmployeesToFreeWorkplaces()
end

gui.register("AutoAssignWorkplacesButton", autoAssign, "Button")
