local assignmentBox = {}

assignmentBox.TIME_TO_FADE_AFTER_EVENT = 6
assignmentBox.MAX_ALPHA = 1
assignmentBox.MIN_ALPHA = 0.8
assignmentBox.SCROLLBAR_CLASS = "RoleScrollbarPanel"
assignmentBox.scrollbarColor = color(0, 0, 0, 0)

function assignmentBox:init()
	assignmentBox.font = fonts.get("pix20")
	self.scrollBar = gui.create(self.SCROLLBAR_CLASS, self)
	
	self.scrollBar:setAdjustElementPosition(true)
	self.scrollBar:setPadding(4, 4)
	self.scrollBar:setSpacing(4)
	self.scrollBar:setPanelOutlineColor(assignmentBox.scrollbarColor:unpack())
	
	self.alpha = 0.4
	self.fadeTime = 0
end

function assignmentBox:getScrollbarPanel()
	return self.scrollBar
end

function assignmentBox:createAssignmentElement(employee)
	local element = gui.create("EmployeeAssignmentSelection")
	
	element:setEmployee(employee)
	element:setHeight(82)
	
	return element
end

local existingPeopleList = {}

function assignmentBox:fillWithElements()
	for key, element in ipairs(self.scrollBar:getItems()) do
		existingPeopleList[element:getEmployee()] = true
	end
	
	for key, employee in ipairs(studio:getEmployees()) do
		if not employee:getWorkplace() and not existingPeopleList[employee] then
			self.scrollBar:addEmployeeItem(self:createAssignmentElement(employee))
		end
	end
	
	table.clear(existingPeopleList)
end

function assignmentBox:verifyAssignableEmployees()
	local curIndex = 1
	local itemList = self.scrollBar:getItems()
	
	for i = 1, #itemList do
		local element = itemList[curIndex]
		local employee = element:getEmployee()
		
		if employee:getWorkplace() then
			self.scrollBar:removeItem(element, true, curIndex)
			element:kill()
		else
			curIndex = curIndex + 1
		end
	end
end

assignmentBox.CATCHABLE_EVENTS = {
	employeeAssignment.EVENTS.ASSIGNED,
	employeeAssignment.EVENTS.UNASSIGNED,
	employeeAssignment.EVENTS.UNASSIGNED_EVERYONE,
	employeeAssignment.EVENTS.AUTO_ASSIGNED,
	team.EVENTS.UNASSIGNED_TEAM_FROM_WORKPLACES
}

function assignmentBox:handleEvent(event, employee)
	local assEvent = employeeAssignment.EVENTS
	
	if event == assEvent.ASSIGNED then
		for key, element in ipairs(self.scrollBar:getItems()) do
			if element:getEmployee() == employee then
				self.scrollBar:removeItem(element, true, key)
				element:kill()
				
				break
			end
		end
	elseif event == assEvent.UNASSIGNED then
		self.scrollBar:addItem(self:createAssignmentElement(employee))
	elseif event == assEvent.UNASSIGNED_EVERYONE or event == team.EVENTS.UNASSIGNED_TEAM_FROM_WORKPLACES then
		self:fillWithElements()
	elseif event == assEvent.AUTO_ASSIGNED then
		self:verifyAssignableEmployees()
	end
end

function assignmentBox:think()
	self.realMouseOver = (self.parent:isMouseOver() or self.scrollBar:isMouseOver() or self.scrollBar:isMouseOverChildren()) and not camera:getTouchPosition()
	
	if self.realMouseOver then
		self.alpha = math.approach(self.alpha, assignmentBox.MAX_ALPHA, frameTime * 5)
		
		self:setCanHover(true)
		self:queueSpriteUpdate()
		
		self.fadeTime = 0
	elseif curTime < self.fadeTime then
		self.alpha = math.approach(self.alpha, assignmentBox.MAX_ALPHA, frameTime * 5)
		
		self:setCanHover(true)
		self:queueSpriteUpdate()
	else
		self.alpha = math.approach(self.alpha, assignmentBox.MIN_ALPHA, frameTime * 5)
		
		self:setCanHover(false)
		self:queueSpriteUpdate()
	end
	
	for key, item in ipairs(self.scrollBar:getItems()) do
		item:setAlpha(self.alpha)
	end
	
	assignmentBox.scrollbarColor.a = self.alpha
	
	self.scrollBar:setPanelOutlineColor(assignmentBox.scrollbarColor:unpack())
end

function assignmentBox:setSize(w, h)
	gui.setSize(self, w, h)
	self.scrollBar:setPos(1, 1)
	self.scrollBar:setSize(w - 2, h - 2)
	self.scrollBar:performLayout()
end

function assignmentBox:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 150 * self.alpha)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	self.borderSprite = self:allocateSprite(self.borderSprite, "new_hud_generic_border", self.w, 0, 0, 3, self.rawH, 0, 0, -0.4)
end

function assignmentBox:draw(w, h)
end

gui.register("AssignmentBox", assignmentBox)
