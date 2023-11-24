local employeeRoleCount = {}

employeeRoleCount.skinTextFillColor = color(200, 200, 200, 255)
employeeRoleCount.skinTextHoverColor = color(255, 255, 255, 255)
employeeRoleCount.baseColorInactiveMainSkill = color(155, 165, 124, 255)
employeeRoleCount.baseColorInactive = color(103, 122, 91, 255)
employeeRoleCount.baseColor = color(126, 150, 112, 255)
employeeRoleCount.underIconColor = color(58, 68, 51, 255)
employeeRoleCount.progressBarColor = color(190, 226, 145, 255)
employeeRoleCount.progressBarHeight = 8
employeeRoleCount.font = "pix24"

function employeeRoleCount:init()
	self:updateFont()
end

function employeeRoleCount:handleEvent(event)
end

function employeeRoleCount:updateFont()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
end

function employeeRoleCount:setScalingState(hor, vert)
	employeeRoleCount.baseClass.setScalingState(self, true, true)
end

function employeeRoleCount:setRoleData(data)
	self.roleData = data
	
	self:updateText()
end

function employeeRoleCount:updateText()
	self.peopleCountText = studio:getEmployeeCountByRole(self.roleData.id)
end

function employeeRoleCount:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:setWidth(500)
	self.descBox:addText(self.roleData.display, "pix22")
	
	local offerCount = employeeCirculation:countOfferedWorkByRole(self.roleData.id)
	
	self.descBox:addText(string.easyformatbykeys(_T("HIRED_EMPLOYEE_COUNTER", "Hired in office: COUNT"), "ROLE", self.roleData.display, "COUNT", self.peopleCountText), "pix20", nil, offerCount > 0 and 10 or 0)
	
	if offerCount then
		self.descBox:addText(string.easyformatbykeys(_T("PENDING_JOB_OFFERS", "Pending job offers: COUNT"), "ROLE", self.roleData.display, "COUNT", offerCount), "pix20", game.UI_COLORS.IMPORTANT_1, 0)
	end
	
	self.descBox:centerToElement(self)
end

function employeeRoleCount:onClick(x, y, key)
	if self.employee:isHired() and self.employee:isAvailable() and self.employee:getSkillLevel(self.skillData.id) < skills:getMaxLevel(self.skillData.id) then
		self:killDescBox()
		
		local task = self.employee:getTask()
		
		if not task or task and task:canCancel() then
			local comboBox = gui.create("ComboBox")
			
			comboBox:setDepth(150)
			comboBox:setAutoCloseTime(0.5)
			comboBox:setPos(x - 20, y - 10)
			
			comboBox.baseButton = self
			
			local option
			
			option = comboBox:addOption(0, 0, 0, 24, _T("PRACTICE_SKILL", "Practice skill"), fonts.get("pix20"), employeeRoleCount.practiceSkillOption)
			option.assignee = self.employee
			option.skillID = self.skillData.id
			
			interactionController:setInteractionObject(self, x - 20, y - 10, true)
		end
	end
end

function employeeRoleCount:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function employeeRoleCount:getIconSize()
	return self.rawH - 4
end

function employeeRoleCount:getIcon()
	return self.roleData.roleIcon
end

function employeeRoleCount:getBaseNonHoverColor()
	return employeeRoleCount.baseColorInactive
end

function employeeRoleCount:updateSprites()
	local underColor = self:isMouseOver() and employeeRoleCount.baseColor or self:getBaseNonHoverColor()
	
	self:setNextSpriteColor(underColor:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local iconSize = self:getIconSize()
	local scaledTwo = _S(2)
	local scaledFour = _S(4)
	
	self:setNextSpriteColor(employeeRoleCount.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	self.iconSprite = self:allocateSprite(self.iconSprite, self:getIcon(), scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
end

function employeeRoleCount:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.peopleCountText, _S(self:getIconSize() + 8), (h - self.fontObject:getHeight()) * 0.5, tcol.r, tcol.g, tcol.b, tcol.a)
end

gui.register("EmployeeRoleCount", employeeRoleCount)
