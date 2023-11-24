local housableObjectBase = {}

housableObjectBase.class = "housable_object_base"
housableObjectBase.BASE = true

function housableObjectBase:init()
	housableObjectBase.baseClass.init(self)
	
	self.housedObjects = {}
end

function housableObjectBase:canPlaceOnTop(otherObject)
	return self.canHouse[otherObject:getSizeCategory()]
end

function housableObjectBase:getHousedObjects()
	return self.housedObjects
end

function housableObjectBase:canPlaceOnTopOf(otherObject)
	return not self:hasHousedObject(otherObject)
end

function housableObjectBase:removeHousedObjects()
	for key, object in ipairs(self.housedObjects) do
		object:remove()
		
		self.housedObjects[key] = nil
	end
end

function housableObjectBase:hasHousedObject(object)
	for key, otherObject in ipairs(self.housedObjects) do
		if object == otherObject then
			return true
		end
	end
	
	return false
end

function housableObjectBase:postDrawExpansion(startX, startY, endX, endY)
	housableObjectBase.baseClass.postDrawExpansion(self, startX, startY, endX, endY)
	
	for key, object in ipairs(self.housedObjects) do
		object:postDrawExpansion(startX, startY, endX, endY)
	end
end

function housableObjectBase:beginMoving()
	housableObjectBase.baseClass.beginMoving(self)
	
	for key, object in ipairs(self.housedObjects) do
		object:beginMoving()
	end
end

function housableObjectBase:clearMoveData()
	housableObjectBase.baseClass.clearMoveData(self)
	
	for key, object in ipairs(self.housedObjects) do
		object:clearMoveData()
	end
end

function housableObjectBase:cancelMoving(originalRotation, originalX, originalY)
	housableObjectBase.baseClass.cancelMoving(self, originalRotation, originalX, originalY)
	
	for key, object in ipairs(self.housedObjects) do
		object:cancelMoving(originalRotation, originalX, originalY)
	end
end

function housableObjectBase:onMoving(newX, newY)
	housableObjectBase.baseClass.onMoving(self, newX, newY)
	
	for key, object in ipairs(self.housedObjects) do
		object:onMoving(newX, newY)
	end
end

function housableObjectBase:setRotation(rotation)
	housableObjectBase.baseClass.setRotation(self, rotation)
	
	for key, object in ipairs(self.housedObjects) do
		object:setRotation(rotation)
	end
end

function housableObjectBase:finishMoving()
	housableObjectBase.baseClass.finishMoving(self)
	
	for key, object in ipairs(self.housedObjects) do
		object:setPos(self:getPos())
		object:setFloor(self.floor)
		object:finalizeGridPlacement()
		object:finishMoving()
	end
end

function housableObjectBase:setReachable(state)
	housableObjectBase.baseClass.setReachable(self, state)
	
	for key, object in ipairs(self.housedObjects) do
		object:setReachable(state)
	end
end

function housableObjectBase:canPerformValidityString()
	local canPerform
	
	for key, object in ipairs(self.housedObjects) do
		if object:canPerformValidityString() then
			canPerform = true
			
			break
		end
	end
	
	local ownCanPerform = housableObjectBase.baseClass.canPerformValidityString(self)
	
	return canPerform or ownCanPerform
end

function housableObjectBase:processRoomValidityData(descBox, font, lineSpace, wrapWidth, icon, iconW, iconH)
	housableObjectBase.baseClass.processRoomValidityData(self, descBox, font, lineSpace, wrapWidth, icon, iconW, iconH)
	
	for key, object in ipairs(self.housedObjects) do
		object:processRoomValidityData(descBox, font, lineSpace, wrapWidth, icon, iconW, iconH)
	end
end

function housableObjectBase:fillInteractionComboBox(comboBox)
	for key, object in ipairs(self.housedObjects) do
		object:fillInteractionComboBox(comboBox)
	end
	
	housableObjectBase.baseClass.fillInteractionComboBox(self, comboBox)
end

function housableObjectBase:onObjectPlacedOnTop(object)
	table.insert(self.housedObjects, object)
	object:setRestsOn(self)
end

function housableObjectBase:onObjectRemoved(object)
	for key, otherObject in ipairs(self.housedObjects) do
		if otherObject == object then
			table.remove(self.housedObjects, key)
			
			break
		end
	end
end

function housableObjectBase:hasObjectClass(class)
	for key, object in ipairs(self.housedObjects) do
		if object:getClass() == class then
			return true
		end
	end
	
	return false
end

function housableObjectBase:hasObjectType(objectType)
	for key, object in ipairs(self.housedObjects) do
		if object:getObjectType() == objectType then
			return object
		end
	end
	
	return false
end

function housableObjectBase:getSellAmount()
	local cost = self.cost
	
	for key, object in ipairs(self.housedObjects) do
		cost = cost + object:getSellAmount()
	end
	
	return cost
end

local concatTable = {}

function housableObjectBase:getSellDisplay()
	table.clear(concatTable)
	
	concatTable[1] = self.display
	
	local objectCount = #self.housedObjects
	
	for key, object in ipairs(self.housedObjects) do
		concatTable[#concatTable + 1] = object:getName()
	end
	
	return table.concat(concatTable, ", ")
end

function housableObjectBase:onRemoved()
	housableObjectBase.baseClass.onRemoved(self)
	self:removeHousedObjects()
end

objects.registerNew(housableObjectBase, "static_object_base")
