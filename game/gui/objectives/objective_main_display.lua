local objectiveMainDisplay = {}

objectiveMainDisplay.iconSpacing = 1
objectiveMainDisplay.innerIconSpacing = 4
objectiveMainDisplay.textSpacing = 5
objectiveMainDisplay.panelColor = color(89, 109, 140, 255)

function objectiveMainDisplay:setObjective(obj)
	self.objective = obj
	self.name = self.objective:getName()
	
	local wrappedDesc, lineCount, textHeight = string.wrap(self.objective:getDescription(), self.descriptionFont, self.w - _S(50))
	
	self.description = wrappedDesc
	
	self:setHeight(22 + _US(textHeight))
end

function objectiveMainDisplay:initVisual()
	self.font = fonts.get("pix20")
	self.descriptionFont = fonts.get("bh18")
	self.fontHeight = self.font:getHeight()
end

function objectiveMainDisplay:updateSprites()
	local scaledSpacing = _S(objectiveMainDisplay.iconSpacing)
	local scaledInnerSpacing = _S(objectiveMainDisplay.innerIconSpacing)
	local totalSpacing = scaledSpacing + scaledInnerSpacing
	local totalSpacingUnscaled = objectiveMainDisplay.iconSpacing + objectiveMainDisplay.innerIconSpacing
	
	self:setNextSpriteColor(self.panelColor:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.2)
	
	local smallest = 40
	
	self.iconBackground = self:allocateSprite(self.iconBackground, "quest_icon_background", scaledSpacing, scaledSpacing, 0, smallest - objectiveMainDisplay.iconSpacing * 2, smallest - objectiveMainDisplay.iconSpacing * 2, 0, 0, -0.1)
	
	local icon = self.objective:getIcon()
	local quadStruct = quadLoader:getQuadStructure(icon)
	local scale = quadStruct:getScaleToSize(smallest - totalSpacingUnscaled * 2)
	local quadW = quadStruct.w * scale
	
	self.iconSprite = self:allocateSprite(self.iconSprite, icon, _S(smallest) * 0.5 - _S(quadW * 0.5), totalSpacing, 0, quadW, quadStruct.h * scale, 0, 0, -0.1)
	self.baseTextX = _S(smallest) + _S(objectiveMainDisplay.textSpacing) + scaledSpacing
	self.baseTextY = scaledSpacing
end

function objectiveMainDisplay:draw(w, h)
	local pCol = self:getStateColor()
	local tCol = game.UI_COLORS.WHITE
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.name, self.baseTextX, self.baseTextY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
	love.graphics.setFont(self.descriptionFont)
	love.graphics.printST(self.description, self.baseTextX, self.baseTextY + self.fontHeight, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

gui.register("ObjectiveMainDisplay", objectiveMainDisplay)
