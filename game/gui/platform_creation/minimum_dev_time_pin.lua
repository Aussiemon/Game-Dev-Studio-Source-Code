local minTime = {}

minTime.pinColor = color(229, 186, 105, 255)
minTime.pinColorEnough = color(205, 229, 169, 255)

function minTime:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("PLATFORM_DEV_TIME_DESCRIPTION", "The minimum required development time for the platform to have its hardware and software properly implemented."), "bh18", nil, 0, 400, "question_mark", 22, 22)
	self.descBox:centerToElement(self.parent)
end

function minTime:onMouseLeft()
	self:killDescBox()
end

function minTime:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "weak_gradient_horizontal_double", -_S(self.rawW * 2), 0, 0, self.rawW * 5, self.rawH, 0, 0, -0.15)
	
	if self.parent:isEnoughWork() then
		local clr = self.pinColor
		
		self:setNextSpriteColor(clr.r, clr.g, clr.b, clr.a)
	else
		local clr = self.pinColorEnough
		
		self:setNextSpriteColor(clr.r, clr.g, clr.b, clr.a)
	end
	
	self.pinSprite = self:allocateSprite(self.pinSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

gui.register("MinimumDevTimePin", minTime)
