local serverRack = {}

serverRack.tileWidth = 1
serverRack.tileHeight = 2
serverRack.class = "server_rack"
serverRack.category = "office"
serverRack.objectType = "server"
serverRack.roomType = studio.ROOM_TYPES.SERVER
serverRack.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.KITCHEN] = true,
	[studio.ROOM_TYPES.TOILET] = true,
	[studio.ROOM_TYPES.CONFERENCE] = true
}
serverRack.roomRequirements = {}
serverRack.roomExclusionRequirements = {}
serverRack.display = _T("OBJECT_SERVER_RACK", "Server rack")
serverRack.description = _T("OBJECT_SERVER_RACK_DESC_1", "A necessity for any MMO game project.")
serverRack.quad = quadLoader:load("whiteboard")
serverRack.scaleX = 2
serverRack.scaleY = 2
serverRack.requiresObject = false
serverRack.requiresEntrance = true
serverRack.inheritsRotation = false
serverRack.preventsMovement = true
serverRack.lightAtlas = "object_atlas_4"
serverRack.affectors = {}
serverRack.realMonthlyCosts = {}
serverRack.monthlyCosts = monthlyCost.new()
serverRack.animateOnFacing = false
serverRack.xDirectionalOffset = -8
serverRack.yDirectionalOffset = 8
serverRack.objectAtlas = "object_atlas_1"
serverRack.objectAtlasBetweenWalls = "object_atlas_1_between_walls"
serverRack.icon = "icon_whiteboard"
serverRack.devSpeedMultiplier = 0.1
serverRack.devSpeedMultiplierID = "whiteboard"
serverRack.EVENTS = {
	UPGRADED = events:new()
}
serverRack.progression = {
	{
		cost = 80000,
		capacity = 200000,
		icon = "icon_server_rack_1",
		lightX = -4.5,
		lightY = -12,
		date = {
			year = 1996,
			month = 9
		},
		quad = quadLoader:load("server_rack_1"),
		lightQuad = quadLoader:load("server_rack_1_lamps")
	},
	{
		cost = 90000,
		capacity = 220000,
		icon = "icon_server_rack_2",
		lightX = -1,
		lightY = -7.5,
		date = {
			year = 1997,
			month = 6
		},
		quad = quadLoader:load("server_rack_2"),
		lightQuad = quadLoader:load("server_rack_2_lamps")
	},
	{
		cost = 100000,
		capacity = 250000,
		icon = "icon_server_rack_3",
		lightX = -5.5,
		lightY = -12.5,
		date = {
			year = 1998,
			month = 7
		},
		quad = quadLoader:load("server_rack_3"),
		lightQuad = quadLoader:load("server_rack_3_lamps")
	},
	{
		cost = 110000,
		capacity = 300000,
		icon = "icon_server_rack_4",
		lightX = 3.5,
		lightY = -13,
		date = {
			year = 1999,
			month = 5
		},
		quad = quadLoader:load("server_rack_4"),
		lightQuad = quadLoader:load("server_rack_4_lamps")
	},
	{
		cost = 120000,
		capacity = 370000,
		icon = "icon_server_rack_5",
		lightX = -5.5,
		lightY = -15,
		date = {
			year = 2001,
			month = 6
		},
		quad = quadLoader:load("server_rack_5"),
		lightQuad = quadLoader:load("server_rack_5_lamps")
	},
	{
		cost = 130000,
		capacity = 430000,
		icon = "icon_server_rack_6",
		lightX = -4.5,
		lightY = -13,
		date = {
			year = 2005,
			month = 2
		},
		quad = quadLoader:load("server_rack_6"),
		lightQuad = quadLoader:load("server_rack_6_lamps")
	},
	{
		cost = 140000,
		capacity = 500000,
		icon = "icon_server_rack_7",
		lightX = -2.5,
		lightY = -12.5,
		date = {
			year = 2009,
			month = 4
		},
		quad = quadLoader:load("server_rack_7"),
		lightQuad = quadLoader:load("server_rack_7_lamps")
	},
	{
		cost = 150000,
		capacity = 600000,
		icon = "icon_server_rack_8",
		lightX = 1.5,
		lightY = -12,
		date = {
			year = 2012,
			month = 10
		},
		quad = quadLoader:load("server_rack_8"),
		lightQuad = quadLoader:load("server_rack_8_lamps")
	},
	{
		cost = 160000,
		capacity = 750000,
		icon = "icon_server_rack_9",
		lightX = 0,
		lightY = -11.5,
		date = {
			year = 2016,
			month = 3
		},
		quad = quadLoader:load("server_rack_9"),
		lightQuad = quadLoader:load("server_rack_9_lamps")
	}
}

for key, data in ipairs(serverRack.progression) do
	serverRenting:registerLevel(data.date, data.capacity)
end

function serverRack:addDescriptionToDescbox(descBox, wrapWidth)
	serverRack.baseClass.addDescriptionToDescbox(self, descBox, wrapWidth)
	descBox:addTextLine(_S(300), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	descBox:addText(_format(_T("OBJECT_SERVER_RACK_DESC_2", "Increases Server Capacity by AMOUNT points"), "AMOUNT", string.comma(self:getCapacityChange(self:getLatestProgression()))), "bh18", nil, 3, wrapWidth, "question_mark", 22, 22)
	descBox:addTextLine(_S(300), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	descBox:addText(_T("OBJECT_SERVER_RACK_DESC_3", "This object is necessary only for MMO game projects."), "bh18", nil, 0, wrapWidth, "exclamation_point_yellow", 22, 22)
end

function serverRack:setIsPartOfValidRoom(state)
	serverRack.baseClass.setIsPartOfValidRoom(self, state)
	
	if state then
		if not self.countedIn then
			studio:changeServerCapacity(self:getCapacityChange())
			
			self.countedIn = true
		end
	elseif self.countedIn then
		studio:changeServerCapacity(-self:getCapacityChange())
		
		self.countedIn = false
	end
end

function serverRack:getCapacityChange(progressionLevel)
	return self.progression[progressionLevel or self.progressionLevel].capacity
end

function serverRack:fillInteractionComboBox(comboBox)
	serverRenting:addMenuOption(comboBox, "pix20")
	serverRack.baseClass.fillInteractionComboBox(self, comboBox)
end

function serverRack:setProgression(level)
	self.progressionLevel = math.max(1, level)
	
	self:updateLightQuad()
	self:updateSprite()
end

function serverRack:updateLightQuad()
	local data = self.progression[self.progressionLevel]
	
	self.lightQuad = data.lightQuad
	self.lightX = data.lightX or 0
	self.lightY = data.lightY or 0
end

function serverRack:upgradeObject(simpleUpgrade)
	local curCapacity = self:getCapacityChange()
	local curLevel = self.progressionLevel
	
	serverRack.baseClass.upgradeObject(self, simpleUpgrade)
	
	local newCapacity = self:getCapacityChange()
	
	if self.countedIn then
		studio:changeServerCapacity(-curCapacity)
		studio:changeServerCapacity(newCapacity)
	end
	
	events:fire(serverRack.EVENTS.UPGRADED, self, curLevel)
end

function serverRack:init()
	self.visitedIncompatibleObjects = {}
	self.glowValue = math.randomf(0, math.pi)
	
	serverRack.baseClass.init(self)
end

function serverRack:remove()
	serverRack.baseClass.remove(self)
	
	if self.countedIn then
		studio:changeServerCapacity(-self:getCapacityChange())
	end
end

function serverRack:switchSpriteBatches()
	self:clearLightSprite()
	
	self.spriteBatch = studio.expansion:getSpriteSheetByID(self.textureID)
end

function serverRack:returnSpritebatches()
	self:clearSprite()
	self:setupSpritebatches()
end

function serverRack:_pickSpritebatches(lowerWallPresent)
	local prevBatch = self.spriteBatch
	local newBatch = lowerWallPresent and spriteBatchController:getContainer(self.objectAtlasBetweenWalls) or spriteBatchController:getContainer(self.objectAtlas)
	
	self.lightSB = spriteBatchController:getContainer(self.lightAtlas)
	
	if newBatch ~= prevBatch then
		self:clearSprite()
		
		if prevBatch then
			for key, sb in ipairs(self.spriteBatches) do
				sb:decreaseVisibility()
				
				self.spriteBatches[key] = nil
			end
		end
		
		self.spriteBatch = newBatch
		
		if prevBatch then
			self:referenceSpritebatches()
			self:increaseVisibility()
		end
	else
		self.spriteBatch = newBatch
	end
	
	self:updateSprite()
end

function serverRack:referenceSpritebatches()
	table.insert(self.spriteBatches, self.spriteBatch)
	table.insert(self.spriteBatches, self.lightSB)
end

function serverRack:updateSprite()
	serverRack.baseClass.updateSprite(self)
	
	if self.visible and self.lightQuad then
		self:updateLightSprite()
	else
		self:clearLightSprite()
	end
end

function serverRack:clearLightSprite()
	if self.lightSpriteID then
		self.lightSB:deallocateSlot(self.lightSpriteID)
		
		self.lightSpriteID = nil
	end
end

function serverRack:updateLightSprite()
	local objectGrid = game.worldObject:getObjectGrid()
	local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, self.lightQuad)
	
	self.lightSpriteID = self.lightSpriteID or self.lightSB:allocateSlot()
	
	local glowSine = math.sin(self.glowValue)
	
	self.lightSB:setColor(255, 255, 255, 50 + 205 * glowSine)
	self.lightSB:updateSprite(self.lightSpriteID, self.lightQuad, x, y, rotation, 2, 2, xOff * 0.5 + self.lightX, yOff * 0.5 + self.lightY)
end

function serverRack:draw()
	local realSpeed = timeline.realProgressTime
	
	self.glowValue = self.glowValue + realSpeed * 0.5
	
	if self.lightQuad then
		self:updateLightSprite()
	end
	
	if self.glowValue >= math.pi then
		self.glowValue = self.glowValue - math.pi
	end
end

function serverRack:clearSprite()
	serverRack.baseClass.clearSprite(self)
	
	if self.lightSpriteID then
		self.lightSB:deallocateSlot(self.lightSpriteID)
		
		self.lightSpriteID = nil
	end
end

function serverRack:load(data)
	serverRack.baseClass.load(self, data)
	self:updateLightQuad()
end

local roomCheckingObjectBase = objects.getClassData("room_checking_object_base")

serverRack.isValidRoom = roomCheckingObjectBase.isValidRoom
serverRack.handleIncompatibilityData = roomCheckingObjectBase.handleIncompatibilityData
serverRack.checkRoomTypeExclusions = roomCheckingObjectBase.checkRoomTypeExclusions

objects.registerNew(serverRack, "progressing_object_base")
