local platformPartSelection = {}

platformPartSelection.skinPanelFillColor = color(0, 0, 0, 150)
platformPartSelection.skinPanelHoverColor = game.UI_COLORS.LIGHT_BLUE

function platformPartSelection:setData(data)
	self.data = data
end

function platformPartSelection:setPlatform(plat)
	self.platform = plat
end

function platformPartSelection:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.platform:setPartID(self.data.partType, self.data.id)
		platformParts:closeOptionTab()
	end
end

function platformPartSelection:isOn()
	return self.platform:getPartID(self.data.partType) == self.data.id
end

function platformPartSelection:getUnderColor()
	if self:isOn() then
		if self:isMouseOver() then
			return game.UI_COLORS.NEW_HUD_HOVER
		else
			return game.UI_COLORS.NEW_HUD_HOVER_DESATURATED
		end
	elseif self:isMouseOver() then
		return game.UI_COLORS.GREEN
	else
		return game.UI_COLORS.NEW_HUD_FILL_3
	end
end

function platformPartSelection:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.4)
	
	self:setNextSpriteColor(self:getUnderColor():unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.4)
	
	local targetSpriteSize = math.min(self.rawW - 2, self.rawH - 2)
	local quadData = quadLoader:getQuadStructure(self.data.quad)
	local scaler = quadData:getScaleToSize(targetSpriteSize)
	local w, h = quadData.w * scaler, quadData.h * scaler
	
	if not self:isMouseOver() then
		self:setNextSpriteColor(150, 150, 150, 255)
	end
	
	self.partSprite = self:allocateSprite(self.partSprite, self.data.quad, self.w * 0.5 - _S(w * 0.5), self.h * 0.5 - _S(h * 0.5), 0, w, h, 0, 0, -0.2)
end

function platformPartSelection:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function platformPartSelection:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

function platformPartSelection:onMouseEntered()
	platformPartSelection.baseClass.onMouseEntered(self)
	self:queueSpriteUpdate()
	self:setupDescbox()
end

function platformPartSelection:onMouseLeft()
	platformPartSelection.baseClass.onMouseLeft(self)
	self:killDescBox()
	self:queueSpriteUpdate()
end

function platformPartSelection:canSetupDescbox()
	if self.descBox and self.descBox:isValid() then
		return false
	end
	
	return true
end

function platformPartSelection:setupDescbox()
	if not self:canSetupDescbox() then
		return 
	end
	
	self.descBox = gui.create("GenericDescbox")
	
	self.data:setupDescboxInfo(self.descBox, 350)
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x, y - _S(6) - self.descBox.h)
end

gui.register("PlatformPartSelection", platformPartSelection)
