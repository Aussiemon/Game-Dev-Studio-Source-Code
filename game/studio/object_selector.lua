objectSelector = {}
objectSelector.interactableObjects = {}
objectSelector.interactableObjectsMap = {}
objectSelector.objectList = nil
objectSelector.objectIndex = 1
objectSelector.blockers = {}
objectSelector.EVENTS = {
	OBJECT_SELECTION_CYCLED = events:new()
}

function objectSelector:init()
	events:addDirectReceiver(self, objectSelector.CATCHABLE_EVENTS)
	events:addFunctionReceiver(self, self.handleObjectMoveFinished, studio.expansion.EVENTS.FINISHED_MOVING_OBJECT)
end

function objectSelector:setupMouseOverDescbox(object)
	if not self.mouseOverDescbox or not self.mouseOverDescbox:isValid() then
		self.mouseOverDescbox = gui.create("ObjectInfoDescbox")
		
		self.mouseOverDescbox:setObject(object)
	else
		self.mouseOverDescbox:removeAllText()
		self.mouseOverDescbox:setObject(object)
		self.mouseOverDescbox:show()
	end
end

function objectSelector:updateDescbox(clear)
	if self.mouseOverDescbox and self.mouseOverDescbox:getVisible() then
		self.mouseOverDescbox:updateDescbox(clear)
	end
end

function objectSelector:getMouseOverDescbox()
	return self.mouseOverDescbox
end

function objectSelector:hideMouseOverDescbox()
	if self.mouseOverDescbox and self.mouseOverDescbox:getVisible() then
		self.mouseOverDescbox:hide()
		self.mouseOverDescbox:clear()
	end
end

function objectSelector:remove()
	table.clearArray(self.blockers)
	events:removeDirectReceiver(self, objectSelector.CATCHABLE_EVENTS)
	events:removeFunctionReceiver(self, studio.expansion.EVENTS.FINISHED_MOVING_OBJECT)
	self:reset(true)
end

function objectSelector:handleObjectMoveFinished(object)
	self.objectList = nil
	
	self:updateInteractionListOnMouse(object:getObjectGrid())
end

function objectSelector:onFloorViewChanged()
	self:reset(true)
end

function objectSelector:addBlocker(prevent)
	if table.find(self.blockers, prevent) then
		return 
	end
	
	table.insert(self.blockers, prevent)
	self:reset(true)
end

function objectSelector:removeBlocker(prevent)
	table.removeObject(self.blockers, prevent)
end

function objectSelector:getBlockers()
	return self.blockers
end

function objectSelector:canMouseOver()
	return #self.blockers == 0 and not gui.elementHovered
end

function objectSelector:handleEvent(event, object)
	if event == studio.expansion.EVENTS.PLACED_OBJECT then
		self:updateInteractionListOnMouse(object:getObjectGrid() or game.worldObject:getObjectGrid())
		self:updateInteractionCombobox()
	else
		local position = table.find(self.interactableObjects, object)
		
		if position then
			outlineShader:setDrawObject(nil)
			
			self.objectList = nil
			
			table.remove(self.interactableObjects, position)
			
			if #self.interactableObjects > 1 then
				self:updateInteractionListOnMouse(object:getObjectGrid() or game.worldObject:getObjectGrid())
			else
				self:reset(true)
			end
		end
	end
end

function objectSelector:reset(deselect)
	if deselect then
		local object = self.interactableObjects[self.objectIndex]
		
		if object then
			object:onMouseLeft()
			game.setMouseOverObject(nil)
		end
		
		self:hideMouseOverDescbox()
	else
		game.setMouseOverObject(nil)
	end
	
	outlineShader:setDrawObject(nil)
	
	for key, obj in ipairs(self.interactableObjects) do
		self.interactableObjectsMap[obj] = nil
		self.interactableObjects[key] = nil
	end
	
	self.objectList = nil
	self.objectIndex = 1
	
	self:killDescbox()
end

function objectSelector:killDescbox()
	if self.descBox then
		self.descBox:kill()
		
		self.descBox = nil
	end
end

function objectSelector:cycleInteractionObject(direction)
	if #self.interactableObjects == 0 then
		return false
	end
	
	local oldIndex = self.objectIndex
	
	self.objectIndex = self.objectIndex + direction
	
	if self.objectIndex <= 0 then
		self.objectIndex = #self.interactableObjects
	elseif self.objectIndex > #self.interactableObjects then
		self.objectIndex = 1
	end
	
	if self.objectIndex ~= oldIndex then
		events:fire(objectSelector.EVENTS.OBJECT_SELECTION_CYCLED, direction)
		
		return true
	end
	
	return false
end

function objectSelector:getCurrentInteractableObject()
	return self.interactableObjects[self.objectIndex]
end

function objectSelector:getInteractableObjectList()
	return self.interactableObjects
end

function objectSelector:hideUI()
	if self.descBox then
		self.descBox:hide()
	end
	
	if self.mouseOverDescbox then
		self:hideMouseOverDescbox()
	end
end

function objectSelector:showUI()
	if not self:canMouseOver() then
		return 
	end
	
	if self.descBox then
		self.descBox:show()
	end
	
	if self.mouseOverDescbox then
		self.mouseOverDescbox:show()
	end
end

function objectSelector:createInteractionDescbox()
	self.descBox = self.descBox or gui.create("ObjectInteractionDescbox")
	
	self.descBox:setObjectList(self.interactableObjects)
	self.descBox:setFadeInSpeed(0)
end

function objectSelector:updateInteractionListOnMouse(objectGrid)
	local x, y = objectGrid:getMouseTileCoordinates()
	
	self:updateInteractionList(objectGrid:getObjects(x, y, camera:getViewFloor()))
end

function objectSelector:updateInteractionList(objects)
	if studio.expansion:preventsObjectSelector() then
		return 
	end
	
	local previousObject = self.interactableObjects[self.objectIndex]
	
	self.objectList = objects
	
	local map = self.interactableObjectsMap
	local index = 1
	
	for i = 1, #self.interactableObjects do
		local obj = self.interactableObjects[index]
		
		if not obj:isMouseOver() or obj._removed then
			table.remove(self.interactableObjects, index)
			
			map[obj] = nil
		else
			index = index + 1
		end
	end
	
	self.objectIndex = 1
	
	if not objects then
		return 
	end
	
	if studio.expansion:isActive() then
		for key, object in ipairs(objects) do
			if not map[object] and not object._removed and object:canInteractWithExpansion() and object:isMouseOver() then
				table.insert(self.interactableObjects, object)
				
				map[object] = true
			end
		end
	else
		for key, object in ipairs(objects) do
			if not map[object] and not object._removed and object:canDrawMouseOver() and object:isMouseOver() then
				table.insert(self.interactableObjects, object)
				
				map[object] = true
			end
		end
	end
	
	if previousObject then
		self:switchToObject(previousObject)
	end
end

function objectSelector:switchToObject(object)
	for key, otherObject in ipairs(self.interactableObjects) do
		if otherObject == object then
			self.objectIndex = key
			
			self:updateInteractionCombobox()
			
			return true
		end
	end
	
	return false
end

function objectSelector:onMouseOverObject(object)
	if interactionController:getInteractionObject() then
		return 
	end
	
	self:setupMouseOverDescbox(object)
	outlineShader:setDrawObject(object)
	
	if #self.interactableObjects < 2 then
		self:reset()
		
		local x, y = game.worldObject:getObjectGrid():getRealMouseTileCoordinates()
		
		self:updateInteractionList(game.worldObject:getObjectGrid():getObjects(x, y, camera:getViewFloor()), object)
		
		return 
	end
	
	self:updateInteractionCombobox()
end

function objectSelector:updateInteractionCombobox()
	if #self.interactableObjects > 1 then
		self:createInteractionDescbox()
	else
		self:killDescbox()
	end
end

function objectSelector:onMouseOverObjectSwitched(newObject)
	if interactionController:getInteractionObject() then
		return 
	end
	
	if newObject then
		local x, y = game.worldObject:getObjectGrid():getRealMouseTileCoordinates()
		local objects = game.worldObject:getObjectGrid():getObjects(x, y, camera:getViewFloor())
		
		if not table.find(objects, newObject) then
			self:reset()
		else
			self:updateInteractionList(objects)
		end
	else
		self:hideMouseOverDescbox()
		
		if not table.find(self.interactableObjects, interactionController:getInteractionObject()) then
			self:reset()
		end
	end
end

function objectSelector:adjustMouseOverPosition(x, y)
	if self.descBox then
		local elementX, elementY = self.descBox:getPos(true)
		
		return elementX, elementY + self.descBox.h + _S(5)
	end
	
	return (x - camera.x) * camera.scaleX, (y - camera.y) * camera.scaleY
end
