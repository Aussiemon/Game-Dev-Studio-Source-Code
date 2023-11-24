local lightSource = {}

lightSource.tileWidth = 1
lightSource.tileHeight = 1
lightSource.class = "light_source"
lightSource.objectType = "light_source"
lightSource.category = "general"
lightSource.display = _T("LAMP", "Lamp")
lightSource.description = _T("LAMP_DESCRIPTION", "A source of light. Lamps are necessary for offices, as employees will refuse to work in poorly lit areas, and most objects are unusable unless adequately lit.")
lightSource.glowSpriteBatch = "object_atlas_lamp_glow"
lightSource.quad = quadLoader:load("lamp_on")
lightSource.quadOff = quadLoader:load("lamp_off")
lightSource.lightQuad = quadLoader:load("lamp_flash")
lightSource.glowOffsetY = 3
lightSource.scaleX = 1
lightSource.scaleY = 1
lightSource.cost = 20
lightSource.xOffset = 0
lightSource.yOffset = 0
lightSource.illuminationRadius = 7
lightSource.onPurchasedSound = "place_lamp"
lightSource.addRotation = 0
lightSource.icon = "icon_lamp"
lightSource.realMonthlyCosts = {
	{
		cost = 6,
		disableWithNoEmployees = true,
		type = "electricity"
	}
}
lightSource.monthlyCosts = monthlyCost.new()
lightSource.defaultLightColor = color(251, 255, 237, 255)
lightSource.coldLightColor = color(219, 232, 255, 255)
lightSource.whiteLightColor = color(255, 255, 255, 255)
lightSource.colorOptions = {
	{
		text = _T("LAMP_COLOR_WARM", "Light color: warm"),
		color = lightSource.defaultLightColor
	},
	{
		text = _T("LAMP_COLOR_COLD", "Light color: cold"),
		color = lightSource.coldLightColor
	},
	{
		text = _T("LAMP_COLOR_WHITE", "Light color: white"),
		color = lightSource.whiteLightColor
	}
}

function lightSource:init()
	lightSource.baseClass.init(self)
	self:disableLightCasting()
	self:setLightColorOption(1)
	
	self.glowValue = math.randomf(0, math.pi)
	self.scaleValue = math.randomf(0, math.pi)
end

function lightSource:canRotate()
	return false
end

function lightSource:canShowPlacementSmoke()
	return false
end

function lightSource:getDrawColor()
	return 255, 255, 255, 150
end

function lightSource:getDrawAngles()
	return 0
end

function lightSource.adjustLightColorCallback(option)
	local lamp = option.tree.lamp
	local room = lamp:getRoom()
	local id = option.colorID
	local updateList = {}
	
	updateList[1] = lamp.colorOptions[id].color:saveRGB()
	
	for key, object in ipairs(room:getObjectsOfType(lamp:getObjectType())) do
		object:setLightColorOption(id)
		
		updateList[#updateList + 1] = tostring(object)
	end
	
	lightingManager:updateLightCasterColors(updateList)
end

function lightSource:fillInteractionComboBox(comboBox)
	comboBox.lamp = self
	
	for key, optionData in ipairs(lightSource.colorOptions) do
		local option = comboBox:addOption(0, 0, 0, 24, optionData.text, fonts.get("pix20"), lightSource.adjustLightColorCallback)
		
		option.colorID = key
	end
end

function lightSource:setLightColorOption(optionID)
	self.optionID = math.min(#self.colorOptions, optionID)
	self.lightColor = self.colorOptions[optionID].color
end

function lightSource:getTextureQuad()
	return self.castingLight and self.quad or self.quadOff
end

function lightSource:updateSprite()
	lightSource.baseClass.updateSprite(self)
	
	if self.visible and self.castingLight then
		self:updateLightSprite()
	else
		self:clearLightSprite()
	end
end

function lightSource:clearLightSprite()
	if self.lightSpriteID then
		self.glowBatch:deallocateSlot(self.lightSpriteID)
		
		self.lightSpriteID = nil
	end
end

function lightSource:updateLightSprite()
	local objectGrid = game.worldObject:getObjectGrid()
	local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, self.lightQuad)
	
	self.lightSpriteID = self.lightSpriteID or self.glowBatch:allocateSlot()
	
	local glowSine = math.sin(self.glowValue)
	local scaleSine = math.sin(self.scaleValue) * 0.5
	
	self.glowBatch:setColor(255, 255, 255, 75 + 25 * glowSine)
	self.glowBatch:updateSprite(self.lightSpriteID, self.lightQuad, x, y + self.glowOffsetY, rotation, 2 + scaleSine, 2 + scaleSine, xOff * 0.5, yOff * 0.5)
end

function lightSource:clearSprite()
	lightSource.baseClass.clearSprite(self)
	
	if self.lightSpriteID then
		self.glowBatch:deallocateSlot(self.lightSpriteID)
		
		self.lightSpriteID = nil
	end
end

function lightSource:_pickSpritebatches(lowerWallPresent)
	self:clearSprite()
	
	self.spriteBatch = spriteBatchController:getContainer(self.objectAtlas)
	self.glowBatch = spriteBatchController:getContainer(self.glowSpriteBatch)
	
	self:updateSprite()
end

function lightSource:referenceSpritebatches()
	table.insert(self.spriteBatches, self.spriteBatch)
	table.insert(self.spriteBatches, self.glowBatch)
end

function lightSource:selectForPurchase()
	self.rotation = walls.UP
	
	studio.expansion:setRotation(self.rotation)
end

function lightSource:onEmployeeEntered()
	lightSource.baseClass.onEmployeeEntered(self)
	self:updateSprite()
end

function lightSource:onEmployeeLeft()
	lightSource.baseClass.onEmployeeLeft(self)
	self:updateSprite()
end

function lightSource:save()
	local saved = lightSource.baseClass.save(self)
	
	saved.optionID = self.optionID
	
	return saved
end

function lightSource:load(data)
	lightSource.baseClass.load(self, data)
	self:setLightColorOption(data.optionID or 1)
end

function lightSource:draw()
	local realSpeed = timeline.realProgressTime
	
	self.glowValue = self.glowValue + realSpeed
	self.scaleValue = self.scaleValue + realSpeed * 0.5
	
	if self.castingLight then
		self:updateLightSprite()
	end
	
	if self.glowValue >= math.pi then
		self.glowValue = self.glowValue - math.pi
	end
	
	if self.scaleValue >= math.pi then
		self.scaleValue = self.scaleValue - math.pi
	end
end

objects.registerNew(lightSource, "light_source_base")
