local frame = {}

frame.buttonPad = 6
frame.buttonSize = 18
frame.offsetX = 10
frame.offsetY = 5
frame.canPropagateKeyPress = true
frame.setFontLayoutPerform = true
frame.fadeInSpeed = 4
frame.moveSpeed = 0.5
frame.skinTextFillColor = color(220, 220, 220, 255)
frame.skinTextHoverColor = color(220, 220, 220, 255)
frame.closeButtonClass = "FrameCloseButton"
frame.title = "Frame title"

function frame:init(closeButtonClass)
	self:createCloseButton(closeButtonClass)
	
	self.font = fonts.get("pix14")
	self.alpha = 0
end

function frame:setFadeIn(fade)
	self.fadeIn = fade
end

function frame:createCloseButton(closeButtonClass)
	self.closeButton = gui.create(closeButtonClass or self.closeButtonClass, self)
	
	self.closeButton:setSize(self.buttonSize, self.buttonSize)
	self.closeButton:setFrame(self)
end

function frame:getCloseButton()
	return self.closeButton
end

function frame:setFadeInSpeed(speed)
	self.fadeInSpeed = speed
end

function frame:setFont(font)
	if type(font) == "string" then
		self.font = fonts.get(font)
	else
		self.font = font
	end
	
	self.textWidth = self.font:getWidth(self.title)
	self.fontHeight = self.font:getHeight()
	
	local newSize = self.buttonSize
	
	if newSize < self.fontHeight + _S(2) then
		newSize = _US(self.fontHeight)
	end
	
	self.closeButton:setSize(newSize, newSize)
	
	if self.setFontLayoutPerform then
		self:performLayout()
	end
end

function frame:preDrawRoot()
	if self.fadeIn then
		local old = self.alpha
		
		self.alpha = math.approach(self.alpha, 1, frameTime * self.fadeInSpeed)
		
		love.graphics.setColorModulation(1, 1, 1, self.alpha)
		
		if old ~= self.alpha then
			self:propagateSpriteUpdateQueueing()
		end
	end
end

function frame:postDrawRoot()
	if self.fadeIn then
		love.graphics.setColorModulation(1, 1, 1, 1)
	end
end

function frame:getFont()
	return self.font
end

function frame:setTitle(text)
	self.originalTitle = text
	self.textWidth = self.font:getWidth(self.title)
	self.fontHeight = self.font:getHeight()
	self.title = string.cutToWidth(text, self.font, self.w - self.fontHeight - self.buttonPad)
end

function frame:hideCloseButton()
	self.closeButton:hide()
	self.closeButton:setDisabled(true)
end

function frame:showCloseButton()
	self.closeButton:show()
end

function frame:getTitle()
	return self.title
end

function frame:getTopPartSize()
	return self.fontHeight
end

function frame:getTopPartBottom()
	return self.fontHeight + self.offsetY
end

frame.setText = frame.setTitle

function frame:draw(w, h)
	local poutline = self:getPanelOutlineColor()
	
	love.graphics.setColor(poutline.r, poutline.g, poutline.b, poutline.a)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", 0, 0, w, h, 4, 4, 2)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 1, 1, w - 2, h - 2, 2, 2, 2)
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", self.offsetX - 5, self.offsetY, self.w - (self.closeButton:getVisible() and self.largestCloseButtonSize + self.buttonPad or 0) - 10, self:getTopPartSize())
	love.graphics.setColor(tcol.r, tcol.g, tcol.b, tcol.a)
	love.graphics.setFont(self.font)
	love.graphics.print(self.title, self.offsetX, self.offsetY)
end

function frame:performLayout()
	local size = math.max(self.closeButton.w, self.closeButton.h)
	
	self.largestCloseButtonSize = size
	
	self:adjustCloseButtonPosition()
end

function frame:adjustCloseButtonPosition()
	self.closeButton:setPos(self.w - self.largestCloseButtonSize - self.buttonPad, self.buttonPad)
end

gui.register("Frame", frame)

local frameCloseButton = {}

frameCloseButton.skinPanelFillColor = color(255, 75, 30, 255)
frameCloseButton.skinPanelHoverColor = color(255, 125, 50, 255)

function frameCloseButton:init()
end

function frameCloseButton:setFrame(frame)
	self.frame = frame
end

function frameCloseButton:canShow()
	return not self.disabled
end

function frameCloseButton:setDisabled(state)
	self.disabled = state
end

function frameCloseButton:onClick()
	self.frame:kill()
end

function frameCloseButton:draw(w, h)
	local poutline = self:getPanelOutlineColor()
	
	love.graphics.setColor(poutline.r, poutline.g, poutline.b, poutline.a)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", 0, 0, w, h)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 1, 1, w - 2, h - 2)
end

gui.register("FrameCloseButton", frameCloseButton)
require("engine/gui/invisible_frame")
