local shaderButton = {}

function shaderButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
	self:setHoverText(shadowShader.DESCRIPTION)
end

function shaderButton:optionSelectCallback()
	shadowShader:setQualityPreset(self.presetId)
	self.baseButton:updateText()
	game.saveUserPreferences()
end

function shaderButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	self:killDescBox()
	
	for key, presetData in ipairs(shadowShader:getQualityPresets()) do
		local optionObject = cbox:addOption(0, 0, self.rawW, 18, presetData.name, fonts.get("pix20"), shaderButton.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.presetId = key
		
		optionObject:setHoverText(presetData.description)
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function shaderButton:updateText()
	local data = shadowShader:getPresetBySettings(shadowShader:getQualitySettings())
	
	self:setText(data.name)
end

gui.register("ShadowShaderButton", shaderButton, "Button")
