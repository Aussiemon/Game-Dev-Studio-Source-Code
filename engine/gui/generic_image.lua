local genImg = {}

genImg.padding = 2
genImg._scaleVert = false
genImg._scaleHor = false

function genImg:setImage(img)
	self.image = img
	self.scaledOff = _S(self.padding)
end

function genImg:setDesiredSize(size)
	local w, h = self.image:getDimensions()
	
	self.imgScale = self.image:getScaleToSize(_S(size))
	
	self:setSize(w * self.imgScale + _S(self.padding * 2), h * self.imgScale + _S(self.padding * 2))
end

function genImg:onKill()
	self.image = nil
end

function genImg:positionToMouse(xOff, yOff)
	genImg.baseClass.positionToMouse(self, xOff, yOff)
	
	self.positioningToMouse = true
	self.mouseOffX = xOff or 0
	self.mouseOffY = yOff or 0
end

function genImg:think()
	if self.positioningToMouse then
		self:setPos(love.mouse.getX() + self.mouseOffX, love.mouse.getY() + self.mouseOffY)
	end
end

function genImg:draw(w, h)
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.image, self.scaledOff, self.scaledOff, 0, self.imgScale, self.imgScale)
end

gui.register("GenericImage", genImg)
