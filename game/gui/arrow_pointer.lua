local arrowPointer = {}

arrowPointer.moveAmount = 20
arrowPointer.moveSpeed = 2.5
arrowPointer.arrowColor = color(203, 221, 175, 255)

function arrowPointer:init()
	self.sine = 0
	self.progress = 0
	
	self:setAngle(0)
end

function arrowPointer:think()
	if self.drawCheckElement:canDraw() and self.followElement then
		local x, y = self.followElement:getPos(true)
		
		self:setPos(x + self.followOffsetX, y + self.followOffsetY)
	end
	
	self.progress = self.progress + frameTime * self.moveSpeed
	self.sine = math.sin(self.progress)
	
	self:queueSpriteUpdate()
end

function arrowPointer:setAngle(ang)
	self.angle = ang
	self.radians = math.rad(self.angle)
	self.moveY, self.moveX = math.normalfromdeg(ang)
end

function arrowPointer:setTrackElement(element)
	self.trackElement = element
	self.drawCheckElement = element
end

function arrowPointer:setMoveAmount(amount)
	self.moveAmount = amount
end

function arrowPointer:setFollowElement(element)
	self.followElement = element
	self.drawCheckElement = self.followElement
end

function arrowPointer:setFollowOffset(x, y)
	self.followOffsetX = x
	self.followOffsetY = y
end

function arrowPointer:setMoveSpeed(speed)
	self.moveSpeed = speed
end

function arrowPointer:setArrowColor(clr)
	self.arrowColor = clr
end

function arrowPointer:updateSprites()
	local alpha = 1
	
	if not self.drawCheckElement:canDraw() then
		alpha = 0
	end
	
	local a, b = math.rotateAroundCenter(self.rawW, self.rawH, self.progress)
	local x, y = self.moveX * self.sine * self.moveAmount, self.moveY * self.sine * self.moveAmount
	
	self:setNextSpriteColor(10, 10, 10, 100 * alpha)
	
	self.arrowSpriteShadow = self:allocateSprite(self.arrowSpriteShadow, "arrow", x - _S(1), y - _S(1), self.radians, self.rawW, self.rawH, self.rawW * 0.25, self.rawH * 0.25, -0.1)
	
	local r, g, b, a = self.arrowColor:unpack()
	
	self:setNextSpriteColor(r, g, b, a * alpha)
	
	self.arrowSprite = self:allocateSprite(self.arrowSprite, "arrow", x, y, self.radians, self.rawW, self.rawH, self.rawW * 0.25, self.rawH * 0.25, -0.1)
end

gui.register("ArrowPointer", arrowPointer)
