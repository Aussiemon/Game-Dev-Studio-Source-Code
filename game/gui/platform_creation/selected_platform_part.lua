local selectedPart = {}

selectedPart.canShowOptions = true
selectedPart.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.PART_SET
}

function selectedPart:handleEvent(event)
	self:updateActiveData()
	self:queueSpriteUpdate()
end

function selectedPart:setPartType(type)
	self.type = type
	
	self:updateActiveData()
end

function selectedPart:setCanShowOptions(can)
	self.canShowOptions = can
end

function selectedPart:updateActiveData()
	self.data = platformParts.registeredByID[self.platform:getPartID(self.type)]
end

function selectedPart:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and self.canShowOptions then
		local tab = platformParts:getOptionTab()
		
		if tab and tab:isValid() then
			tab:kill()
			platformParts:setOptionTab(nil)
			
			if tab.partType == self.type then
				self:setupDescbox()
				
				return 
			end
		end
		
		if self.descBox then
			self:killDescBox()
		end
		
		self:createSelectablePartMenu()
	end
end

function selectedPart:getUnderColor()
	if self:isOn() then
		return game.UI_COLORS.NEW_HUD_FILL_3
	end
	
	return game.UI_COLORS.GREEN
end

function selectedPart:canSetupDescbox()
	local tab = platformParts:getOptionTab()
	
	if tab and tab:isValid() then
		return 
	end
	
	return selectedPart.baseClass.canSetupDescbox(self)
end

function selectedPart:createSelectablePartMenu()
	self.backdrop = gui.create("GenericBackdrop")
	self.backdrop.color = color(0, 0, 0, 200)
	
	local x, y = _S(3), _S(3)
	local scaledSize = _S(platformParts.elementSize)
	local gap = _S(5)
	
	for key, data in ipairs(platformParts.registeredByPartType[self.type]) do
		local selection = gui.create("PlatformPartSelection", self.backdrop)
		
		selection:setPlatform(self.platform)
		selection:setSize(platformParts.elementSize, platformParts.elementSize)
		selection:setPos(x, y)
		selection:setData(data)
		
		x = x + scaledSize + gap
	end
	
	local w = x
	local x, y = self:getPos(true)
	
	self.backdrop:setSize(_US(w), platformParts.elementSize + 6)
	self.backdrop:setPos(x, y - self.backdrop.h - _S(5))
	self.backdrop:bringUp()
	
	self.backdrop.partType = self.type
	
	platformParts:setOptionTab(self.backdrop)
end

function selectedPart:onKill()
	if self.backdrop and self.backdrop:isValid() then
		self.backdrop:kill()
		
		self.backdrop = nil
	end
end

gui.register("SelectedPlatformPart", selectedPart, "PlatformPartSelection")
