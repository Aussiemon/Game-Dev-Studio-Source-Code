local lightmapButton = {}

function lightmapButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
	self:setHoverText(lightingManager.DESCRIPTION)
end

function lightmapButton:optionSelectCallback()
	lightingManager:setQualityPreset(self.presetId)
	self.baseButton:updateText()
	game.saveUserPreferences()
end

function lightmapButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	self:killDescBox()
	
	for key, presetData in ipairs(lightingManager:getQualityPresets()) do
		local optionObject = cbox:addOption(0, 0, self.rawW, 18, presetData.name, fonts.get("pix20"), lightmapButton.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.presetId = key
		
		optionObject:setHoverText(presetData.description)
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function lightmapButton:updateText()
	local data = lightingManager:getPresetByResolutionScale(lightingManager:getResolutionScale())
	
	self:setText(data.name)
end

gui.register("LightmapQualityButton", lightmapButton, "Button")
