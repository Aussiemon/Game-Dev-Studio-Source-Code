local info = {}

info.elementSpacing = 5

function info:init()
	self:bringUp()
end

function info:getAttributeDisplay()
	return self.attributeDisplay
end

function info:getSkillDisplay()
	return self.skillDisplay
end

function info:setNoOffset(state)
	self.skillDisplay:setNoOffset(state)
end

function info:setupInfo(employee)
	self:setWidth(200)
	
	local h = 0
	
	for key, attributeData in ipairs(attributes.registered) do
		self.attributeDisplay = gui.create("AttributeDisplay", self)
		
		self.attributeDisplay:setSize(self.w, 20)
		self.attributeDisplay:setPos(0, h)
		self.attributeDisplay:setAttribute(attributeData.id)
		self.attributeDisplay:setEmployee(employee)
		self.attributeDisplay:setWidth(200)
		
		h = h + self.attributeDisplay.h
	end
	
	self.skillDisplay = gui.create("SkillDisplay", self)
	
	self.skillDisplay:setEmployee(employee)
	self.skillDisplay:setWidth(200)
	self.skillDisplay:setPos(0, h + self.elementSpacing)
end

gui.register("EmployeeInfo", info)
