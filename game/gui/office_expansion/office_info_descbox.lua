local infoDesc = {}
local exp = studio.expansion.EVENTS

infoDesc.backgroundColor = color(0, 0, 0, 150)
infoDesc.CATCHABLE_EVENTS = {
	exp.POST_REMOVED_OBJECT,
	exp.LEAVE_EXPANSION_MODE,
	studio.EVENTS.ROOMS_UPDATED,
	officeBuilding.EVENTS.MOUSE_OVER,
	camera.EVENTS.FLOOR_VIEW_CHANGED
}
infoDesc.updateDisplayEvents = {
	[exp.POST_REMOVED_OBJECT] = true,
	[camera.EVENTS.FLOOR_VIEW_CHANGED] = true
}

function infoDesc:init()
	self.invalidDescbox = gui.create("GenericDescbox")
	
	self.invalidDescbox:tieVisibilityTo(infoDesc)
	self.invalidDescbox:addDepth(1000)
end

function infoDesc:handleEvent(event, object)
	if event == exp.LEAVE_EXPANSION_MODE then
		self:kill()
	elseif event == officeBuilding.EVENTS.MOUSE_OVER and object:isPlayerOwned() then
		self:setOffice(object)
		self:updateDisplay()
	elseif event == studio.EVENTS.ROOMS_UPDATED then
		if not self.office then
			self:setOffice(object)
		else
			self:updateDisplay()
		end
	elseif infoDesc.updateDisplayEvents[event] then
		self:updateDisplay()
	elseif self.office == object then
		self:updateDisplay()
	end
end

function infoDesc:updateDisplay()
	if not self.office then
		return 
	end
	
	self:removeAllText()
	self.invalidDescbox:removeAllText()
	
	local workplaces = self.office:getWorkplaces()
	local usable, active = 0, 0
	
	for key, obj in ipairs(workplaces) do
		if obj:isValidForWork() then
			if obj:getAssignedEmployee() then
				active = active + 1
			else
				usable = usable + 1
			end
		end
	end
	
	self.totalWorkplaces = #workplaces
	self.freeWorkplaces = usable
	self.usedWorkplaces = active
	
	local wrapW = 300
	
	self:addText(self.office:getName(), "bh24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 8, wrapW)
	self:addText(_format(_T("OFFICE_WORKPLACE_COUNT", "Workplaces: EMPLOYEES"), "EMPLOYEES", self.totalWorkplaces), "pix20", nil, 3, wrapW, "exclamation_point", 22, 22)
	self:addText(_format(_T("OFFICE_EMPLOYEE_COUNT", "Employees: EMPLOYEES"), "EMPLOYEES", self.usedWorkplaces), "pix20", nil, 3, wrapW, "decrease", 22, 22)
	self:addText(_format(_T("OFFICE_FREE_WORKPLACES_COUNT", "Free workplaces: EMPLOYEES"), "EMPLOYEES", self.freeWorkplaces), "pix20", nil, 3, wrapW, "increase", 22, 22)
	self:addText(self.office:getFloorsText(), "bh20", nil, 0, wrapW, "icon_floors", 22, 22)
	self.office:fillFloorReachText(self.invalidDescbox, wrapW)
	self.invalidDescbox:setPos(self.x, self.y + self.h + _S(10))
	
	if #self.invalidDescbox:getTextEntries() == 0 then
		self.invalidDescbox:hide()
	else
		self.invalidDescbox:show()
	end
end

function infoDesc:setOffice(office)
	self.office = office
end

gui.register("OfficeInfoDescbox", infoDesc, "GenericDescbox")
