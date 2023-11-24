local managerAssign = {}

managerAssign.skinPanelSelectColor = color(125, 175, 125, 255)
managerAssign.skinPanelDisableColor = color(20, 20, 20, 255)
managerAssign.skinTextFillColor = color(220, 220, 220, 255)
managerAssign.skinTextHoverColor = color(240, 240, 240, 255)
managerAssign.skinTextSelectColor = color(255, 255, 255, 255)
managerAssign.skinTextDisableColor = color(60, 60, 60, 255)
managerAssign.CATCHABLE_EVENTS = {
	interview.EVENTS.MANAGER_SET
}

function managerAssign:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:setPos(0, _S(3))
	self.descriptionBox:overwriteDepth(5)
end

function managerAssign:handleEvent(event)
	self:queueSpriteUpdate()
end

function managerAssign:isOn()
	return self.manager == self.interviewObj:getAssignedManager()
end

function managerAssign:setInterview(interviewObj)
	self.interviewObj = interviewObj
	
	local wrapWidth = self.rawW - 10
	
	self.descriptionBox:addSpaceToNextText(2)
	self.descriptionBox:addTextLine(self.w - _S(40), game.UI_COLORS.LIGHT_BLUE, _S(24), "weak_gradient_horizontal")
	self.descriptionBox:addText(self.manager:getFullName(true), "pix22", nil, 4, wrapWidth, "hud_employee", 19, 24)
	self.descriptionBox:addTextLine(self.w - _S(40), gui.genericOutlineColor, _S(24), "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("INVOLVEMENT_DAYS", "Involvement: TIME"), "TIME", timeline:getTimePeriodText(self.manager:getProjectInvolvement(self.interviewObj:getTargetProject()))), "bh20", nil, 4, wrapWidth, "clock_full", 24, 24)
	
	local roleData = self.manager:getRoleData()
	local attributeData = attributes.registeredByID[roleData.mainAttribute]
	local skillData = skills.registeredByID[roleData.mainSkill]
	
	self.descriptionBox:addTextLine(self.w - _S(40), gui.genericOutlineColor, _S(24), "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("INTERVIEW_ESTIMATED_EFFICIENCY", "Estimated score: SCORE pts."), "SCORE", math.floor(roleData:getInterviewEfficiency(self.interviewObj, self.manager))), "bh20", nil, 0, wrapWidth, "star", 24, 24)
	self:setHeight(_US(self.descriptionBox.rawH) + 3)
end

function managerAssign:setManager(emp)
	self.manager = emp
	self.managerName = emp:getFullName(true)
end

function managerAssign:onClick(x, y, key)
	self.interviewObj:setManager(self.manager)
	self:queueSpriteUpdate()
end

function managerAssign:getInterviewEfficiency()
	local roleData = attributes.profiler:getRoleData(self.manager:getRole())
	
	return roleData:getInterviewEfficiency(self.interviewObj)
end

gui.register("ManagerAssignmentButton", managerAssign, "GenericElement")
