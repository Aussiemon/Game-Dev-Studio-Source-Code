local platformInfo = {}

platformInfo.skinTextFillColor = color(220, 220, 220, 255)
platformInfo.skinTextHoverColor = color(240, 240, 240, 255)
platformInfo.skinTextSelectColor = color(255, 255, 255, 255)
platformInfo.skinTextDisableColor = color(60, 60, 60, 255)
platformInfo.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.DISCONTINUED
}

function platformInfo:init()
	platformInfo.font = fonts.get("pix20")
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(100)
	self.descriptionBox:setFadeInSpeed(0)
end

function platformInfo:handleEvent(event, obj)
	if obj == self.platform then
		local catObj = projectsMenu.pastPlayerPlatforms
		
		if not catObj:isFolded() then
			catObj:addItem(self, true)
		else
			if self.curCategoryTitle then
				self.curCategoryTitle:removeItem(self)
			end
			
			catObj:addPendingPlatform(self.platform)
			self:kill()
		end
	end
end

function platformInfo:setPlatform(platform)
	self.platform = platform
	self.platformData = platform:getPlatformData()
	
	local platformData = self.platformData
	local wrapWidth = self.rawW - 10
	
	self.descriptionBox:addTextLine(_S(300), gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.platform:getName(), "bh22", nil, 4, wrapWidth)
	self.descriptionBox:addText(_format(_T("PLATFORM_MARKET_SHARE", "Market share: SHARE% (USERS users)"), "SHARE", math.round(self.platform:getMarketSharePercentage() * 100, 1), "USERS", string.roundtobignumber(platform:getMarketShare())), "pix20", nil, 0, wrapWidth, "percentage", 22, 22)
	
	local relDate = self.platform:getReleaseDate()
	
	if relDate then
		local year, month, passed
		
		if self.platform.PLAYER then
			year = timeline:getYear(relDate)
			month = timeline:getMonth(relDate)
			passed = timeline:getTimePeriodText(timeline.curTime - relDate)
		else
			year = platformData.releaseDate.year
			month = platformData.releaseDate.month
			passed = timeline:getTimePeriodText(timeline.curTime - platformData:getReleaseDateTime())
		end
		
		self.descriptionBox:addText(_format(_T("PLATFORM_RELEASE_DATE", "Released on: YEAR/MONTH (TIME ago)"), "YEAR", year, "TIME", passed, "MONTH", month), "pix20", nil, 0, wrapWidth, "clock_full", 22, 22)
	else
		self.descriptionBox:addText(_T("PLATFORM_NO_RELEASE_DATE", "Released on: N/A"), "pix20", nil, 0, wrapWidth, "clock_full", 22, 22)
	end
	
	self.descriptionBox:addText(_format(_T("PLATFORM_LICENSE_COST", "License cost: $COST"), "COST", string.comma(self.platform:getLicenseCost())), "bh20", nil, 0, wrapWidth, "wad_of_cash", 22, 22)
	self.descriptionBox:setPos(self.descriptionBox.h + _S(5), _S(3))
	self:setHeight(_US(self.descriptionBox.h))
end

function platformInfo:getPlatform()
	return self.platform
end

function platformInfo:fillInteractionComboBox(comboBox)
	self.platform:fillInteractionComboBox(comboBox)
end

function platformInfo:onMouseEntered()
	platformInfo.baseClass.onMouseEntered(self)
	gui:getElementByID(projectsMenu.ELEMENT_IDS.PLATFORM_INFO_DESCBOX):showDisplay(self.platform)
end

function platformInfo:onMouseLeft()
	platformInfo.baseClass.onMouseLeft(self)
	gui:getElementByID(projectsMenu.ELEMENT_IDS.PLATFORM_INFO_DESCBOX):hideDisplay()
end

function platformInfo:updateSprites()
	platformInfo.baseClass.updateSprites(self)
	
	local underSize = self.rawH - 8
	local quadName = self.platform:getDisplayQuad()
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(underSize - 8)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local scaledH = self:applyScaler(h)
	local basePos, basePosTwo = _S(4), _S(6)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.underIconBg = self:allocateRoundedRectangle(self.underIconBg, basePos, basePos, underSize, underSize, 4, 0.1)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL_3:unpack())
	
	self.underIconBg2 = self:allocateSprite(self.underIconBg2, "vertical_gradient_60", basePosTwo, basePosTwo, 0, underSize - 4, underSize - 4, 0, 0, 0.11)
	self.platformIcon = self:allocateSprite(self.platformIcon, quadName, _S(4 + underSize * 0.5 - w * 0.5), self.h * 0.5 - scaledH * 0.5, 0, w, h, 0, 0, 0.15)
end

function platformInfo:onClick(x, y, key)
	if interactionController:attemptHide(self.platform) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
end

function platformInfo:draw(w, h)
end

gui.register("PlatformInfoButton", platformInfo, "GenericElement")
