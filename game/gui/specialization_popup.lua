local specPopup = {}

specPopup.CATCHABLE_EVENTS = {
	developer.EVENTS.DESIRED_SPECIALIZATION_SET
}

function specPopup:init()
	gui.getClassTable("Frame").init(self)
	
	self.specializationSelections = {}
	self.specializationDescBox = gui.create("GenericDescbox", self)
	
	self.specializationDescBox:setShowRectSprites(false)
end

function specPopup:setEmployee(employee)
	self.employee = employee
end

function specPopup:confirmSpecCallback()
	self.employee:setSpecialization(self.employee:getDesiredSpec())
end

function specPopup:addConfirmButton()
	self.confirmButton = self:addButton("pix20", _T("CONFIRM_SPECIALIZATION", "Confirm specialization"), specPopup.confirmSpecCallback)
	
	self.confirmButton:setCanClick(false)
	
	self.confirmButton.employee = self.employee
end

function specPopup:handleEvent(event, employee, spec)
	if employee == self.employee then
		self.confirmButton:setCanClick(true)
		self.specializationDescBox:removeAllText()
		attributes.profiler.specializationsByID[spec]:setupDescbox(self.specializationDescBox, self.rawW - 10, self.w - _S(20))
		self:performLayout()
		gui.queueElementSorting()
	end
end

function specPopup:setRoleData(roleData)
	self.roleData = roleData
	
	self:createSpecializationSelection()
end

function specPopup:createSpecializationSelection()
	for key, specData in ipairs(self.roleData.specializations) do
		local selection = gui.create("SpecializationDisplay", self)
		
		selection:setSize(self.w, 26)
		selection:setEmployee(self.employee)
		selection:setSpecializationData(specData)
		table.insert(self.specializationSelections, selection)
	end
end

function specPopup:onSizeChanged()
	for key, element in ipairs(self.specializationSelections) do
		element:setWidth(self.rawW - 10)
	end
	
	local element = self.specializationSelections[#self.specializationSelections]
	
	if element then
		self.specializationDescBox:setPos(_S(5), element.localY + element.h + _S(5))
	end
end

function specPopup:updateButtonPositions(skipResize)
	local scaledFive = _S(5)
	local baseY = self.h
	local totalHeight = 0
	
	for key, element in ipairs(self.specializationSelections) do
		element:setPos(scaledFive, baseY)
		
		local space = element:getHeight() + scaledFive
		
		baseY = baseY + space
		totalHeight = totalHeight + space
	end
	
	totalHeight = totalHeight + self.specializationDescBox:getHeight() + scaledFive
	
	self:setHeight(self:getHeight() + totalHeight + _S(5))
	specPopup.baseClass.updateButtonPositions(self, skipResize)
end

gui.register("SpecializationPopup", specPopup, "Popup")
require("game/gui/specialization_display")
require("game/gui/specialization_checkbox")
