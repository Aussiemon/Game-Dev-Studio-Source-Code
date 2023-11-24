local workplace = {}

workplace.tileWidth = 2
workplace.tileHeight = 2
workplace.class = "workplace"
workplace.lowestAtlas = "object_atlas_1"
workplace.lowestAtlasBetweenWalls = "object_atlas_1_between_walls"
workplace.computerAtlas = "object_atlas_2"
workplace.computerAtlasBetweenWalls = "object_atlas_2_between_walls"
workplace.foodSpritebatch = "object_atlas_2"
workplace.category = "office"
workplace.objectType = "workplace"
workplace.roomType = studio.ROOM_TYPES.OFFICE
workplace.display = _T("WORKPLACE", "Workplace")
workplace.description = _T("WORKPLACE_DESCRIPTION", "The tool of achieving greatness in the game development business.")
workplace.quad = quadLoader:load("computer_level_1")
workplace.deskQuad = quadLoader:load("desk")
workplace.chairQuad = quadLoader:load("chair")
workplace.scaleX = 1
workplace.scaleY = 1
workplace.baseCost = 200
workplace.sizeCategory = "unhousable"
workplace.requiresEntrance = true
workplace.preventsMovement = true
workplace.lightCaster = "workplace_caster"
workplace.inactiveMonthlyCosts = monthlyCost.new()
workplace.activeMonthlyCosts = monthlyCost.new()

workplace.activeMonthlyCosts:setCostTypes("electricity", 20)

workplace.lightColor = color(175, 195, 211, 255)

workplace.lightColor:lerp(0.2, 0, 0, 0, 255)

workplace.progression = {
	{
		cost = 200,
		xOffset = -4,
		icon = "icon_computer_level_1",
		yOffset = 6,
		date = {
			year = 1988,
			month = 1
		},
		quad = quadLoader:load("computer_level_1")
	},
	{
		cost = 400,
		xOffset = -7,
		icon = "icon_computer_level_2",
		yOffset = 2,
		date = {
			year = 1989,
			month = 6
		},
		quad = quadLoader:load("computer_level_2")
	},
	{
		cost = 800,
		xOffset = -10,
		icon = "icon_computer_level_3",
		yOffset = 0,
		date = {
			year = 1990,
			month = 2
		},
		quad = quadLoader:load("computer_level_3")
	},
	{
		cost = 1500,
		xOffset = -10,
		icon = "icon_computer_level_4",
		yOffset = 2,
		date = {
			year = 2000,
			month = 10
		},
		quad = quadLoader:load("computer_level_4")
	},
	{
		cost = 2000,
		xOffset = -10,
		icon = "icon_computer_level_5",
		yOffset = 0,
		date = {
			year = 2005,
			month = 2
		},
		quad = quadLoader:load("computer_level_5")
	},
	{
		cost = 2500,
		xOffset = -10,
		icon = "icon_computer_level_6",
		yOffset = 0,
		date = {
			year = 2010,
			month = 2
		},
		quad = quadLoader:load("computer_level_6")
	},
	{
		cost = 3000,
		xOffset = 0,
		icon = "icon_computer_level_7",
		yOffset = 3,
		date = {
			year = 2020,
			month = 2
		},
		quad = quadLoader:load("computer_level_7")
	},
	{
		cost = 3000,
		xOffset = 0,
		icon = "icon_computer_level_8",
		yOffset = 2,
		date = {
			year = 2025,
			month = 2
		},
		quad = quadLoader:load("computer_level_8")
	},
	{
		cost = 3000,
		xOffset = 0,
		icon = "icon_computer_level_9",
		yOffset = -2,
		date = {
			year = 2030,
			month = 2
		},
		quad = quadLoader:load("computer_level_9")
	}
}
workplace.ROTATION_TO_LIGHT_OFFSET = {
	[walls.UP] = {
		0,
		0
	},
	[walls.RIGHT] = {
		1,
		0
	},
	[walls.DOWN] = {
		0,
		1
	},
	[walls.LEFT] = {
		0,
		0
	}
}
workplace.ROTATION_TO_LIGHT_CAST_RANGE = {
	[walls.UP] = {
		1,
		0
	},
	[walls.RIGHT] = {
		0,
		1
	},
	[walls.DOWN] = {
		1,
		0
	},
	[walls.LEFT] = {
		0,
		1
	}
}

function workplace:init()
	workplace.baseClass.init(self)
	self:disableLightCasting()
end

function workplace:getLightCastCoordinates()
	local gridX, gridY = game.worldObject:getObjectGrid():worldToGrid(self.x, self.y)
	local off = workplace.ROTATION_TO_LIGHT_OFFSET[self.rotation]
	
	return gridX + off[1], gridY + off[2]
end

function workplace:getLightCastRange()
	local range = workplace.ROTATION_TO_LIGHT_CAST_RANGE[self.rotation]
	
	return range[1], range[2]
end

function workplace:switchSpriteBatches()
	self.miscSB, self.computerSB = studio.expansion:getSpriteSheetByID(self.textureID)
end

workplace.mouseW = 80
workplace.mouseH = 42

function workplace:getMouseBoundingBox()
	local rot = self.rotation
	
	if rot == walls.UP then
		return self.x + 8, self.y, self.mouseW, self.mouseH
	elseif rot == walls.DOWN then
		return self.x, self.y + self.height - self.mouseH, self.mouseW, self.mouseH
	elseif rot == walls.LEFT then
		return self.x, self.y + 8, self.mouseH, self.mouseW
	end
	
	return self.x + self.width - self.mouseH, self.y + 8, self.mouseH, self.mouseW
end

function workplace:returnSpritebatches()
	self:clearSprite()
	self:setupSpritebatches()
end

function workplace:setupSpritebatches()
	self:pickSpritebatch()
	
	self.atlasTexture = self.miscSB:getTexture()
	
	self:_setupSpritebatches()
end

function workplace:_pickSpritebatches(lowerWallPresent)
	local prevBatch = self.miscSB
	local newMiscBatch, newComputerBatch
	
	if lowerWallPresent then
		newMiscBatch, newComputerBatch = spriteBatchController:getContainer(self.lowestAtlasBetweenWalls), spriteBatchController:getContainer(self.computerAtlasBetweenWalls)
	else
		newMiscBatch, newComputerBatch = spriteBatchController:getContainer(self.lowestAtlas), spriteBatchController:getContainer(self.computerAtlas)
	end
	
	if newMiscBatch ~= prevBatch then
		self:clearSprite()
		
		if prevBatch then
			for key, sb in ipairs(self.spriteBatches) do
				sb:decreaseVisibility()
				
				self.spriteBatches[key] = nil
			end
		end
		
		self.miscSB = newMiscBatch
		self.computerSB = newComputerBatch
		
		self:updateSprite()
		
		if prevBatch then
			self:referenceSpritebatches()
			self:increaseVisibility()
		end
	else
		self.spriteBatch = newBatch
	end
end

function workplace:addCoffee()
	self:addProp("coffee_mug", workplace.foodSpritebatch, quadLoader:load("coffee_cup"), x, y, 0, 26, 22)
end

function workplace:removeCoffee()
	self:removeProp("coffee_mug")
end

function workplace:castLight(imageData, pixelX, pixelY)
	local clr = self.lightColor
	local r, g, b = imageData:getPixel(pixelX, pixelY)
	
	imageData:setPixel(pixelX, pixelY, math.max(r, clr.r), math.max(g, clr.g), math.max(b, clr.b), 255)
end

function workplace:getDeskQuad()
	return self.deskQuad
end

function workplace:getChairQuad()
	return self.chairQuad
end

function workplace:getFacingPosition()
	local x, y = self.x, self.y
	
	if self.rotation == walls.UP then
		return x, y + game.WORLD_TILE_HEIGHT
	elseif self.rotation == walls.DOWN then
		return x, y
	elseif self.rotation == walls.LEFT then
		return x + game.WORLD_TILE_WIDTH, y
	elseif self.rotation == walls.RIGHT then
		return x, y
	end
end

function workplace:getUpgradeAllText()
	return _T("UPGRADE_COMPUTERS_TO_LEVEL", "Upgrade computers to level LEVEL for COST")
end

function workplace:updateSprite()
	if self.visible then
		self.computerSprite = self.computerSprite or self.computerSB:allocateSlot()
		self.deskSprite = self.deskSprite or self.miscSB:allocateSlot()
		self.chairSprite = self.chairSprite or self.miscSB:allocateSlot()
		
		local r, g, b, a = self:getDrawColor()
		
		self.miscSB:setColor(r, g, b, a)
		
		local deskQuad = self:getDeskQuad()
		local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, deskQuad, nil, 20, -20)
		
		self.miscSB:updateSprite(self.deskSprite, deskQuad, math.round(x), math.round(y), rotation, self.scaleX, self.scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
		
		local chairQuad = self:getChairQuad()
		local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, chairQuad, walls.INVERSE_RELATION[self.rotation], 10, -10)
		
		self.miscSB:updateSprite(self.chairSprite, chairQuad, math.round(x), math.round(y), rotation, self.scaleX, self.scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
		self.computerSB:setColor(r, g, b, a)
		
		local progressionData = self.progression[self.progressionLevel]
		local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, nil, nil, 24, -24)
		
		self.computerSB:updateSprite(self.computerSprite, self:getTextureQuad(), math.round(x), math.round(y), rotation, self.scaleX, self.scaleY, math.round(xOff * 0.5 + progressionData.xOffset), math.round(yOff * 0.5 + progressionData.yOffset))
	end
end

function workplace:setupOutline()
	self.drawChairOutline = not self.assignedEmployee or not self.assignedEmployee:isOnWorkplace() or not self.assignedEmployee:isAvailable()
end

function workplace:resetOutline()
	self.drawChairOutline = false
end

function workplace:drawOutline()
	local progressionData = self.progression[self.progressionLevel]
	
	if self.drawChairOutline then
		local quad = self:getChairQuad()
		local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, quad, walls.INVERSE_RELATION[self.rotation], 10, -10)
		
		outlineShader:setupThickness(quad)
		love.graphics.draw(self.atlasTexture, quad, math.round(x), math.round(y), rotation, self.scaleX, self.scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
	end
	
	local quad = self:getDeskQuad()
	local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, quad, nil, 20, -20)
	
	outlineShader:setupThickness(quad)
	love.graphics.draw(self.atlasTexture, quad, math.round(x), math.round(y), rotation, self.scaleX, self.scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
	
	local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, nil, nil, 24, -24)
	local quad = self:getTextureQuad()
	
	outlineShader:setupThickness(quad)
	love.graphics.draw(self.atlasTexture, quad, math.round(x), math.round(y), rotation, self.scaleX, self.scaleY, math.round(xOff * 0.5 + progressionData.xOffset), math.round(yOff * 0.5 + progressionData.yOffset))
end

function workplace:clearSprite()
	if self.computerSprite then
		self.computerSB:deallocateSlot(self.computerSprite)
		
		self.computerSprite = nil
		
		self.miscSB:deallocateSlot(self.deskSprite)
		
		self.deskSprite = nil
		
		self.miscSB:deallocateSlot(self.chairSprite)
		
		self.chairSprite = nil
	end
end

function workplace:referenceSpritebatches()
	table.insert(self.spriteBatches, self.miscSB)
	table.insert(self.spriteBatches, self.computerSB)
end

function workplace:draw()
	if studio.expansion:isActive() then
		self:updateSprite()
	end
end

objects.registerNew(workplace, "workplace_object_base")
