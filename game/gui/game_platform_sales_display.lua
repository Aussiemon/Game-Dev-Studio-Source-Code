local platformSales = {}

platformSales.skinPanelFillColor = color(86, 104, 135, 255)
platformSales.skinPanelHoverColor = color(179, 194, 219, 255)
platformSales.skinTextFillColor = color(220, 220, 220, 255)
platformSales.skinTextHoverColor = color(240, 240, 240, 255)

function platformSales:init()
	platformSales.font = fonts.get("pix20")
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(5)
	self.descriptionBox:setFadeInSpeed(0)
end

function platformSales:setPlatformProject(platform, project)
	self.platform = platformShare:getPlatformByID(platform)
	self.icon = self.platform:getDisplayQuad()
	self.project = project
	
	local platformObj = self.platform
	local projectSales = project:getSales(platform)
	local wrapWidth = self.rawW - (self.rawH + 5)
	local lineWidth = self.w - (self.h + _S(20))
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(platformObj:getName(), "bh20", nil, 3, wrapWidth)
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("GAME_SOLD_COPIES_PLATFORM", "Sold SALES copies"), "SALES", string.roundtobignumber(projectSales)), "pix16", nil, 0, wrapWidth, "game_copies_sold", 20, 20)
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("GAME_REVENUE_PLATFORM", "Revenue: MONEY"), "MONEY", string.roundtobigcashnumber(project:getMoneyMade(platform))), "pix16", nil, 0, wrapWidth, "wad_of_cash_plus", 20, 20)
	self.descriptionBox:setX(self.h - _S(4))
end

function platformSales:fillInteractionComboBox(cbox)
	self.platform:fillInteractionComboBox(cbox)
end

function platformSales:onClick(x, y, key)
	if gui.mouseKeys.LEFT == key and self.platform.PLAYER then
		interactionController:startInteraction(self, x - _S(10), y - _S(10))
	end
end

function platformSales:getProject()
	return self.project
end

function platformSales:getPlatform()
	return self.platform
end

function platformSales:onMouseEntered()
	self:queueSpriteUpdate()
end

function platformSales:onMouseLeft()
	self:queueSpriteUpdate()
end

function platformSales:onSizeChanged()
	self.smallestAxis = math.min(self.rawW, self.rawH)
end

function platformSales:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
	
	local bgIconSize = self.smallestAxis - 4
	local quadName = self.icon
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(bgIconSize - 4)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local baseIconX = _S(5)
	local baseX, baseY = baseIconX - _S(2), _S(2)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, baseX, baseY, bgIconSize, bgIconSize, 4, -0.1)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL_2:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", baseX + _S(2), baseY + _S(2), 0, bgIconSize - 4, bgIconSize - 4, 0, 0, -0.1)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, baseX + _S(bgIconSize * 0.5 - w * 0.5), baseY + _S(bgIconSize * 0.5 - h * 0.5), 0, w, h, 0, 0, -0.05)
end

function platformSales:draw(w, h)
end

gui.register("GamePlatformSalesDisplay", platformSales)
