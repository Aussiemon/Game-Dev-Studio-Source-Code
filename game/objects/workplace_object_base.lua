local workplace = {}

workplace.class = "workplace_object_base"
workplace.onFaceAnimPlaybackSpeed = 0.65
workplace.onFaceAnimType = tdas.ANIMATION_TYPES.LOOP
workplace.WORKPLACE = true
workplace.animateOnFacing = false
workplace.BASE = true

function workplace:init()
	workplace.baseClass.init(self)
end

function workplace:getInteractAnimation(employee)
	return employee:getWorkplaceAnimation()
end

workplace.X_OFFSET_TO_CHAIR = 24
workplace.Y_OFFSET_TO_CHAIR = 24
workplace.FORWARD_OFFSET_TO_CHAIR = -24

function workplace:onFinishMoving()
	if self.assignedEmployee then
		if self.wasRoomChange then
			self.assignedEmployee:setPos(self:getFacingPosition())
			self.assignedEmployee:faceObject(self)
		else
			self.assignedEmployee:setIsOnWorkplace(nil)
		end
	end
end

function workplace:enterVisibilityRange()
	workplace.baseClass.enterVisibilityRange(self)
	
	if employeeAssignment.active and self.office:isPlayerOwned() then
		employeeAssignment:addWorkplaceObject(self)
	end
end

function workplace:leaveVisibilityRange()
	workplace.baseClass.leaveVisibilityRange(self)
	
	if employeeAssignment.active and self.office:isPlayerOwned() then
		employeeAssignment:removeWorkplaceObject(self)
	end
end

function workplace:updateLightState()
	if self.assignedEmployee then
		self:enableLightCasting()
	else
		self:disableLightCasting()
	end
end

function workplace:getEntranceInteractionCoordinates(startX, startY)
	local entranceStartX, entranceStartY, entranceEndX, entranceEndY = self:getEntranceCoordinates(startX, startY)
	local dir = walls.DIRECTION[self.rotation]
	
	return entranceStartX + dir[1], entranceStartY + dir[2]
end

function workplace:validateReach(gridX, gridY)
	local targetX, targetY = self:getEntranceInteractionCoordinates(startX, startY)
	
	return gridX == targetX and gridY == targetY
end

function workplace:onBeingFaced(employee)
	local ang = self:getFacingAngles()
	local x, y = math.normalfromdeg(ang - 90)
	
	employee:setIsOnWorkplace(true)
	employee:getAvatar():setDrawOffset(math.abs(x) * self.X_OFFSET_TO_CHAIR + y * -self.FORWARD_OFFSET_TO_CHAIR, math.abs(y) * self.Y_OFFSET_TO_CHAIR + x * self.FORWARD_OFFSET_TO_CHAIR)
	employee:setPos(self:getFacingPosition())
	workplace.baseClass.onBeingFaced(self, employee)
	employee:setAngleRotation(ang)
end

function workplace:wasAddedToOffice()
	return self.addedToOffice
end

function workplace:setOffice(office)
	local oldOffice = self.office
	
	workplace.baseClass.setOffice(self, office)
	
	if office ~= oldOffice and oldOffice and self.addedToOffice then
		oldOffice:removeWorkplace(self)
		
		self.addedToOffice = false
	end
end

function workplace:attemptRegister()
	workplace.baseClass.attemptRegister(self)
	
	if self.assignedEmployee then
		if not self.validObject or not self.reachable or not self.entranceValid then
			self:unassignEmployee()
		end
	elseif self.validObject and self.reachable and self.entranceValid and not self.assignedEmployee then
		employeeAssignment:assignEmployeesToFreeWorkplaces(self.office:getWorkplaces())
	end
	
	if not self.validObject then
		self:unassignEmployee()
		
		if self.addedToOffice then
			self.office:removeWorkplace(self)
			
			self.addedToOffice = false
		end
	else
		if not self.addedToOffice then
			self.office:addWorkplace(self)
			
			self.addedToOffice = true
		end
		
		employeeAssignment:assignEmployeesToFreeWorkplaces(self.office:getWorkplaces())
	end
end

function workplace:isValidForWork()
	return self.reachable and self.entranceValid and self.brightEnough
end

function workplace:setupMouseOverDescbox(descbox, wrapWidth)
	workplace.baseClass.setupMouseOverDescbox(self, descbox, wrapWidth)
	
	if self.assignedEmployee then
		descbox:addText(_format(_T("WORKPLACE_IN_USE_BY", "In-use by NAME"), "NAME", self.assignedEmployee:getFullName(true), "bh_world20", nil, 0), "bh_world20", nil, 0, wrapWidth, "employee", 20, 20)
	else
		descbox:addText(_T("WORKPLACE_UNOCCUPIED", "Unoccupied"), "bh_world20", nil, 0, wrapWidth)
	end
end

local function assignToWorkplace(self)
	employeeAssignment:enter()
end

local function unassignFromWorkplace(self)
	local employee = self.workplace:getAssignedEmployee()
	
	self.workplace:unassignEmployee()
	self.workplace:verifyEmployeeTask(employee)
end

function workplace:canAssignToWorkplace()
	return self.brightEnough
end

function workplace:fillInteractionComboBox(comboBox)
	if self:isValidForWork() then
		if self.assignedEmployee then
			local text = _T("FREE_WORKPLACE", "Free workplace (in use by EMPLOYEE_NAME)")
			
			text = string.easyformatbykeys(text, "EMPLOYEE_NAME", self.assignedEmployee:getName())
			
			local option = comboBox:addOption(0, 0, 0, 24, text, fonts.get("pix20"), unassignFromWorkplace)
			
			option.workplace = self
		else
			local text = _T("ASSIGN_EMPLOYEE", "Assign employee")
			local option = comboBox:addOption(0, 0, 0, 24, text, fonts.get("pix20"), assignToWorkplace)
		end
	end
	
	workplace.baseClass.fillInteractionComboBox(self, comboBox)
end

function workplace:getMonthlyCosts()
	if self.assignedEmployee then
		return self.activeMonthlyCosts
	end
	
	return self.inactiveMonthlyCosts
end

function workplace:addDescriptionToDescbox(descBox, wrapWidth)
	workplace.baseClass.addDescriptionToDescbox(self, descBox, wrapWidth)
	
	for key, costType in ipairs(self.activeMonthlyCosts:getCostTypeList()) do
		local costData = monthlyCost.getCostData(costType)
		local text
		local amount = self.activeMonthlyCosts:getCostType(costType)
		
		if amount > 0 then
			descBox:addText(_format(_T("INCREASE_IN_MONTHLY_COSTS_WHEN_ACTIVE", "+$CHANGE to AFFECTOR bills/month (when active)"), "CHANGE", amount, "AFFECTOR", costData.display), "bh20", nil, 0, wrapWidth, costData.iconQuad, 22, 22)
		end
	end
end

function workplace:clearAssignedEmployee()
	self.assignedEmployee = nil
	
	self:disableLightCasting()
	
	if not skipCostUpdate and self.office then
		self.office:updateMonthlyCosts(self.floor)
		studio:updateMonthlyCosts()
	end
end

function workplace:assignEmployee(employee, skipFacing)
	self.assignedEmployee = employee
	
	if employee then
		employee:setWorkplace(self)
		
		if not skipFacing then
			employee:setPos(self:getFacingPosition())
			employee:faceObject(self)
			employee:updateSitAnimation()
		end
		
		self:enableLightCasting()
	else
		self:disableLightCasting()
	end
	
	studio:updateMonthlyCosts()
end

function workplace:updateAssigneeRoom(oldRoom)
	if self.room and oldRoom ~= self.room then
		self.assignedEmployee:setRoom(self.room)
		
		if oldRoom then
			local oldOffice = oldRoom:getOffice()
			local officeObject = self.room:getOffice()
			
			if oldOffice ~= officeObject then
				self.assignedEmployee:setOffice(officeObject)
			end
			
			if not self._removed then
				studio.driveAffectors:calculateDriveAffection(officeObject)
			end
		end
	end
end

function workplace:onOfficeChanged(newOffice)
	workplace.baseClass.onOfficeChanged(self, newOffice)
	
	if newOffice and self.assignedEmployee then
		self.assignedEmployee:setOffice(newOffice)
	end
end

function workplace:setRoom(room)
	local oldRoom = self.room
	
	workplace.baseClass.setRoom(self, room)
	
	if self.room and self.assignedEmployee then
		self:updateAssigneeRoom(oldRoom)
	end
	
	self.wasRoomChange = oldRoom ~= self.room
end

function workplace:unassignEmployee(skipCostUpdate)
	if self.assignedEmployee then
		self.assignedEmployee:setWorkplace(nil)
		
		self.assignedEmployee = nil
	end
	
	self:disableLightCasting()
	
	if not skipCostUpdate and self.office then
		self.office:updateMonthlyCosts(self.floor)
		studio:updateMonthlyCosts()
	end
end

function workplace:onRemoved()
	if self.office then
		self.office:removeWorkplace(self)
	end
	
	local employee = self.assignedEmployee
	
	self:unassignEmployee()
	workplace.baseClass.onRemoved(self)
	
	if employee then
		self:verifyEmployeeTask(employee)
	end
end

function workplace:verifyEmployeeTask(employee)
	if employee:getTask() and not employee:getWorkplace() then
		employee:setTask(nil)
	end
end

function workplace:getAssignedEmployee()
	return self.assignedEmployee
end

function workplace:save()
	local saved = workplace.baseClass.save(self)
	
	saved.assignedEmployeeUID = self.assignedEmployee and self.assignedEmployee:getUniqueID() or nil
	
	return saved
end

function workplace:postLoad(data)
	if data.assignedEmployeeUID then
		local employee = studio:getEmployeeByUniqueID(data.assignedEmployeeUID)
		
		if employee then
			self:assignEmployee(employee)
		end
	end
end

objects.registerNew(workplace, "progressing_object_base")
