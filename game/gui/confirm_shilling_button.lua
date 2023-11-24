local shilling = {}

shilling.shillData = advertisement:getData("shilling")
shilling.skinTextDisableColor = color(175, 175, 175, 255)

function shilling:init()
	self:setFont(fonts.get("pix24"))
	
	self.activeShillSites = 0
	self.totalCost = 0
	self.shillType = 1
	self.shillDuration = 1
	self.sitesToShillOn = {}
end

function shilling:setCostDisplay(costDisplay)
	self.costDisplay = costDisplay
end

function shilling:setTarget(target)
	self.inviteTarget = target
end

function shilling:getTarget()
	return self.inviteTarget
end

function shilling:setProject(proj)
	self.project = proj
end

function shilling:toggleSiteShillState(siteID, state)
	if state ~= nil then
		self:setSiteShillState(siteID, state)
		
		return 
	end
	
	if not table.find(self.sitesToShillOn, siteID) then
		self:setSiteShillState(siteID, true)
	else
		self:setSiteShillState(siteID, nil)
	end
end

function shilling:getSitesToShillOn()
	return self.sitesToShillOn
end

function shilling:getSiteShillState(siteID)
	return table.find(self.sitesToShillOn, siteID)
end

function shilling:setShillingType(type)
	self.shillType = type
	
	self:recalculateCosts()
end

function shilling:setShillingDuration(dur)
	self.shillDuration = dur
	
	self:recalculateCosts()
end

function shilling:setSiteShillState(advertType, state)
	if state then
		table.insert(self.sitesToShillOn, advertType)
	else
		table.removeObject(self.sitesToShillOn, advertType)
	end
	
	self.activeShillSites = 0
	
	for key, siteID in ipairs(self.sitesToShillOn) do
		self.activeShillSites = self.activeShillSites + 1
	end
	
	self:recalculateCosts()
end

function shilling:getCosts()
	return self.shillData:getCost(self.sitesToShillOn, self.shillType, self.shillData.durationOptions[self.shillDuration])
end

function shilling:recalculateCosts()
	self.totalCost = self:getCosts()
	
	self.costDisplay:setCost(self.totalCost)
end

function shilling:isDisabled()
	if not self.project or self.activeShillSites == 0 or not studio:hasFunds(self.totalCost) or self.totalCost == 0 or self.shillDuration == 0 or self.shillType == 0 then
		return true
	end
	
	return false
end

function shilling:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	local data = advertisement:getData("shilling")
	
	data:applyShillingDataToGame(self.project, self.sitesToShillOn, self.shillType, self.shillData.durationOptions[self.shillDuration], self.totalCost)
	
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("SHILLING_STARTED_TITLE", "Shilling Started"))
	popup:setText(_T("SHILLING_STARTED_DESC", "You've hired an advertisement agency to shill the game on the sites you've selected. Expect to hear frequent updates on what is going on."))
	popup:setOnKillCallback(game.genericClearFrameControllerCallback)
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"), nil)
	popup:center()
	frameController:push(popup)
	studio:deductFunds(self.totalCost, nil, "marketing")
	self.project:changeMoneySpent(self.totalCost)
end

function shilling:draw(w, h)
	shilling.baseClass.draw(self, w, h)
end

gui.register("ConfirmShillingButton", shilling, "Button")
