local progressingObjectBase = {}

progressingObjectBase.baseCost = 0
progressingObjectBase.class = "progressing_object_base"
progressingObjectBase.progressionLevel = 1
progressingObjectBase.EVENTS = {
	UPGRADED_ALL = events:new(),
	UPGRADED_OBJECT = events:new()
}
progressingObjectBase.BASE = true

function progressingObjectBase:getCost(level)
	level = math.max(1, level or self.progressionLevel, self:getLatestProgression())
	
	return self.baseCost + self:getProgressionCost(level)
end

function progressingObjectBase:isOutdated()
	return self:getLatestProgression() > self.progressionLevel
end

function progressingObjectBase:getRealMonthlyCosts()
	return self.monthlyCosts
end

function progressingObjectBase:setProgression(level)
	self.progressionLevel = math.max(1, level)
	
	self:updateSprite()
end

function progressingObjectBase:getProgression()
	return self.progressionLevel
end

function progressingObjectBase:getTextureQuad(progressionLevel)
	progressionLevel = progressionLevel or self.progressionLevel
	
	return self.progression[progressionLevel].quad or self.quad
end

function progressingObjectBase:getIcon()
	return self.progression[self:getLatestProgression()].icon
end

function progressingObjectBase:upgradeObject(simpleUpgrade)
	local lastLevel = self:getLatestProgression()
	
	if not simpleUpgrade then
		local realCost = self:getUpgradeCost(lastLevel)
		
		self:setProgression(lastLevel)
		studio:deductFunds(realCost, nil, "office_expansion")
		studio:updateComputerLevels()
	else
		self:setProgression(lastLevel)
	end
end

function progressingObjectBase:canIncreaseProgress()
	local maxProgress = self:getLatestProgression()
	
	return maxProgress > self.progressionLevel, maxProgress
end

function progressingObjectBase:upgradeObjectCallback()
	self.object:upgradeObject()
	events:fire(progressingObjectBase.EVENTS.UPGRADED_OBJECT, self.object)
end

function progressingObjectBase:levelUpCallback()
	local curlevel = self.object:getProgression()
	
	if curlevel >= #self.object.progression then
		self.object:setProgression(1)
	else
		self.object:setProgression(curlevel + 1)
	end
	
	events:fire(progressingObjectBase.EVENTS.UPGRADED_OBJECT, self.object)
end

function progressingObjectBase:upgradeAllObjectsCallback()
	if not studio:hasFunds(self.totalCost) then
		game.createNotEnoughFundsPopup(self.totalCost, nil)
		
		return 
	end
	
	local ourClass = self.object.class
	
	for key, object in ipairs(studio:getOwnedObjects()) do
		if object.class == ourClass and object:canIncreaseProgress() then
			object:upgradeObject(true)
		end
	end
	
	studio:deductFunds(self.totalCost, nil, "office_expansion")
	studio:updateComputerLevels()
	events:fire(progressingObjectBase.EVENTS.UPGRADED_ALL)
end

function progressingObjectBase:selectForPurchase()
	local progression = self:getLatestProgression()
	
	self:setProgression(progression)
	studio.expansion:setProgressionLevel(progression)
end

function progressingObjectBase:getSellAmount()
	return math.round(self.baseCost + self.progression[self.progressionLevel].cost * self:getSellAmountTimeAffector())
end

function progressingObjectBase:getUpgradeCost(desiredLevel)
	desiredLevel = math.max(1, desiredLevel)
	
	return math.max(self.progression[desiredLevel].cost - self:getSellAmount(), 0)
end

function progressingObjectBase:fillInteractionComboBox(combobox)
	local canProgress, maxLevel = self:canIncreaseProgress()
	local upgradeCost = self:getUpgradeCost(maxLevel)
	
	if canProgress and studio:hasFunds(upgradeCost) then
		local option = combobox:addOption(0, 0, 0, 24, string.easyformatbykeys(_T("UPGRADE_OBJECT_TO_LEVEL", "Upgrade OBJECT to level LEVEL for $COST"), "OBJECT", self:getName(), "LEVEL", maxLevel, "COST", upgradeCost), fonts.get("pix20"), progressingObjectBase.upgradeObjectCallback)
		
		option.object = self
	end
	
	if DEBUG_MODE then
		local option = combobox:addOption(0, 0, 0, 24, "+1 level", fonts.get("pix20"), progressingObjectBase.levelUpCallback)
		
		option.object = self
	end
	
	self:addUpgradeAllObjectsOption(combobox)
end

function progressingObjectBase:getUpgradeAllText()
	return _T("UPGRADE_ALL_OBJECTS_TO_LEVEL", "Upgrade all to level LEVEL for COST")
end

function progressingObjectBase:addUpgradeAllObjectsOption(combobox)
	local canProg, maxLevel = self:canIncreaseProgress()
	local totalCost = 0
	local canProgress = false
	
	for key, object in ipairs(studio:getOwnedObjects()) do
		if object.class == self.class and object:canIncreaseProgress() then
			totalCost = totalCost + object:getUpgradeCost(maxLevel)
			canProgress = true
		end
	end
	
	if canProgress then
		local option = combobox:addOption(0, 0, 0, 24, _format(self:getUpgradeAllText(), "LEVEL", maxLevel, "COST", string.roundtobigcashnumber(totalCost)), fonts.get("pix20"), progressingObjectBase.upgradeAllObjectsCallback)
		
		option.totalCost = totalCost
		option.targetLevel = maxLevel
		option.object = self
	end
end

function progressingObjectBase:isProgressionUnlocked(level)
	local progressionData = self.progression[level]
	
	if progressionData.date and not timeline:hasYearReachedDate(timeline:getYear(), timeline:getMonth(), progressionData.date.year, progressionData.date.month) then
		return false
	end
	
	return true
end

function progressingObjectBase:getLatestProgression()
	local latest = 0
	
	for key, progressData in ipairs(self.progression) do
		if self:isProgressionUnlocked(key) then
			latest = math.max(latest, key)
		end
	end
	
	return latest
end

function progressingObjectBase:addToPurchaseMenu(scroller, w, h, categoryId, categoryKey)
	local progression = self:getLatestProgression()
	
	if not progression or progression == 0 then
		return 
	end
	
	local icon = gui.create("ObjectPurchaseButton")
	
	icon:setSize(w, h)
	icon:setProgression(progression)
	icon:setPurchaseData(categoryId, categoryKey)
	scroller:addItem(icon)
	
	return icon
end

function progressingObjectBase:getProgressionCost(level)
	return self.progression[level].cost
end

function progressingObjectBase:save()
	local saved = progressingObjectBase.baseClass.save(self)
	
	saved.progressionLevel = self.progressionLevel
	
	return saved
end

function progressingObjectBase:load(data)
	self.progressionLevel = data.progressionLevel or math.random(1, #self.progression)
	
	progressingObjectBase.baseClass.load(self, data)
end

objects.registerNew(progressingObjectBase, "complex_monthly_cost_object_base")
