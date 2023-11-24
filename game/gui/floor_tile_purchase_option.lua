local floorTile = {}

floorTile.skinTextHoverColor = color(214, 233, 255, 255)
floorTile.skinTextFillColor = color(149.79999999999998, 163.1, 178.5, 255)
floorTile.skinTextSelectColor = floorTile.skinTextHoverColor
floorTile.inactiveIconColor = color(100, 100, 100, 255)
floorTile.skinPanelFillColor = color(36, 49, 63, 255)
floorTile.skinPanelHoverColor = color(55, 76, 96, 255)
floorTile.skinPanelSelectColor = color(75, 105, 132, 255)
floorTile.tileDisplayBackgroundSpacing = 3
floorTile.offsetToTileDisplay = 10
floorTile.singleTileDisplaySize = 45
floorTile.baseYOffset = 10

function floorTile:init()
	floorTile.font = fonts.get("pix20")
	self.visualDisplaySprites = {}
end

function floorTile:setPurchaseData(id)
	local data = floors.registeredByID[id]
	
	self.floorData = data
	self.id = id
	self.name = data.display
	self.cost = table.concatEasy("", "$", data.cost)
	self.quadName = data:getQuadName()
end

function floorTile:handleEvent(event, purchaseID)
	local expansion = studio.expansion
	
	if event == expansion.EVENTS.PURCHASE_ID_CHANGED and expansion:getConstructionMode() == expansion.CONSTRUCTION_MODE.FLOORS then
		self:queueSpriteUpdate()
	end
end

function floorTile:isOn()
	return studio.expansion:getPurchaseID(studio.expansion.CONSTRUCTION_MODE.FLOORS) == self.id
end

function floorTile:onClick(x, y, key)
	studio.expansion:setPurchaseID(self.id)
end

function floorTile:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	self:setupDescBox()
	self.descBox:centerToElement(self)
	self:queueSpriteUpdate()
end

function floorTile:setupDescBox()
	self.descBox:addText(self.name, "pix22", nil, 0, 600)
end

function floorTile:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function floorTile:onHide()
	if self.descBox then
		self.descBox:hide()
	end
end

function floorTile:onShow()
	if self.descBox then
		self.descBox:show()
	end
end

function floorTile:updateSprites()
	local scaledBaseOffset = _S(floorTile.baseYOffset)
	local panelColor = self:getStateColor()
	
	self:setNextSpriteColor(panelColor:unpack())
	
	self.baseRectangle = self:allocateSprite(self.baseRectangle, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.15)
	
	local tileSize = floorTile.singleTileDisplaySize - floorTile.offsetToTileDisplay * 2
	local scaledTileSize = math.floor(_S(tileSize))
	local scaledOffset = _S(floorTile.offsetToTileDisplay)
	local totalWidth = scaledTileSize * 3
	local scaledSpacing = _S(floorTile.tileDisplayBackgroundSpacing)
	local pR, pG, pB, pA = 0, 0, 0, 0
	
	if self:isOn() then
		pR, pG, pB, pA = 36, 47, 61, 255
	else
		pR, pG, pB, pA = 13, 17, 22, 255
	end
	
	self:setNextSpriteColor(pR, pG, pB, pA)
	
	self.roundedRectangle = self:allocateRoundedRectangle(self.roundedRectangle, scaledOffset - scaledSpacing, scaledOffset - scaledSpacing + scaledBaseOffset, tileSize * 3 + floorTile.tileDisplayBackgroundSpacing * 2, tileSize + floorTile.tileDisplayBackgroundSpacing * 2, 4, -0.12)
	
	local iconR, iconG, iconB, iconA = 0, 0, 0, 0
	
	if self:isOn() or self:isMouseOver() then
		iconR, iconG, iconB, iconA = 255, 255, 255, 255
	else
		iconR, iconG, iconB, iconA = self.inactiveIconColor:unpack()
	end
	
	for i = 1, 3 do
		self:setNextSpriteColor(iconR, iconG, iconB, iconA)
		
		self.visualDisplaySprites[i] = self:allocateSprite(self.visualDisplaySprites[i], self.quadName, scaledOffset + (i - 1) * scaledTileSize, scaledOffset + scaledBaseOffset, 0, tileSize, tileSize, 0, 0, -0.1)
	end
	
	local cashDisplayX = scaledOffset - scaledSpacing
	local cashDisplayY = scaledOffset + scaledSpacing * 2 + scaledTileSize + scaledBaseOffset
	local cashDisplayW = tileSize * 3 + floorTile.tileDisplayBackgroundSpacing * 2
	local cashDisplayH = tileSize + floorTile.tileDisplayBackgroundSpacing * 2
	local scaledDisplayH = _S(cashDisplayH)
	
	self:setNextSpriteColor(pR, pG, pB, pA)
	
	self.cashRoundedRectangle = self:allocateRoundedRectangle(self.cashRoundedRectangle, cashDisplayX, cashDisplayY, cashDisplayW, cashDisplayH, 4, -0.12)
	
	local cashWadSize = cashDisplayH - 6
	local scaledHalfWadSize = _S(cashWadSize) * 0.5
	local cashWadDisplayX = cashDisplayX + _S(3)
	
	self.textX = cashWadDisplayX + _S(cashWadSize) + _S(3)
	self.textY = cashDisplayY + scaledDisplayH * 0.5 - self.font:getHeight() * 0.5
	self.cashWadSprite = self:allocateSprite(self.cashWadSprite, "wad_of_cash", cashWadDisplayX, cashDisplayY + scaledDisplayH * 0.5 - scaledHalfWadSize, 0, cashWadSize, cashWadSize, 0, 0, -0.1)
end

function floorTile:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.cost, self.textX, self.textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

gui.register("FloorTilePurchaseOption", floorTile)
