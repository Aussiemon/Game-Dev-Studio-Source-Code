local bgElem = {}

bgElem.fadeInSpeed = 1
bgElem.targetAlpha = 1

function bgElem:init()
	self.alpha = 0
end

function bgElem:setFadeInSpeed(speed)
	self.fadeInSpeed = speed
end

function bgElem:setTargetAlpha(alpha)
	self.targetAlpha = alpha
end

function bgElem:setEventOnFadeIn(event)
	self.eventOnFade = event
end

function bgElem:setAlpha(alpha)
	local oldAlpha = self.alpha
	
	bgElem.baseClass.setAlpha(self, alpha)
	
	if oldAlpha ~= alpha and self.eventOnFade then
		self:fireFadeInEvent()
	end
end

function bgElem:fireFadeInEvent()
	events:fire(self.eventOnFade)
end

function bgElem:think()
	local oldAlpha = self.alpha
	
	self.alpha = math.approach(self.alpha, self.targetAlpha, frameTime * self.fadeInSpeed)
	
	if self.eventOnFade and self.alpha == self.targetAlpha and oldAlpha ~= 1 then
		self:fireFadeInEvent()
	end
	
	self:queueSpriteUpdate()
end

gui.register("GameAwardsBackgroundFadeIn", bgElem, "GameAwardsBackgroundElement")
