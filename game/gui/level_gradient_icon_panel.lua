local levelGradient = {}

levelGradient.barSizeHorizontalOffset = 180
levelGradient.barSizeVerticalOffset = 6
levelGradient.fillingSpacing = 2
levelGradient.levelDisplayTextColor = color(155, 188, 232, 255)
levelGradient.expTextFont = "bh18"
levelGradient.expText = ""
levelGradient.expBar = true

function levelGradient:setEmployee(employee)
	self.employee = employee
	self.expText = string.easyformatbykeys(_T("LEVEL_UP_PROGRESS", "CUREXP/NEXTEXP EXP"), "CUREXP", math.floor(self.employee:getExperience()), "NEXTEXP", self.employee:getExperienceToLevelup())
end

function levelGradient:updateFont()
	levelGradient.baseClass.updateFont(self)
end

function levelGradient:updateTextDimensions()
	levelGradient.baseClass.updateTextDimensions(self)
	
	self.expTextFontObject = fonts.get(self.expTextFont)
	self.expTextFontHeight = self.expTextFontObject:getHeight()
	self.expTextY = self.h * 0.5 - self.expTextFontHeight * 0.5
	self.expTextX = self.w - _S(self.barSizeVerticalOffset) * 2 - self.expTextFontObject:getWidth(self.expText)
end

function levelGradient:postResolutionChange()
	levelGradient.baseClass.postResolutionChange(self)
end

function levelGradient:setDisplayExpBar(expBar)
	self.expBar = expBar
end

function levelGradient:updateSprites()
	levelGradient.baseClass.updateSprites(self)
	
	if self.expBar then
		local w, h = self.rawW - self.barSizeHorizontalOffset - self.barSizeVerticalOffset, self.rawH - self.barSizeVerticalOffset * 2
		local scaledHorOffset = _S(self.barSizeHorizontalOffset)
		local scaledVertOffset = _S(self.barSizeVerticalOffset)
		local scaledFillingOffset = _S(self.fillingSpacing)
		local x, y = _S(self.rawW - w - self.barSizeVerticalOffset), scaledVertOffset
		
		self:setNextSpriteColor(0, 3, 0, 255)
		
		self.outerLevelBarSprite = self:allocateSprite(self.outerLevelBarSprite, "generic_1px", x, y, 0, w, h, 0, 0, -0.1)
		
		local innerX, innerY = x + scaledFillingOffset, y + scaledFillingOffset
		local innerW, innerH = w - self.fillingSpacing * 2, h - self.fillingSpacing * 2
		
		self:setNextSpriteColor(40, 40, 40, 255)
		
		self.innerLevelBarSprite = self:allocateSprite(self.innerLevelBarSprite, "generic_1px", innerX, innerY, 0, innerW, innerH, 0, 0, -0.1)
		
		local progress = math.floor(self.employee:getExperience()) / self.employee:getExperienceToLevelup()
		
		self:setNextSpriteColor(132, 160, 206, 255)
		
		self.barFillingSprite = self:allocateSprite(self.barFillingSprite, "vertical_gradient_75", innerX, innerY, 0, innerW * progress, innerH, 0, 0, -0.1)
	end
end

function levelGradient:draw(w, h)
	levelGradient.baseClass.draw(self, w, h)
	
	if self.expBar then
		local r, g, b, a = self.levelDisplayTextColor:unpack()
		
		love.graphics.setFont(fonts.get(self.expTextFont))
		love.graphics.printST(self.expText, self.expTextX, self.expTextY, r, g, b, a, 61, 74, 91, 255)
	end
end

gui.register("LevelGradientIconPanel", levelGradient, "GradientIconPanel")
