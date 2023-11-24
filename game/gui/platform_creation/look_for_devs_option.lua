local option = {}

option.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.DEV_STAGE_SET
}

function option:setPlatform(plat)
	self.platform = plat
end

function option:handleEvent(event, obj)
	if obj == self.platform then
		self:verifyClickState()
	end
end

function option:verifyClickState()
	if self.platform:getDevStage() == playerPlatform.DEV_STAGE then
		self:setCanClick(true)
		self:queueSpriteUpdate()
	else
		self:setCanClick(false)
		self:queueSpriteUpdate()
	end
end

gui.register("LookForDevsOption", option, "ComboBoxOption")
