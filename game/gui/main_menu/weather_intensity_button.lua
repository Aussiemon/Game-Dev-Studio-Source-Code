local weatherIntensityButton = {}

function weatherIntensityButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
	self:setHoverText(weather.DESCRIPTION)
end

function weatherIntensityButton:optionSelectCallback()
	weather:setQualityPreset(self.presetId)
	self.baseButton:updateText()
	game.saveUserPreferences()
end

function weatherIntensityButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	self:killDescBox()
	
	for key, presetData in ipairs(weather:getQualityPresets()) do
		local optionObject = cbox:addOption(0, 0, self.rawW, 18, presetData.name, fonts.get("pix20"), weatherIntensityButton.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.presetId = key
		
		optionObject:setHoverText(presetData.description)
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function weatherIntensityButton:updateText()
	local data = weather:getPresetBySettings(weather:getQualitySettings())
	
	self:setText(data.name)
end

gui.register("WeatherIntensityButton", weatherIntensityButton, "Button")
