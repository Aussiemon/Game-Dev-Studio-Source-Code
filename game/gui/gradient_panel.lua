local gradientPanel = {}

gradientPanel.textPad = 5
gradientPanel.font = "pix20"
gradientPanel.text = ""
gradientPanel.textColor = color(255, 255, 255, 255)
gradientPanel.gradientColor = color(0, 0, 0, 255)
gradientPanel.skinPanelHoverTextColor = color(255, 202, 96, 255)

function gradientPanel:init()
	self:updateFont()
end

function gradientPanel:setFont(font)
	self.font = font
	
	self:updateFont()
end

function gradientPanel:setText(text)
	self.text = text
	
	self:updateTextDimensions()
end

function gradientPanel:updateTextDimensions()
	self.textDrawHeight = self.h * 0.5 - self.fontHeight * 0.5
end

function gradientPanel:setHoverText(hoverText)
	if not hoverText then
		self:killDescBox()
	end
	
	self.hoverText = hoverText
end

function gradientPanel:onMouseEntered()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(self.hoverText, "pix20", nil, 0, 600)
		self.descBox:centerToElement(self)
		self:queueSpriteUpdate()
	end
end

function gradientPanel:onMouseLeft()
	if self.hoverText then
		self:killDescBox()
		self:queueSpriteUpdate()
	end
end

function gradientPanel:setTextPad(pad)
	self.textPad = pad
end

function gradientPanel:setTextColor(clr)
	self.textColor = clr
end

function gradientPanel:getTextX()
	return _S(self.textPad)
end

function gradientPanel:getTextY()
	return self.textDrawHeight
end

function gradientPanel:postResolutionChange()
	self:updateFont()
end

function gradientPanel:updateFont()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
	
	self:updateTextDimensions()
end

function gradientPanel:onSizeChanged()
	self:updateTextDimensions()
end

function gradientPanel:setGradientColor(clr)
	self.gradientColor = clr
	
	self:queueSpriteUpdate()
end

function gradientPanel:updateSprites()
	if not self.descBox then
		self:setNextSpriteColor(self.gradientColor:unpack())
	else
		self:setNextSpriteColor(self.skinPanelHoverTextColor:unpack())
	end
	
	self.backgroundGradientSprite = self:allocateSprite(self.backgroundGradientSprite, "weak_gradient_horizontal", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function gradientPanel:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self:getTextX(), self:getTextY(), self.textColor:unpack())
end

gui.register("GradientPanel", gradientPanel)
