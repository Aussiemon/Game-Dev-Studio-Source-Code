local platCreaButt = {}

platCreaButt.hoverText = {
	{
		font = "bh18",
		text = _T("PLATFROM_CREATE_NEW", "Create new platform")
	}
}
platCreaButt.hoverTextUnavailable = {
	{
		font = "bh18",
		wrapWidth = 230,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("PLATFORM_CREATION_UNAVAILABLE_PLATFORM_ON_SALE", "New platform creation not available as long as you have a console on-market.")
	}
}
platCreaButt.hoverTextUnavailableDev = {
	{
		font = "bh18",
		wrapWidth = 230,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("PLATFORM_CREATION_UNAVAILABLE_PLATFORM_INDEV", "Platform creation unavailable, since you already have a platform in-development.")
	}
}
platCreaButt.hoverTextTutorial = {
	{
		font = "bh18",
		wrapWidth = 230,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("PLATFORM_CREATION_UNAVAILABLE_TUTORIAL", "Platform creation is not available at the moment. Check back later.")
	}
}
platCreaButt.skinPanelFillColor = color(150, 150, 150, 255)
platCreaButt.skinPanelHoverColor = color(255, 255, 255, 255)
platCreaButt.skinPanelDisableColor = color(100, 100, 100, 255)
platCreaButt.iconScale = 0.8
platCreaButt.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.CANCELLED_DEVELOPMENT,
	playerPlatform.EVENTS.DISCONTINUED
}

function platCreaButt:init()
	self:updateState()
end

function platCreaButt:handleEvent(event)
	self:updateState()
end

function platCreaButt:updateState()
	if not interactionRestrictor:canPerformAction("generic_project_interaction") then
		self.available = false
		self.hoverText = self.hoverTextTutorial
	else
		local indev = #studio:getDevPlayerPlatforms()
		
		self.available = #studio:getActivePlayerPlatforms() == 0 and indev == 0
		
		if not self.available then
			if indev > 0 then
				self.hoverText = self.hoverTextUnavailableDev
			else
				self.hoverText = self.hoverTextUnavailable
			end
		else
			self.hoverText = self.hoverTextAvailable
		end
	end
end

function platCreaButt:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and self.available then
		platformParts:openPlatformCreationMenu()
	end
end

function platCreaButt:updateSprites()
	local clr
	
	if self:isMouseOver() and self:isDisabled() then
		clr = self.skinPanelFillColor
	else
		clr = self:getStateColor()
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.outlineSprite = self:allocateSprite(self.outlineSprite, "generic_backdrop_64", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local icon = "icon_new_platform"
	local iconX, iconY = self.w * 0.5, self.h * 0.5
	local quad = quadLoader:load(icon)
	local quadW, quadH = quad:getSize()
	local scale = quad:getScaleToSize(self.w * self.iconScale)
	local iconW, iconH = quadW * scale, quadH * scale
	
	iconX = iconX - iconW * 0.5
	iconY = iconY - iconH * 0.5
	
	self:setNextSpriteColor(clr:unpack())
	
	self.iconSprite = self:allocateSprite(self.iconSprite, icon, iconX, iconY, 0, _US(iconW), _US(iconH), 0, 0, -0.5)
end

function platCreaButt:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x - _S(5) - self.descBox.w, y + self.h * 0.5 - self.descBox.h * 0.5)
end

gui.register("PlatformCreationMenuButton", platCreaButt, "IconButton")
