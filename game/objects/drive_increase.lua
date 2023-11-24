local driveChange = {}

driveChange.class = "drive_change_display"
driveChange.CHANGE_TO_ELEMENT = 3.5
driveChange.LEVEL_TO_ALPHA = 0.3333333333333333
driveChange.TIME_TO_DISPLAY = 3
driveChange.ICON_QUAD = quadLoader:load("positive_change")
driveChange.tileWidth = 0
driveChange.tileHeight = 0

function driveChange:init()
	driveChange.baseClass.init(self)
	
	self.spritebatchContainer = spriteBatchController:getContainer("world_ui")
	self.allocatedSprites = {}
	self.displayTime = 0
end

function driveChange:setDeveloper(developer)
	self.developer = developer
end

function driveChange:update(dt)
	local x, y = self.developer:getAvatar():getDrawPosition()
	
	for key, spriteID in ipairs(self.allocatedSprites) do
		local dist = math.dist(key * driveChange.LEVEL_TO_ALPHA * 0.5, self.currentLevel)
		
		self.spritebatchContainer:setColor(255, 255, 255, 255 - math.min(255, 255 * (dist / driveChange.LEVEL_TO_ALPHA)))
		self.spritebatchContainer:updateSprite(spriteID, driveChange.ICON_QUAD, x - 20, y - 20 - 8 * (key - 1), 0, 2, 2, 0, 0)
	end
	
	self.spritebatchContainer:setColor(255, 255, 255, 255)
	
	self.currentLevel = math.approach(self.currentLevel, self.targetLevel, dt * 2)
	self.displayTime = self.displayTime + dt
	
	if self.displayTime >= self.TIME_TO_DISPLAY then
		if self.currentLevel == self.targetLevel then
			game.removeDynamicObject(self)
			self:deallocateSprites()
		end
	elseif self.currentLevel >= self.targetLevel then
		self.currentLevel = self.currentLevel - self.targetLevel
	end
end

function driveChange:displayDriveChange(change)
	local elementCount = math.ceil(change / driveChange.CHANGE_TO_ELEMENT)
	
	self.elementCount = elementCount
	self.targetLevel = (elementCount + 1) * driveChange.LEVEL_TO_ALPHA
	self.currentLevel = 0
	self.displayTime = 0
	
	self:allocateSprites()
	game.addDynamicObject(self)
end

function driveChange:allocateSprites()
	self:deallocateSprites()
	
	for i = 1, self.elementCount do
		local slot = self.spritebatchContainer:allocateSlot()
		
		self.spritebatchContainer:increaseVisibility()
		
		self.allocatedSprites[i] = slot
	end
end

function driveChange:deallocateSprites()
	for key, spriteID in ipairs(self.allocatedSprites) do
		self.spritebatchContainer:deallocateSlot(spriteID)
		self.spritebatchContainer:decreaseVisibility()
		
		self.allocatedSprites[key] = nil
	end
end

function driveChange:remove()
	self.baseClass.remove(self)
	self:deallocateSprites()
end

objects.registerNew(driveChange)
