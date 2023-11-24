local characterAppearanceDisplay = {}

function characterAppearanceDisplay:setEmployee(employee)
	self.employee = employee
end

function characterAppearanceDisplay:getEmployee()
	return self.employee
end

function characterAppearanceDisplay:updateSprites()
	self.listOfFaceSprites = self.employee:getPortrait():setupSpritebatch(self, true, -(self.w - _S(40)), _S(54), 4, self.listOfFaceSprites, nil)
	
	self:setNextSpriteColor(0, 0, 0, 175)
	
	self.underFaceSprite = self:allocateSprite(self.underFaceSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
end

function characterAppearanceDisplay:handleEvent(event)
	if event == portrait.EVENTS.APPEARANCE_CHANGED then
		self:queueSpriteUpdate()
	end
end

gui.register("CharacterAppearanceDisplay", characterAppearanceDisplay)
