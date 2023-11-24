local caseButton = {}

caseButton.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.CASE_DISPLAY_CHANGED
}

function caseButton:handleEvent(event, obj)
	if obj == self.platform then
		self:queueSpriteUpdate()
	end
end

function caseButton:setData(data)
	self.data = data
end

function caseButton:setPlatform(plat)
	self.platform = plat
end

function caseButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.platform:setCaseDisplay(self.data.id)
		self:queueSpriteUpdate()
	end
end

function caseButton:isOn()
	return self.platform:getCaseDisplay() == self.data.id
end

function caseButton:onMouseEntered()
	self:queueSpriteUpdate()
end

function caseButton:onMouseLeft()
	self:queueSpriteUpdate()
end

function caseButton:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function caseButton:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

function caseButton:updateSprites()
	local underSize = self.rawH
	local quadName = self.data.quad
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(underSize - 12)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local scaledH = self:applyScaler(h)
	local clr
	
	if self:isOn() then
		clr = game.UI_COLORS.GREEN
	elseif self:isMouseOver() then
		clr = game.UI_COLORS.NEW_HUD_HOVER
	else
		clr = game.UI_COLORS.NEW_HUD_FILL_3
	end
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 4, -0.1)
	
	self:setNextSpriteColor(clr:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(2), _S(2), 0, self.rawW - 4, self.rawH - 4, 0, 0, -0.1)
	self.platformIcon = self:allocateSprite(self.platformIcon, quadName, _S(underSize * 0.5 - w * 0.5), self.h * 0.5 - scaledH * 0.5, 0, w, h, 0, 0, 0.15)
end

gui.register("PlatformCaseDisplay", caseButton)
