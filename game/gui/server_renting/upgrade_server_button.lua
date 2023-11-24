local upgradeServer = {}

function upgradeServer:onMouseEntered()
	upgradeServer.baseClass.onMouseEntered(self)
	
	local object = self.parent:getObjectList()[1]
	local curLevel = object:getProgression()
	local level = object:getLatestProgression()
	local cap = object:getCapacityChange()
	local nextCap = object:getCapacityChange(level)
	
	self.descBox = gui.create("GenericDescbox")
	
	if curLevel < level then
		self.descBox:addText(_format(_T("UPGRADE_SERVER_FOR", "Upgrade to level LEVEL for COST"), "LEVEL", level, "COST", string.roundtobigcashnumber(object:getUpgradeCost(level))), "bh20", nil, 0, 350, "question_mark", 22, 22)
		self.descBox:addText(_format(_T("INCREASES_SERVER_CAPACITY_BY", "Increases server capacity by CAP pts."), "CAP", string.roundtobignumber(nextCap - cap)), "bh18", nil, 0, 350)
	else
		self.descBox:addText(_T("NO_UPGRADE_AVAILABLE", "No upgrade available"), "bh20", nil, 0, 350, "question_mark", 22, 22)
	end
	
	self.descBox:centerToElement(self)
end

function upgradeServer:onMouseLeft()
	upgradeServer.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function upgradeServer:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local list = self.parent:getObjectList()
		local index = math.random(1, #list)
		local object = list[index]
		local latest = object:getLatestProgression()
		
		if latest > object:getProgression() and studio:hasFunds(object:getUpgradeCost(latest)) then
			self.parent:onUpgrade(object, index)
			sound:play("fund_change")
		end
	end
end

gui.register("UpgradeServerButton", upgradeServer, "IconButton")
