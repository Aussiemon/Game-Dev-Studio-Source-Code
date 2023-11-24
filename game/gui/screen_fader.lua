local fader = {}

fader.targetAlpha = 1
fader.alphaApproachSpeed = 1
fader.fadeColor = color(0, 0, 0)
fader.canHover = false
fader._scaleVert = false
fader._scaleHor = false
fader.EVENTS = {
	FADED_IN = events:new(),
	FADED_OUT = events:new()
}
fader.STATES = {
	OUT = 2,
	IN = 1
}

function fader:init()
	self.alpha = 0
	self.fadeOutTime = 0
	self.fadeState = 1
	self.fadeOutDelay = 1
	self.canFadeOut = true
end

function fader:setFadeColor(color)
	self.fadeColor = color
end

function fader:setTargetAlpha(alpha)
	self.targetAlpha = alpha
end

function fader:setFadeOutDelay(delay)
	self.fadeOutDelay = delay
end

function fader:setAlphaApproachSpeed(speed)
	self.alphaApproachSpeed = speed
end

function fader:setAlpha(alpha)
	self.alpha = alpha
end

function fader:setFadeOutState()
	self.alpha = self.targetAlpha
	self.fadeState = fader.STATES.OUT
end

function fader:setFadeState(state)
	self.fadeState = state
end

function fader:setCanFadeOut(can)
	self.canFadeOut = can
end

function fader:draw(w, h)
	if self.fadeState == fader.STATES.IN then
		local prevAlpha = self.alpha
		
		self.alpha = math.approach(self.alpha, self.targetAlpha, frameTime * self.alphaApproachSpeed)
		
		if prevAlpha ~= self.alpha and self.alpha == self.targetAlpha then
			events:fire(fader.EVENTS.FADED_IN, self)
			
			if self.canFadeOut then
				self.fadeState = fader.STATES.OUT
			end
		end
	elseif self.fadeState == fader.STATES.OUT then
		local prevAlpha = self.alpha
		
		self.alpha = math.approach(self.alpha, 0, frameTime * self.alphaApproachSpeed)
		
		if prevAlpha ~= self.alpha and self.alpha == 0 then
			events:fire(fader.EVENTS.FADED_OUT, self)
			
			self.fadeState = fader.STATES.OUT
			
			self:kill()
			
			return 
		end
	end
	
	local clr = self.fadeColor
	
	love.graphics.setColor(clr.r, clr.g, clr.b, 255 * self.alpha)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("ScreenFader", fader)
