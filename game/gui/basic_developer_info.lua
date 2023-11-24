local devInfo = {}

devInfo.formatTable = {}
devInfo._scaleVert = false

function devInfo:init()
	devInfo.font = fonts.get("pix28")
	
	events:addReceiver(self)
end

function devInfo:onKill()
	events:removeReceiver(self)
end

function devInfo:handleEvent(event, employee)
	if event == developer.EVENTS.ATTRIBUTE_POINT_DRAINED and employee == self.employee then
		self:updateText()
	end
end

function devInfo:setEmployee(emp)
	self.employee = emp
	
	self:updateText()
end

function devInfo:updateText()
	local baseText = _T("EMPLOYEE_INFO_LAYOUT", "Level LEVEL\nROLE\nSalary $SALARY\nAttribute points: ATTRIBUTE_POINTS")
	
	devInfo.formatTable.LEVEL = self.employee:getLevel()
	devInfo.formatTable.ROLE = attributes.profiler:getRoleName(self.employee:getRole())
	devInfo.formatTable.SALARY = self.employee:getSalary()
	devInfo.formatTable.ATTRIBUTE_POINTS = self.employee:getAttributePoints()
	self.baseText = string.formatbykeys(baseText, devInfo.formatTable)
	
	self:scaleToText()
end

function devInfo:scaleToText()
	local width, text = self.font:getWrap(self.baseText, self.w)
	
	self:setHeight(#text * self.font:getHeight() + 5)
end

function devInfo:draw(w, h)
	love.graphics.setColor(70, 70, 70, 255)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setFont(self.font)
	love.graphics.printST(self.baseText, 5, 2, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("BasicDeveloperInfo", devInfo)
