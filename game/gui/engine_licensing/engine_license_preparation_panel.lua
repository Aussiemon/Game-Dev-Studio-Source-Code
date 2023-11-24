local licensePrepPanel = {}

licensePrepPanel.CATCHABLE_EVENTS = {
	engineLicensing.EVENTS.ENGINE_SELECTED
}
licensePrepPanel.panelHorizontalSpacing = 5
licensePrepPanel.drawColor = color(0, 0, 0, 150)

function licensePrepPanel:createDisplays()
	local competitor = engineLicensing:getBestEngine() or engine
	local unscaledBaseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing
	local baseElementSize = _S(unscaledBaseElementSize)
	local iconSize = 22
	local backdropSize = 24
	local compName = gui.create("GradientIconPanel", self)
	
	compName:setFont("bh20")
	compName:setIcon("radio_on_red")
	compName:setText(_format(_T("ENGINE_COMPETITOR_NAME", "Competitor: NAME"), "NAME", competitor:getName() or _T("ENGINE_COMPETITOR_NONE", "None")))
	compName:setBaseSize(self.w - _S(10), 0)
	compName:setBackdropVisible(false)
	compName:setIconSize(iconSize, iconSize)
	compName:setIconOffset(1, 0)
	
	local attrDisp = competitor:createAttractivenessDisplay(self)
	
	attrDisp:setBaseSize(baseElementSize, 0)
	attrDisp:setPos(compName.x + _S(3), compName.localY + compName.h + _S(3))
	attrDisp:setBackdropSize(backdropSize)
	attrDisp:setIconSize(iconSize, nil)
	attrDisp:setIconOffset(-2, 1)
	
	local costDisplay = competitor:createCostDisplay(self)
	
	costDisplay:setBaseSize(baseElementSize, 0)
	costDisplay:setIconSize(iconSize, iconSize)
	costDisplay:setBackdropSize(backdropSize)
	costDisplay:setIconOffset(1, 1)
	costDisplay:setPos(self.w - baseElementSize - _S(3), attrDisp.localY)
	
	local ourName = gui.create("GradientIconPanel", self)
	
	ourName:setFont("bh20")
	ourName:setIcon("radio_off")
	ourName:setBaseSize(self.w - _S(10), 0)
	ourName:setBackdropVisible(false)
	ourName:setIconSize(iconSize, iconSize)
	ourName:setIconOffset(1, 0)
	ourName:setPos(compName.localX, attrDisp.localY + attrDisp.h + _S(5))
	
	self.playerEngineName = ourName
	
	local soldEngine = engine
	local ourAttrDisp = soldEngine:createAttractivenessDisplay(self)
	
	ourAttrDisp:setBaseSize(baseElementSize, 0)
	ourAttrDisp:setPos(ourName.x + _S(3), ourName.localY + ourName.h + _S(3))
	ourAttrDisp:setBackdropSize(backdropSize)
	ourAttrDisp:setIconSize(iconSize, nil)
	ourAttrDisp:setIconOffset(-2, 1)
	
	self.ourAttractivenessDisplay = ourAttrDisp
	
	local featureCountDisplay = gui.create("GradientIconPanel", self)
	
	featureCountDisplay:setIcon("skill_development")
	featureCountDisplay:setFont("pix20")
	featureCountDisplay:setText(soldEngine:getFeatureCountText())
	featureCountDisplay:setBaseSize(baseElementSize, 0)
	featureCountDisplay:setIconSize(iconSize, iconSize)
	featureCountDisplay:setBackdropSize(backdropSize)
	featureCountDisplay:setIconOffset(1, 1)
	featureCountDisplay:setPos(self.w - baseElementSize - _S(3), ourAttrDisp.localY)
	
	self.featureCountDisplay = featureCountDisplay
	
	local costTextbox = gui.create("EngineLicenseCostTextbox", self)
	
	costTextbox:setSize(unscaledBaseElementSize, 26)
	costTextbox:setFont("pix22")
	costTextbox:setGhostText(_T("ENTER_ENGINE_PRICE", "Enter engine price"))
	costTextbox:setPos(_S(3), featureCountDisplay.y + featureCountDisplay.h + _S(3))
	
	self.engineCostTextbox = costTextbox
	
	local startSellingButton = gui.create("StartSellingEngineButton", self)
	
	startSellingButton:setPos(costTextbox.localX + costTextbox.w + _S(4), costTextbox.localY)
	startSellingButton:setSize(unscaledBaseElementSize, 26)
	startSellingButton:setFont("bh22")
	startSellingButton:setCostTextbox(self.engineCostTextbox)
	startSellingButton:setTargetEngine(studio:getSoldEngine())
	costTextbox:setStartSellingButton(startSellingButton)
	
	self.startSellingButton = startSellingButton
	
	self:setHeight(_US(costTextbox.y) + costTextbox.rawH + 3)
	self:updatePlayerDisplays()
end

function licensePrepPanel:handleEvent(event, engineObj)
	local oldEngine = self.selectedEngine
	
	if engineObj == oldEngine then
		return 
	end
	
	self.selectedEngine = engineObj
	
	if engineObj == oldEngine then
		return 
	end
	
	self.engineCostTextbox:setText(engineObj:getCost() or "")
	self.startSellingButton:setTargetEngine(engineObj)
	self:updatePlayerDisplays()
end

function licensePrepPanel:updatePlayerDisplays()
	if self.selectedEngine then
		self.playerEngineName:setText(_format(_T("SELECTED_ENGINE", "Selected: ENGINE"), "ENGINE", self.selectedEngine:getName()))
		self.ourAttractivenessDisplay:setText(self.selectedEngine:getAttractivenessText())
		self.featureCountDisplay:setText(self.selectedEngine:getFeatureCountText())
		self.playerEngineName:setIcon("radio_on")
	else
		self.playerEngineName:setText(_T("LICENSING_NO_ENGINE_SELECTED", "No engine selected"))
		self.playerEngineName:setIcon("radio_off")
	end
end

gui.register("EngineLicensePreparationPanel", licensePrepPanel, "Panel")
