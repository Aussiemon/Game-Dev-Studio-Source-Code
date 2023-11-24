local darkener = {}

darkener.targetAlpha = 0.5
darkener.alphaApproachSpeed = 1
darkener._scaleVert = false
darkener._scaleHor = false
darkener.EVENTS = {
	REACHED_FULL_ALPHA = events:new()
}

function darkener:init()
	self.alpha = 0
end

function darkener:setTargetAlpha(alpha)
	self.targetAlpha = alpha
end

function darkener:setAlphaApproachSpeed(speed)
	self.alphaApproachSpeed = speed
end

function darkener:setAlpha(alpha)
	self.alpha = alpha
end

function darkener:draw(w, h)
	local prevAlpha = self.alpha
	
	if prevAlpha ~= self.targetAlpha then
		self.alpha = math.approach(self.alpha, self.targetAlpha, frameTime * self.alphaApproachSpeed)
	end
	
	if prevAlpha ~= self.alpha and self.alpha == self.targetAlpha then
		events:fire(darkener.EVENTS.REACHED_FULL_ALPHA, self)
	end
	
	love.graphics.setColor(0, 0, 0, 255 * self.alpha)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("ScreenDarkener", darkener)
