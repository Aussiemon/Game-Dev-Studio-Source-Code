local objectOption = {}

objectOption.objectDisplaySize = 50
objectOption.iconWidth = 60
objectOption.iconHeight = 50

function objectOption:init()
	objectOption.baseClass.init(self)
	
	self.progressionLevel = nil
end

function objectOption:setPurchaseData(category, id)
	local categoryContainer = objectCategories:getCategoryContents(category)
	local data = categoryContainer[id]
	
	self.category = category
	self.objectData = data
	self.purchaseID = id
	self.cost = _format("$COST", "COST", string.roundtobignumber(data:getCost(self.progressionLevel)))
	
	local icon = data:getIcon()
	
	if icon then
		self.quad = quadLoader:getQuad(icon)
		self.quadName = icon
	else
		self.quad = data:getTextureQuad(self.progressionLevel)
		self.quadName = quadLoader:getQuadObjectStructure(self.quad).name
	end
	
	local smallest = math.min(self.w, self.h) - 10
	
	self.textHeight = textHeight
	self.iconScale = self.quad:getScaleToSize(self.iconHeight - 4)
	self.iconW, self.iconH = self.quad:getSize()
	self.iconW, self.iconH = self.iconW * self.iconScale, self.iconH * self.iconScale
end

function objectOption:handleEvent(event, newID, oldID)
	local expansion = studio.expansion
	
	if event == expansion.EVENTS.PURCHASE_ID_CHANGED and expansion:getConstructionMode() == expansion.CONSTRUCTION_MODE.OBJECTS and (newID == self.purchaseID or oldID == self.purchaseID) then
		self:queueSpriteUpdate()
	end
end

function objectOption:setProgression(level)
	self.progressionLevel = math.max(level, 1)
end

function objectOption:updateSprites()
end

function objectOption:setupDescBox()
	local wrapWidth = 400
	
	self.descBox:addText(self.objectData.display, "bh22", nil, 4, wrapWidth)
	self.objectData:setupPurchaseDescbox(self.descBox, wrapWidth)
end

function objectOption:onClick(x, y, key)
	if studio.expansion:getMovedObject() then
		return 
	end
	
	studio.expansion:setPurchaseID(self.purchaseID)
	self:queueSpriteUpdate()
	events:fire(studio.expansion.EVENTS.CLICKED_OBJECT_OPTION)
end

function objectOption:updateSprites()
	local scaledBaseOffset = _S(self.baseYOffset)
	local panelColor = self:getStateColor()
	
	self:setNextSpriteColor(panelColor:unpack())
	
	self.baseRectangle = self:allocateSprite(self.baseRectangle, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.15)
	
	local tileSize = self.singleTileDisplaySize - self.offsetToTileDisplay * 2
	local scaledTileSize = math.floor(_S(tileSize))
	local scaledOffset = _S(self.offsetToTileDisplay)
	local scaledSpacing = _S(self.tileDisplayBackgroundSpacing)
	local pR, pG, pB, pA = 0, 0, 0, 0
	
	if self:isOn() then
		pR, pG, pB, pA = 36, 47, 61, 255
	else
		pR, pG, pB, pA = 13, 17, 22, 255
	end
	
	local scaledRoundWidth = _S(self.iconWidth)
	local scaledRoundHeight = _S(self.iconHeight)
	local baseRoundY = _S(5)
	
	self:setNextSpriteColor(pR, pG, pB, pA)
	
	self.roundedRectangle = self:allocateRoundedRectangle(self.roundedRectangle, self.w * 0.5 - scaledRoundWidth * 0.5, baseRoundY, self.iconWidth, self.iconHeight, 4, -0.12)
	
	if self:isOn() or self:isMouseOver() then
		self:setNextSpriteColor(255, 255, 255, 255)
	else
		self:setNextSpriteColor(100, 100, 100, 255)
	end
	
	self.objectSprite = self:allocateSprite(self.objectSprite, self.quadName, self.w * 0.5 - _S(self.iconW) * 0.5, baseRoundY + scaledRoundHeight * 0.5 - _S(self.iconH) * 0.5, 0, self.iconW, self.iconH, 0, 0, -0.1)
	
	local cashDisplayW = tileSize * 3 + self.tileDisplayBackgroundSpacing * 2
	local cashDisplayH = tileSize + self.tileDisplayBackgroundSpacing * 2
	local scaledDisplayH = _S(cashDisplayH)
	local cashDisplayX = scaledOffset - scaledSpacing
	local cashDisplayY = self.h - scaledDisplayH - _S(5)
	
	self:setNextSpriteColor(pR, pG, pB, pA)
	
	self.cashRoundedRectangle = self:allocateRoundedRectangle(self.cashRoundedRectangle, cashDisplayX, cashDisplayY, cashDisplayW, cashDisplayH, 4, -0.12)
	
	local cashWadSize = cashDisplayH - 6
	local scaledHalfWadSize = _S(cashWadSize) * 0.5
	local cashWadDisplayX = cashDisplayX + _S(3)
	
	self.textX = cashWadDisplayX + _S(cashWadSize) + _S(3)
	self.textY = cashDisplayY + self.font:getHeight() * 0.25 + _S(1)
	self.cashWadSprite = self:allocateSprite(self.cashWadSprite, "wad_of_cash", cashWadDisplayX, cashDisplayY + scaledDisplayH * 0.5 - scaledHalfWadSize, 0, cashWadSize, cashWadSize, 0, 0, -0.1)
end

function objectOption:isOn()
	return studio.expansion:getPurchaseID(studio.expansion.CONSTRUCTION_MODE.OBJECTS) == self.purchaseID
end

function objectOption:draw(w, h)
	local expansion = studio.expansion
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.cost, self.textX, self.textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

gui.register("ObjectPurchaseButton", objectOption, "WallPurchaseOption")
