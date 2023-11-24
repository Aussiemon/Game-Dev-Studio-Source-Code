local serverUpgrade = {}

serverUpgrade.topFont = "pix20"
serverUpgrade.capacityFont = "bh18"
serverUpgrade.buttonSize = 20
serverUpgrade.iconSize = 70
serverUpgrade.realIconSize = serverUpgrade.iconSize - 6
serverUpgrade.loadIconSize = 20

function serverUpgrade:setObjectList(list)
	self.objectList = list
	
	local object = list[1]
	
	self.level = object:getProgression()
	self.capacity = object:getCapacityChange()
	
	self:updateText()
	
	self.topFontObject = fonts.get(self.topFont)
	self.capacityFontObject = fonts.get(self.capacityFont)
	self.capacityFontHeight = self.capacityFontObject:getHeight()
	self.textX = _S(self.iconSize)
	self.textY = _S(3)
	self.capacityTextX = self.textX + _S(self.loadIconSize)
	self.capacityTextY = self.textY + self.topFontObject:getHeight() + _S(2)
	
	local icon = object.progression[self.level].icon
	
	self.icon = icon
	
	local data = quadLoader:getQuadStructure(icon)
	local scaler = data:getScaleToSize(self.realIconSize)
	
	self.iconW, self.iconH = data.w * scaler, data.h * scaler
	
	self:updateUpgradeText()
end

function serverUpgrade:updateUpgradeText()
	local maxLevel = self.objectList[1]:getLatestProgression()
	
	if maxLevel > self.level then
		self.upgradeTextColor = game.UI_COLORS.GREEN
		self.upgradeText = _T("UPGRADE_AVAILABLE", "Upgrade available!")
	else
		self.upgradeTextColor = game.UI_COLORS.WHITE
		self.upgradeText = _T("NO_UPGRADE_AVAILABLE", "No upgrade available")
	end
end

function serverUpgrade:addToObjectList(object)
	table.insert(self.objectList, object)
	self:updateText()
end

function serverUpgrade:getLevel()
	return self.level
end

function serverUpgrade:createUpgradeButton(lock)
	self.upgradeButton = gui.create("UpgradeServerButton", self)
	
	self.upgradeButton:setSize(self.buttonSize, self.buttonSize)
	self.upgradeButton:setIcon("increase")
	
	if lock then
		self.upgradeButton:setCanClick(false)
	end
end

function serverUpgrade:killUpgradeButton()
	self.upgradeButton:kill()
	
	self.upgradeButton = nil
end

function serverUpgrade:onUpgrade(upgradedObject, index)
	table.remove(self.objectList, index)
	upgradedObject:upgradeObject()
	self:updateText()
end

function serverUpgrade:onSizeChanged()
	if self.upgradeButton then
		self:adjustButtonPosition()
	end
end

function serverUpgrade:adjustButtonPosition()
	local x, y = self.textX + _S(2), self.capacityTextY + self.capacityFontHeight + _S(5)
	
	self.upgradeButton:setPos(x, y)
	
	self.upgradeTextX = x + self.upgradeButton.w + _S(4)
	self.upgradeTextY = y + self.upgradeButton.h * 0.5 - self.capacityFontHeight * 0.5
end

function serverUpgrade:getObjectList()
	return self.objectList
end

function serverUpgrade:updateText()
	self.topText = _format(_T("SERVER_RACK_LEVEL", "Server rack - level LEVEL (xAMOUNT)"), "LEVEL", self.level, "AMOUNT", #self.objectList)
	self.capacityText = _format(_T("TOTAL_SERVER_CAPACITY", "Total capacity: CAPACITY pts."), "CAPACITY", string.comma(self.capacity * #self.objectList))
end

function serverUpgrade:updateSprites()
	serverUpgrade.baseClass.updateSprites(self)
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "weak_gradient_horizontal", self.textX, self.textY, 0, self.rawW - (self.iconSize + 9), self.rawH - 6, 0, 0, -0.1)
	self.loadSprite = self:allocateSprite(self.loadSprite, "server_load", self.textX, self.capacityTextY, 0, self.loadIconSize, self.loadIconSize, 0, 0, -0.08)
	
	local x, y = _S(3), _S(3)
	
	if self:isMouseOver() then
		self:setNextSpriteColor(36, 47, 61, 200)
	else
		self:setNextSpriteColor(13, 17, 22, 255)
	end
	
	self.iconBackSprite = self:allocateSprite(self.iconBackSprite, "generic_1px", x, y, 0, self.realIconSize, self.realIconSize, 0, 0, -0.08)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, x + _S(self.realIconSize * 0.5 - self.iconW * 0.5), y, 0, self.iconW, self.iconH, 0, 0, -0.05)
end

function serverUpgrade:draw(w, h)
	local x = _S(2)
	
	love.graphics.setFont(self.topFontObject)
	love.graphics.printST(self.topText, self.textX + x, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
	love.graphics.setFont(self.capacityFontObject)
	love.graphics.printST(self.capacityText, self.capacityTextX + x, self.capacityTextY, 255, 255, 255, 255, 0, 0, 0, 255)
	love.graphics.setFont(self.capacityFontObject)
	
	local clr = self.upgradeTextColor
	local r, g, b, a = clr.r, clr.g, clr.b, clr.a
	
	love.graphics.printST(self.upgradeText, self.upgradeTextX, self.upgradeTextY, r, g, b, a, 0, 0, 0, 255)
end

gui.register("ServerUpgradeElement", serverUpgrade, "GenericElement")
