local descboxGradientIconText = {}

descboxGradientIconText.GRADIENT_HOVER_COLOR = color(255, 202, 96, 100)
descboxGradientIconText.BOOST_TEXT_COLOR = color(215, 255, 201, 255)

function descboxGradientIconText:getGradientColor()
	if self:isMouseOver() then
		return self.GRADIENT_HOVER_COLOR
	end
	
	return self.GRADIENT_COLOR
end

function descboxGradientIconText:getBoostTextColor()
	return self.BOOST_TEXT_COLOR
end

function descboxGradientIconText:onMouseEntered()
	descboxGradientIconText.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self:addTextToDescbox()
	self.descBox:centerToElement(self)
end

function descboxGradientIconText:addTextToDescbox()
end

function descboxGradientIconText:onMouseLeft()
	descboxGradientIconText.baseClass.onMouseLeft(self)
	self:queueSpriteUpdate()
	self:killDescBox()
end

function descboxGradientIconText:onKill()
	self:killDescBox()
end

gui.register("DescboxGradientIconTextDisplay", descboxGradientIconText, "GradientIconTextDisplay")
