local wsMod = {}

wsMod.CATCHABLE_EVENTS = {
	workshop.EVENTS.PREVIEW_RECEIVED,
	workshop.EVENTS.MOD_DISABLED,
	workshop.EVENTS.MOD_ENABLED
}
wsMod.iconSize = 50
wsMod.activationOffset = 25

function wsMod:handleEvent(event, id)
	if (event == workshop.EVENTS.MOD_DISABLED or event == workshop.EVENTS.MOD_ENABLED) and id == self.data.id then
		local wrapW = self.rawW - (self.iconSize + 5)
		local textLineW = _S(self.rawW - (self.iconSize + 20))
		
		self:updateEnabledState(wrapW, textLineW)
	elseif id == self.data.id then
		self:updatePreview()
	end
end

function wsMod:init()
	self.dataBox = gui.create("GenericDescbox", self)
	
	self.dataBox:setFadeInSpeed(0)
	self.dataBox:setShowRectSprites(false)
	self.dataBox:setPos(_S(self.iconSize + 5), _S(3))
	self.dataBox:overwriteDepth(5)
end

function wsMod:initVisual()
	self:setFont("bh22")
end

function wsMod:setData(data)
	self.data = data
	self.modInstalled = workshop:isModInstalled(self.data.id)
	
	if not self.modInstalled then
		self.activationOffset = 0
	end
	
	self:setupDisplay()
	self:updatePreview()
end

function wsMod:disableAddonCallback()
	workshop:disableMod(self.data.id)
end

function wsMod:enableAddonCallback()
	workshop:enableMod(self.data.id)
end

function wsMod:fillInteractionComboBox(comboBox)
	if not self.modInstalled then
		return 
	end
	
	if workshop:isModDisabled(self.data.id) then
		local button = comboBox:addOption(0, 0, 0, 24, _T("WORKSHOP_ENABLE_MOD", "Enable mod"), fonts.get("pix20"), wsMod.enableAddonCallback)
		
		button.data = self.data
	else
		local button = comboBox:addOption(0, 0, 0, 24, _T("WORKSHOP_DISABLE_MOD", "Disable mod"), fonts.get("pix20"), wsMod.disableAddonCallback)
		
		button.data = self.data
	end
end

function wsMod:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, x, y)
	end
end

function wsMod:updatePreview()
	self.preview = self.data.image
	
	if self.preview then
		local size = self.iconSize
		local x, y = _S(3 + size * 0.5), self.h * 0.5
		local w, h = self.preview:getDimensions()
		local scaledIconSize = _S(self.iconSize)
		local scale = self.preview:getScaleToSize(scaledIconSize)
		local scaledW, scaledH = w * scale, h * scale
		local backHeight = _S(self.rawH - 4)
		
		self.previewX = x - scaledW * 0.5
		self.previewY = y - (scaledH - self.activationOffset) * 0.5
		self.previewScale = scale
		
		self:queueSpriteUpdate()
	end
end

function wsMod:onKill()
	self.preview = nil
end

function wsMod:canShowState()
	return self.modInstalled
end

function wsMod:setupDisplay()
	local wrapW = self.rawW - (self.iconSize + 5)
	local textLineW = _S(self.rawW - (self.iconSize + 20))
	local data = self.data
	
	self.dataBox:removeAllText()
	self.dataBox:addTextLine(textLineW, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	self.dataBox:addText(data.title, "bh22", nil, 2, wrapW)
	self.dataBox:addTextLine(textLineW, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.dataBox:addText(data.description, "pix18", nil, 2, wrapW)
	self:updateEnabledState(wrapW, textLineW)
	self:setHeight(math.max(self.rawH, _US(self.dataBox.h) + 6))
end

function wsMod:updateEnabledState(wrapW, textLineW)
	if self:canShowState() then
		local text, textColor, lineColor, icon
		
		if workshop:isModDisabled(self.data.id) then
			text = _T("DISABLED", "Disabled")
			lineColor = game.UI_COLORS.RED
			textColor = game.UI_COLORS.RED
			icon = "close_button"
		else
			text = _T("ENABLED", "Enabled")
			lineColor = game.UI_COLORS.GREEN
			textColor = game.UI_COLORS.GREEN
			icon = "checkmark_dark_borders"
		end
		
		self.dataBox:addTextLine(textLineW, lineColor, nil, "weak_gradient_horizontal")
		
		if not self.enabledPresent then
			self.dataBox:addText(text, "bh22", textColor, 0, wrapW, icon, 22, 22)
			
			self.enabledPresent = true
		else
			self.dataBox:updateTextTable(text, "bh22", 3, textColor, 0, wrapW, icon, 22, 22)
		end
	end
end

function wsMod:updateSprites()
	wsMod.baseClass.updateSprites(self)
	
	local size = self.iconSize + 2
	
	self:setNextSpriteColor(0, 0, 0, 150)
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", _S(2), _S(2), 0, size, self.rawH - 4, 0, 0, -0.1)
end

function wsMod:draw(w, h)
	wsMod.baseClass.draw(self)
	
	if self.preview then
		love.graphics.draw(self.preview, self.previewX, self.previewY, 0, self.previewScale, self.previewScale)
	end
end

gui.register("WorkshopModDisplay", wsMod, "GenericElement")
