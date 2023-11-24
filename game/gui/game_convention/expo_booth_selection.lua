local boothSelection = {}

function boothSelection:setConventionData(data)
	self.conventionData = data
end

function boothSelection:setBoothID(id)
	self.boothID = id
	
	self:setFont("pix28")
	self:setText("")
end

function boothSelection:isOn()
	return self.conventionData:getDesiredBooth() == self.boothID
end

function boothSelection:handleEvent(event)
	if event == gameConventions.EVENTS.BOOTH_CHANGED then
		self:queueSpriteUpdate()
	end
end

function boothSelection:onMouseEntered()
	boothSelection.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	local boothData = self.conventionData.booths[self.boothID]
	
	self.descBox:addText(boothData.display, "pix22", nil, 3, 600)
	self.descBox:addText(string.easyformatbykeys(_T("BOOTH_INFO_COST", "Cost: COST"), "COST", string.roundtobigcashnumber(boothData.cost)), "bh20", game.UI_COLORS.IMPORTANT_2, 6, 600, "wad_of_cash", 24, 24)
	self.descBox:addText(string.easyformatbykeys(_T("BOOTH_INFO_MAX_GAMES", "GAMES presentable games"), "GAMES", boothData.maxPresentedGames), "bh18", game.UI_COLORS.LIGHT_BLUE, 8, 600, {
		{
			width = 24,
			icon = "icon_games_tab"
		}
	})
	self.descBox:addText(string.easyformatbykeys(_T("BOOTH_INFO_REQUIRED_PARTICIPANTS", "PARTICIPANTS required participants"), "PARTICIPANTS", boothData.requiredParticipants), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, 600, "hud_employee", 19, 24)
	self.descBox:addText(string.easyformatbykeys(_T("BOOTH_INFO_MAX_VISITORS", "VISITORS max daily visitors"), "VISITORS", string.comma(boothData.maxPeopleHoused)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, 600, "employees", 24, 24)
	self.descBox:centerToElement(self)
end

function boothSelection:updateSprites()
	boothSelection.baseClass.updateSprites(self)
	
	local on = self:isOn()
	
	if on then
		self:setNextSpriteColor(0, 0, 0, 50)
	else
		self:setNextSpriteColor(0, 0, 0, 100)
	end
	
	self.backDarkSprite = self:allocateSprite(self.backDarkSprite, "generic_1px", _S(2), _S(2), 0, self.rawW - 6, self.rawH - 6, 0, 0, -0.2)
	
	local boothData = self.conventionData.booths[self.boothID]
	
	if on then
		self:setNextSpriteColor(220, 220, 220, 255)
	else
		self:setNextSpriteColor(150, 150, 150, 255)
	end
	
	self.boothIcon = self:allocateSprite(self.boothIcon, boothData.icon, _S(4), _S(4), 0, self.rawW - 8, self.rawH - 8, 0, 0, -0.1)
end

function boothSelection:onMouseLeft()
	boothSelection.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function boothSelection:onClick(x, y, key)
	self.conventionData:setDesiredBooth(self.boothID)
end

gui.register("ExpoBoothSelection", boothSelection, "Button")
