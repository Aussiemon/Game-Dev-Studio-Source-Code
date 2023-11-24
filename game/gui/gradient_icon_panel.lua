local gradientIconPanel = {}

gradientIconPanel.backdropSize = 34
gradientIconPanel.iconSize = 32
gradientIconPanel.backdropVisible = true
gradientIconPanel.textPad = 5
gradientIconPanel.gradientPad = 4
gradientIconPanel.font = "pix20"
gradientIconPanel.text = ""
gradientIconPanel.textColor = color(255, 255, 255, 255)
gradientIconPanel.iconColor = color(255, 255, 255, 255)
gradientIconPanel.skinPanelHoverTextColor = color(255, 202, 96, 255)
gradientIconPanel.iconOffsetX = 0
gradientIconPanel.iconOffsetY = 0
gradientIconPanel.baseW = 0
gradientIconPanel.baseH = 0
gradientIconPanel.descBoxWrapWidth = 400
gradientIconPanel.backdropIcon = "profession_backdrop"
gradientIconPanel.gradientColor = color(0, 0, 0, 255)

function gradientIconPanel:init()
	self:updateFont()
	self:setIconSize(self.iconSize)
end

function gradientIconPanel:setBaseSize(w, h)
	self.baseW = w
	self.baseH = h
end

function gradientIconPanel:setFont(font)
	self.font = font
	
	self:updateFont()
	self:adjustSize()
end

function gradientIconPanel:setText(text)
	self.text = text
	
	self:updateTextDimensions()
end

function gradientIconPanel:updateTextDimensions()
	self.textDrawHeight = self.h * 0.5 - self.fontHeight * 0.5
end

function gradientIconPanel:setHoverText(hoverText)
	if not hoverText then
		self:killDescBox()
	end
	
	self.hoverText = hoverText
end

function gradientIconPanel:onMouseEntered()
	self:initDescbox()
end

function gradientIconPanel:flickerGradient(targetColor, speed)
	if not self.curFlicker then
		self.curFlicker = color(255, 255, 255, 255)
	end
	
	self.curFlicker:setColor(targetColor:getColor())
	
	self.flickerSpeed = speed or 1
	self.flickerProgress = 0
	self.flickerColor = targetColor
end

function gradientIconPanel:think()
	local prog = self.flickerProgress
	
	if prog then
		if prog < 1 then
			self.flickerProgress = math.approach(prog, 1, frameTime * self.flickerSpeed)
			
			self:queueSpriteUpdate()
		else
			self.flickerProgress = nil
		end
	end
end

function gradientIconPanel:initDescbox()
	if self:canInitDescBox() then
		self.descBox = gui.create("GenericDescbox")
		
		local wrapWidth = self.descBoxWrapWidth
		
		if self.hoverText then
			if type(self.hoverText) == "string" then
				self.descBox:addText(self.hoverText, "pix18", nil, 0, wrapWidth)
			else
				for key, data in ipairs(self.hoverText) do
					local icon = data.icon
					
					if type(icon) == "table" then
						icon = table.copy(icon)
					end
					
					self.descBox:addText(data.text, data.font or "pix18", data.textColor, data.lineSpace, data.wrapWidth or self.descBoxWrapWidth, icon, data.iconWidth, data.iconHeight)
				end
			end
		end
		
		self:setupDescbox(wrapWidth)
		self.descBox:positionToMouse(_S(10), _S(10))
		self:queueSpriteUpdate()
	end
end

function gradientIconPanel:setupDescbox()
end

function gradientIconPanel:canInitDescBox()
	return self.hoverText
end

function gradientIconPanel:onMouseLeft()
	if self.descBox then
		self:killDescBox()
		self:queueSpriteUpdate()
	end
end

function gradientIconPanel:setTextPad(pad)
	self.textPad = pad
end

function gradientIconPanel:setTextColor(clr)
	self.textColor = clr
end

function gradientIconPanel:getTextX()
	return _S(math.max(self:getBackdropSpriteSize(), self:getIconSize()) + self.textPad + self.gradientPad * 0.5)
end

function gradientIconPanel:getTextY()
	return self.textDrawHeight
end

function gradientIconPanel:setBackdropSize(size)
	self.backdropSize = size
	
	self:adjustSize()
end

function gradientIconPanel:setBackdropVisible(vis)
	self.backdropVisible = vis
	
	if not vis then
		self.backdropSize = 0
	end
end

function gradientIconPanel:setGradientPad(pad)
	self.gradientPad = pad
	
	self:adjustSize()
end

function gradientIconPanel:postResolutionChange()
	self:updateFont()
end

function gradientIconPanel:updateFont()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
	
	self:updateTextDimensions()
end

function gradientIconPanel:onSizeChanged()
	self:updateTextDimensions()
end

function gradientIconPanel:setIconColor(iconColor)
	self.iconColor = iconColor
end

function gradientIconPanel:setIcon(icon)
	self.icon = icon
	
	self:queueSpriteUpdate()
end

function gradientIconPanel:setIconSize(sizeX, sizeY, backdropSize)
	if backdropSize then
		self:setBackdropSize(backdropSize)
	end
	
	self.iconSize = nil
	self.iconSizeX = nil
	self.iconSizeY = nil
	
	if sizeX and sizeY then
		self.iconSizeX = sizeX
		self.iconSizeY = sizeY
	else
		self.iconSize = sizeX
		
		if self.icon then
			local quadStruct = quadLoader:getQuadStructure(self.icon)
			local scaler = quadStruct:getScaleToSize(sizeX)
			
			self.iconSizeX = quadStruct.w * scaler
			self.iconSizeY = quadStruct.h * scaler
			
			local scaledBackdrop = _S(self.backdropSize)
			
			self.xOffset = scaledBackdrop * 0.5 - _S(self.iconSizeX) * 0.5
		end
	end
	
	self.iconRenderW = self.iconSizeX or self.iconSize
	self.iconRenderH = self.iconSizeY or self.iconSize
	
	self:adjustSize()
end

function gradientIconPanel:centerIcon()
	local scaledBackdrop = _S(self.backdropSize)
	
	self.xOffset = scaledBackdrop * 0.5 - _S(self.iconSizeX) * 0.5
	self.iconOffsetY = scaledBackdrop * 0.5 - _S(self.iconSizeY) * 0.5
end

function gradientIconPanel:getBackdropSpriteSize()
	return math.max(self.rawH, self.backdropSize)
end

function gradientIconPanel:getIconSize()
	return self.iconRenderW, self.iconRenderH
end

function gradientIconPanel:setIconOffset(offX, offY)
	self.iconOffsetX, self.iconOffsetY = offX, offY
end

function gradientIconPanel:setIconYOffset(offY)
	self.iconOffsetY = offY
end

function gradientIconPanel:getIconOffset()
	return self.iconOffsetX, self.iconOffsetY
end

function gradientIconPanel:setBackdropIcon(icon)
	self.backdropIcon = icon
end

function gradientIconPanel:setGradientColor(clr)
	self.gradientColor = clr or gradientIconPanel.gradientColor
end

function gradientIconPanel:updateSprites()
	if not self.descBox then
		local prog = self.flickerProgress
		
		if prog and prog < 1 then
			local clr = self.gradientColor
			
			self:setNextSpriteColor(self.flickerColor:lerpResult(self.flickerProgress, clr.r, clr.g, clr.b, clr.a))
		else
			local clr = self.gradientColor
			
			self:setNextSpriteColor(clr.r, clr.g, clr.b, clr.a)
		end
	else
		self:setNextSpriteColor(self.skinPanelHoverTextColor:unpack())
	end
	
	self.backgroundGradientSprite = self:allocateSprite(self.backgroundGradientSprite, "weak_gradient_horizontal", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local scaledGradientPad = _S(self.gradientPad)
	local halfGradientPad = scaledGradientPad * 0.5
	
	if self.backdropVisible then
		local backdropSize = self:getBackdropSpriteSize()
		
		self.iconBackdropSprite = self:allocateSprite(self.iconBackdropSprite, self.backdropIcon, halfGradientPad, halfGradientPad, 0, backdropSize - self.gradientPad, backdropSize - self.gradientPad, 0, 0, -0.1)
	end
	
	if self.icon then
		local offX, offY = self:getIconOffset()
		local iconW, iconH = self:getIconSize()
		
		self:setNextSpriteColor(self.iconColor:unpack())
		
		local x = (self.xOffset or _S(offX)) + halfGradientPad
		
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, x, _S(offY) + halfGradientPad, 0, iconW, iconH, 0, 0, -0.1)
	end
end

function gradientIconPanel:adjustSize()
	local elementWidth = math.max((self.iconSizeX or self.iconSize) + self.gradientPad, self.fontHeight, _US(self.baseW))
	local elementHeight = math.max((self.iconSizeY or self.iconSize) + self.gradientPad, _US(self.fontHeight), self.backdropSize + self.gradientPad)
	
	self:setWidth(elementWidth)
	self:setHeight(elementHeight)
end

function gradientIconPanel:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self:getTextX(), self:getTextY(), self.textColor:unpack())
end

gui.register("GradientIconPanel", gradientIconPanel)
