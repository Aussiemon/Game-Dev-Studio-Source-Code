local roomCheckingObjectBase = {}

roomCheckingObjectBase.class = "room_checking_object_base"
roomCheckingObjectBase.matchingRequirements = {}
roomCheckingObjectBase.roomType = nil
roomCheckingObjectBase.minimumIllumination = 0.4
roomCheckingObjectBase.partOfValidRoom = nil
roomCheckingObjectBase.contributesToRoom = nil
roomCheckingObjectBase.roomTypeExclusions = {}
roomCheckingObjectBase.roomExclusionRequirements = {}
roomCheckingObjectBase.roomRequirements = {}
roomCheckingObjectBase.ROOM_CHECKING_OBJECT = true
roomCheckingObjectBase.BASE = true
roomCheckingObjectBase.DUMMY_NO_AFFECTOR = {}

function roomCheckingObjectBase:init()
	self.visitedIncompatibleObjects = {}
	
	roomCheckingObjectBase.baseClass.init(self)
end

function roomCheckingObjectBase:onPurchased()
	if self.roomType then
		self:addEventReceiver()
	end
	
	roomCheckingObjectBase.baseClass.onPurchased(self)
end

function roomCheckingObjectBase:onRemoved()
	roomCheckingObjectBase.baseClass.onRemoved(self)
	self:setIsPartOfValidRoom(false)
end

function roomCheckingObjectBase:getRoomType()
	return self.roomType
end

function roomCheckingObjectBase:getDriveAffector()
	if not self.contributesToRoom then
		return roomCheckingObjectBase.DUMMY_NO_AFFECTOR
	end
	
	return roomCheckingObjectBase.baseClass.getDriveAffector(self)
end

function roomCheckingObjectBase:remove()
	roomCheckingObjectBase.baseClass.remove(self)
	
	if self.roomType then
		self:removeEventReceiver()
	end
end

function roomCheckingObjectBase:addObjectTypeRestroomRequirement(objType, amount)
	amount = amount or 1
	self.roomRequirements[objType] = amount
end

function roomCheckingObjectBase:addObjectTypeRestroomRequirementExclusion(objType, amount)
	amount = amount or 1
	self.roomExclusionRequirements[objType] = amount
end

function roomCheckingObjectBase:checkRoomTypeExclusions(exclusions, object)
	if object:shouldIgnoreRoomChecking(self) then
		return false
	end
	
	local roomTypes = object:getRoomType()
	local roomType = type(roomTypes)
	
	if roomType == "number" and exclusions[roomTypes] then
		return true
	elseif roomType == "table" then
		local total, incompatible = 0, 0
		
		for roomType, state in pairs(roomTypes) do
			total = total + 1
			
			local incompat = exclusions[roomType]
			
			if incompat then
				incompatible = incompatible + 1
			end
		end
		
		return total == incompatible
	end
	
	return false
end

local sameRoomObjects = {}

function roomCheckingObjectBase:isValidRoom()
	local x, y = self:getTileCoordinates()
	local expansion = studio.expansion
	local tileGrid = game.worldObject:getFloorTileGrid()
	local objectGrid = game.worldObject:getObjectGrid()
	local requirements = self.roomRequirements
	local exclusions = self.roomExclusionRequirements
	local roomTypeExclusions = self.roomTypeExclusions
	
	for requirement, amount in pairs(requirements) do
		self.matchingRequirements[requirement] = 0
	end
	
	table.clear(self.visitedIncompatibleObjects)
	
	local isValid = roomCheckingObjectBase.baseClass.isValidRoom(self)
	local room = self:getRoom()
	local objects = room:getObjects()
	
	for key, object in ipairs(objects) do
		local objType = object:getObjectType()
		
		if exclusions[objType] or self:checkRoomTypeExclusions(roomTypeExclusions, object) then
			isValid = false
			
			local objectClass = object:getClass()
			
			if not self.visitedIncompatibleObjects[objectClass] then
				self.visitedIncompatibleObjects[objectClass] = true
				
				table.insert(self.incompatibilityFactors, {
					type = roomCheckingObjectBase.INCOMPATIBILITY_TYPES.INCOMPATIBLE,
					name = object:getName()
				})
			end
		elseif requirements[objType] and object ~= self and object:isValidRoom() then
			self.matchingRequirements[objType] = self.matchingRequirements[objType] + 1
			
			room:markSameRoomObject(object)
			
			if not table.find(sameRoomObjects, object) then
				sameRoomObjects[#sameRoomObjects + 1] = object
			end
		end
	end
	
	if self.noWindows then
		local windowCount = room:getWallTypeCount(walls.wallTypes.WINDOW)
		
		if windowCount > 0 then
			table.insert(self.incompatibilityFactors, {
				type = roomCheckingObjectBase.INCOMPATIBILITY_TYPES.WINDOW,
				windowCount = windowCount
			})
			
			isValid = false
		end
	end
	
	if not self.brightEnough then
		isValid = false
	end
	
	for requirement, amount in pairs(requirements) do
		if amount > self.matchingRequirements[requirement] then
			isValid = false
			
			table.insert(self.incompatibilityFactors, {
				type = roomCheckingObjectBase.INCOMPATIBILITY_TYPES.MISSING,
				id = requirement,
				amount = amount - self.matchingRequirements[requirement]
			})
		end
	end
	
	for key, object in ipairs(sameRoomObjects) do
		object:setIsValid(true)
		
		sameRoomObjects[key] = nil
	end
	
	return isValid
end

function roomCheckingObjectBase:handleIncompatibilityData(data)
	local result = roomCheckingObjectBase.baseClass.handleIncompatibilityData(self, data)
	
	if not result then
		if data.type == roomCheckingObjectBase.INCOMPATIBILITY_TYPES.INCOMPATIBLE then
			result = _format(_T("INCOMPATIBLE_OBJECT", "CONFLICT can't share a room with OBJECT"), "CONFLICT", data.name, "OBJECT", self:getDisplayText())
		elseif data.type == roomCheckingObjectBase.INCOMPATIBILITY_TYPES.MISSING then
			result = _format(_T("MISSING_OBJECT", "Missing AMOUNT OBJECT"), "AMOUNT", data.amount, "OBJECT", objects.getClassData(data.id):getDisplayText(data.id))
		elseif data.type == roomCheckingObjectBase.INCOMPATIBILITY_TYPES.WINDOW then
			result = _format(_T("INCOMPATIBLE_WITH_WINDOW", "OBJECT can't have any windows in the room.\nCurrent window count: WINDOWS"), "OBJECT", self:getDisplayText(), "WINDOWS", data.windowCount)
		end
	end
	
	return result
end

function roomCheckingObjectBase:onMouseLeft()
	roomCheckingObjectBase.baseClass.onMouseLeft(self)
	
	self.roomValidityString = nil
end

function entity:canDrawMouseOver()
	return not frameController:preventsMouseOver() or studio.expansion:isActive()
end

function roomCheckingObjectBase:load(data)
	roomCheckingObjectBase.baseClass.load(self, data)
end

objects.registerNew(roomCheckingObjectBase, "complex_monthly_cost_object_base")
roomCheckingObjectBase:addIncompatibilityType("INCOMPATIBLE")
roomCheckingObjectBase:addIncompatibilityType("MISSING")
roomCheckingObjectBase:addIncompatibilityType("WINDOW")
