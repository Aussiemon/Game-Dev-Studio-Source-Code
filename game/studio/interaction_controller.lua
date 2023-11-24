interactionController = {}
interactionController.interactionObject = nil

function interactionController:startInteraction(object, x, y)
	if self:attemptHide(object) then
		return 
	end
	
	local comboBox = gui.create(self.comboBoxClass or "ComboBox")
	
	if x and y then
		comboBox:setPos(x - _S(20), y - _S(10))
	end
	
	comboBox.baseButton = object
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	comboBox:setObject(object)
	self:setInteractionObject(object, nil, nil, true)
end

function interactionController:setComboBoxClass(class)
	self.comboBoxClass = class
end

function interactionController:setInteractionObject(object, x, y, skipPreviousComboBoxRemoval)
	if not skipPreviousComboBoxRemoval then
		if not object then
			self:resetInteractionObject()
		elseif self.interactionObject == object then
			self:resetInteractionObject()
			
			return 
		end
	end
	
	self.interactionObject = object
	
	if object.fillInteractionComboBox then
		self:createInteractionComboBox(object, x, y, skipPreviousComboBoxRemoval)
	end
	
	objectSelector:hideUI()
end

function interactionController:getInteractionObject()
	return self.interactionObject
end

function interactionController:handleKeyPress(key, isrepeat)
	if key == "escape" then
		return self:attemptHide()
	end
	
	return false
end

function interactionController:attemptHide(newObject)
	if gui:isLimitingClicks() then
		return false
	end
	
	if newObject == self.interactionObject then
		return self:resetInteractionObject()
	end
	
	self:resetInteractionObject()
	
	return false
end

function interactionController:verifyComboBoxValidity()
	if self.interactionObject then
		if self.interactionObject:isValid() then
			return true
		end
		
		self:resetInteractionObject()
		
		return false
	end
	
	return true
end

function interactionController:resetInteractionObject()
	self.interactionObject = nil
	
	objectSelector:showUI()
	
	return self:killComboBox()
end

function interactionController:setComboBox(comboBox, noKill)
	if not noKill and self.interactionComboBox and self.interactionComboBox:isValid() and self.interactionComboBox:getVisible() then
		self.interactionComboBox:kill()
	end
	
	self.interactionComboBox = comboBox
	
	self.interactionComboBox:setDepth(200)
end

function interactionController:getComboBox()
	return self.interactionComboBox
end

function interactionController:killComboBox()
	if self.interactionComboBox and self.interactionComboBox:isValid() then
		self.interactionComboBox:kill()
		
		self.interactionComboBox = nil
		
		return true
	end
	
	return false
end

function interactionController:createInteractionComboBox(object, x, y, skipPreviousComboBoxRemoval)
	if not self.interactionComboBox or not self.interactionComboBox:isValid() then
		self.interactionComboBox = gui.create(self.comboBoxClass or "ComboBox")
		
		self.interactionComboBox:setDepth(200)
		
		if not x or not y then
			x, y = camera:getLocalMousePosition(object.x, object.y)
		end
	else
		self.interactionComboBox:clearOptions()
	end
	
	if x and y then
		self.interactionComboBox:setPos(x, y)
	end
	
	self.interactionComboBox:setObject(object)
	self.interactionComboBox:setInteractionObject(object)
	self:fillInteractionComboBox(object, skipPreviousComboBoxRemoval)
end

function interactionController:fillInteractionComboBox(object, skipPreviousComboBoxRemoval)
	if not skipPreviousComboBoxRemoval then
		self.interactionComboBox:clearOptions()
	end
	
	object:fillInteractionComboBox(self.interactionComboBox)
	
	if #self.interactionComboBox:getOptionElements() == 0 then
		self.interactionComboBox:addNoOptionsButton()
	end
end
