local platformSpecSel = {}

platformSpecSel.portraitScale = 1
platformSpecSel.skinPanelSelectColor = color(168, 191, 162, 255)
platformSpecSel.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.SPECIALIST_SET
}

function platformSpecSel:setWrapWidth(w)
	self.wrapW = w
end

function platformSpecSel:setData(id, data)
	self.data = data
	self.specID = id
	self.portrait = self.data.portrait
	
	local specData = platformParts.registeredSpecialistsByID[id]
	
	self.spriteBatch = spriteBatchController:newSpriteBatch("gui_portrait_" .. id, "textures/spritesheets/portrait.png", 8, "static", 5, false, true, false, true)
	self.spriteBatchObj = self.spriteBatch:getSpritebatch()
	
	self.portrait:setupSpritebatch(self.spriteBatch)
	
	local offset = 67 * self.portraitScale + 5
	local wrapWidth = self.wrapW - offset
	
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:setPos(_S(offset), _S(3))
	self.descriptionBox:overwriteDepth(5)
	
	local scaledLineWidth = _S(wrapWidth - 20)
	
	self.descriptionBox:addTextLine(scaledLineWidth, gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format("NAME - SPEC", "NAME", names:getFullName(data.nameID, data.surnameID, data.background, data.female), "SPEC", specData.display), "bh18", nil, 2, wrapWidth)
	self.descriptionBox:addTextLine(scaledLineWidth, gui.genericGradientColor, _S(20), "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("SPECIALIST_SALARY", "Salary: $SALARY/month"), "SALARY", string.comma(specData:getCost())), "bh18", nil, -6, wrapWidth, "wad_of_cash", 22, 22)
	self.descriptionBox:addTextLine(scaledLineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(specData.description, "pix18", nil, 2, wrapWidth)
	
	local width = _S(120)
	
	self.available = platformParts:isSpecialistAvailable(data)
	
	self.descriptionBox:addSpaceToNextText(2)
	
	if self.available then
		self.descriptionBox:addTextLine(width, game.UI_COLORS.LIGHT_GREEN, nil, "weak_gradient_horizontal")
		self.descriptionBox:addText(_T("SPECIALIST_AVAILABLE", "Available!"), "bh18", game.UI_COLORS.LIGHT_GREEN, 2, wrapWidth)
	else
		self.descriptionBox:addTextLine(width, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("SPECIALIST_UNAVAILABLE", "Unavailable for TIME_PERIOD"), "TIME_PERIOD", timeline:getTimePeriodText(data.busyTime)), "bh18", game.UI_COLORS.RED, 2, wrapWidth)
	end
	
	self.selectButton = gui.create("SelectPlatformSpecialistButton", self)
	
	self.selectButton:setSize(100, 20)
	self.selectButton:setFont("bh18")
	self.selectButton:setText(_T("SELECT", "Select"))
	
	if not self.available then
		self.selectButton:setCanClick(false)
	end
end

function platformSpecSel:getSpecialist()
	return self.specID
end

function platformSpecSel:handleEvent(event, id)
	self.specSelected = id == self.specID
	
	if self.specSelected then
		self.selectButton:setText(_T("DESELECT", "Deselect"))
	else
		self.selectButton:setText(_T("SELECT", "Select"))
	end
	
	self:queueSpriteUpdate()
end

function platformSpecSel:onKill()
	spriteBatchController:removeSpriteBatchObject(self.spriteBatch)
end

function platformSpecSel:onSizeChanged()
	self.selectButton:setPos(self.w - self.selectButton.w - _S(6), self.h - self.selectButton.h - _S(6))
end

function platformSpecSel:isOn()
	return self.specSelected
end

function platformSpecSel:updateSprites()
	platformSpecSel.baseClass.updateSprites(self)
	self:setNextSpriteColor(0, 0, 0, 150)
	
	self.underPortrait = self:allocateSprite(self.underPortrait, "generic_1px", _S(5), _S(5), 0, 67 * self.portraitScale, self.rawH - 10, 0, 0, -0.05)
	
	local icon = self.specSelected and "checkbox_on" or "checkbox_off"
	
	self.activeCheckbox = self:allocateSprite(self.activeCheckbox, icon, self.selectButton.localX - _S(23), self.selectButton.localY, 0, 20, 20, 0, 0, -0.05)
end

function platformSpecSel:draw()
	self.spriteBatch:updateSprites()
	
	if self.available then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(150, 150, 150, 255)
	end
	
	love.graphics.draw(self.spriteBatchObj, _S(18), _S(34), 0, -0.33 * self.portraitScale, 0.33 * self.portraitScale)
end

gui.register("PlatformSpecialistSelection", platformSpecSel, "GenericElement")

platformSpecSel.skinPanelHoverColor = platformSpecSel.skinPanelFillColor
