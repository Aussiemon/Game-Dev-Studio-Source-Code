local employeeAssignmentFrame = {}

function employeeAssignmentFrame:preventsMouseOver()
	return false
end

function employeeAssignmentFrame:onKill()
	employeeAssignment:leave()
end

gui.register("EmployeeAssignmentFrame", employeeAssignmentFrame, "InvisibleFrame")
