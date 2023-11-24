local roleGradIconPanel = {}

function roleGradIconPanel:setRoleData(data)
	self.roleData = data
end

function roleGradIconPanel:setupDescbox(wrapWidth)
	self.roleData:addRoleEmploymentInfo(self.descBox, wrapWidth, studio:getEmployeeCountByRole(self.roleData.id))
end

gui.register("RoleGradientIconPanel", roleGradIconPanel, "GradientIconPanel")
