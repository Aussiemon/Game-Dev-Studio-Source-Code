local timedDisplay = {}

timedDisplay.dieTime = nil
timedDisplay.fadeInTime = 0.3
timedDisplay.fadeOutTime = 0.6
timedDisplay.moveRate = 5
timedDisplay.backgroundColor = color(0, 0, 0, 200)

function timedDisplay:init()
	self.dieTime = 5
	self.alpha = 0
end

function timedDisplay:think()
	timedDisplay.baseClass.think(self)
	
	if self.finishX then
		local ft = frameTime
		local x, y = self:getPos()
		local scaledMin = _S(30)
		local scaledMoveRate = _S(self.moveRate)
		local newX = math.clampedLerp(x, self.finishX, scaledMoveRate * ft, scaledMin * ft)
		local newY = math.clampedLerp(y, self.finishY, scaledMoveRate * ft, scaledMin * ft)
		
		x = math.approach(x, self.finishX, newX)
		y = math.approach(y, self.finishY, newY)
		
		self:setPos(x, y)
		self:queueSpriteUpdate()
	end
end

function timedDisplay:doTimedAppear()
	self:adjustAlpha()
end

function timedDisplay:setStartPos(x, y)
	self.startX = x
	self.startY = y
end

function timedDisplay:getStartPos()
	return self.startX, self.startY
end

function timedDisplay:adjustAlpha()
	local ft = frameTime
	
	self.dieTime = self.dieTime - ft
	
	if self.dieTime <= 0 then
		self.alpha = math.approach(self.alpha, 0, 1 / self.fadeOutTime * ft)
		
		if self.alpha == 0 then
			self:kill()
		else
			self:queueSpriteUpdate()
		end
	else
		self.alpha = math.approach(self.alpha, 1, 1 / self.fadeInTime * ft)
		
		self:queueSpriteUpdate()
	end
end

function timedDisplay:setFinishPos(x, y)
	self.finishX = x
	self.finishY = y
end

function timedDisplay:getProgress()
	if not self.startX then
		return 0, 0
	end
	
	return math.abs(self.x - self.startX) / math.abs(self.startX - self.finishX), math.abs(self.y - self.startY) / math.abs(self.startY - self.finishY)
end

function timedDisplay:setMoveRate(rate)
	self.moveRate = rate
end

function timedDisplay:setDieTime(dieTime)
	self.dieTime = dieTime
end

function timedDisplay:resetAlpha()
	self.alpha = 0
end

function timedDisplay:setFadeInTime(fadeIn)
	self.fadeInTime = fadeIn
end

function timedDisplay:setFadeOutTime(fadeOut)
	self.fadeOutTime = fadeOut
end

gui.register("TimedTextDisplay", timedDisplay, "GenericDescbox")
