local PropertyFrame = {}

PropertyFrame.animated = false
PropertyFrame.shouldBlockLightingManager = false

function PropertyFrame:init()
	self.closeButton:setVisible(false)
	self:setText("")
end

function PropertyFrame:draw()
end

function PropertyFrame:onKill()
	if studio.expansion:attemptLeave() then
		self.baseClass.onKill(self)
	end
end

function PropertyFrame:canCloseViaKey()
	return studio.expansion:canLeave()
end

function PropertyFrame:closeViaKey()
	studio.expansion:attemptLeave()
end

function PropertyFrame:preventsMouseOver()
	return false
end

function PropertyFrame:updateSprites()
end

function PropertyFrame:canCloseViaEscape()
	return studio.expansion:canLeave()
end

gui.register("PropertyFrame", PropertyFrame, "Frame")
