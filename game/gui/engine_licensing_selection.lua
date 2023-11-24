local engineLicensingSelection = {}

engineLicensingSelection.canPurchase = true

local function infoCallback(self)
	frameController:push(self.tree.baseButton:getEngine():createEngineInfoDisplay())
end

local function purchaseCallback(self)
	studio:purchaseEngineLicense(self.tree.baseButton:getEngine())
end

function engineLicensingSelection:init()
end

function engineLicensingSelection:getEngine()
	return self.engine
end

function engineLicensingSelection:setEngine(engine)
	self.engine = engine
	
	self:createInfoLists()
end

engineLicensingSelection.panelHorizontalSpacing = 3
engineLicensingSelection.gradientColor = color(83, 152, 209, 255)

function engineLicensingSelection:createInfoLists()
	local releaseDate = self.engine:getReleaseDate()
	local iconSize = 22
	local backdropSize = 24
	
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("pix20")
	nameDisplay:setText(self.engine:getName())
	nameDisplay:setHeight(26)
	nameDisplay:setGradientColor(engineLicensingSelection.gradientColor)
	
	local costDisplay = self.engine:createCostDisplay(self.leftList)
	
	costDisplay:setBaseSize(baseElementSize, 0)
	costDisplay:setIconSize(iconSize, iconSize)
	costDisplay:setBackdropSize(backdropSize)
	costDisplay:setIconOffset(1, 1)
	self.leftList:updateLayout()
	
	self.rightList = gui.create("List", self)
	
	self.rightList:setPos(self.leftList.localX + self.leftList.w)
	self.rightList:setPanelColor(developer.employeeMenuListColor)
	self.rightList:setCanHover(false)
	
	self.rightList.shouldDraw = false
	
	local releaseDateDisplay = gui.create("GradientIconPanel", self.rightList)
	
	releaseDateDisplay:setIcon("clock_full")
	releaseDateDisplay:setFont("pix20")
	releaseDateDisplay:setText(_format(_T("ENGINE_RELEASED_ON", "Released on: YEAR/MONTH"), "YEAR", timeline:getYear(releaseDate), "MONTH", timeline:getMonth(releaseDate)))
	releaseDateDisplay:setBaseSize(baseElementSize, 0)
	releaseDateDisplay:setIconSize(iconSize, iconSize)
	releaseDateDisplay:setBackdropSize(backdropSize)
	releaseDateDisplay:setIconOffset(1, 1)
	
	local featureCountDisplay = gui.create("GradientIconPanel", self.rightList)
	
	featureCountDisplay:setIcon("skill_development")
	featureCountDisplay:setFont("pix20")
	featureCountDisplay:setText(_format(_T("ENGINE_FEATURE_COUNT", "FEATURES Features"), "FEATURES", self.engine:getFeatureCount()))
	featureCountDisplay:setBaseSize(baseElementSize, 0)
	featureCountDisplay:setIconSize(iconSize, iconSize)
	featureCountDisplay:setBackdropSize(backdropSize)
	featureCountDisplay:setIconOffset(1, 1)
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

function engineLicensingSelection:setCanPurchase(can)
	self.canPurchase = can
end

function engineLicensingSelection:onMouseEntered()
	engineLicensingSelection.baseClass.onMouseEntered(self)
	gui:getElementByID(projectsMenu.LICENSEABLE_ENGINE_INFO):setEngine(self.engine)
end

function engineLicensingSelection:onMouseLeft()
	engineLicensingSelection.baseClass.onMouseLeft(self)
	gui:getElementByID(projectsMenu.LICENSEABLE_ENGINE_INFO):hideDisplay()
end

function engineLicensingSelection:fillInteractionComboBox(comboBox)
	comboBox.baseButton = self
	
	comboBox:addOption(0, 0, 200, 25, _T("ENGINE_INFO", "Engine info"), fonts.get("pix20"), infoCallback)
	
	if self.canPurchase then
		comboBox:addOption(0, 0, 200, 25, _T("PURCHASE_ENGINE_LICENSE", "Purchase engine license"), fonts.get("pix20"), purchaseCallback)
	end
end

function engineLicensingSelection:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 10, y + 5)
end

function engineLicensingSelection:onKill()
	self:killDescBox()
end

function engineLicensingSelection:draw(w, h)
end

gui.register("EngineLicensingSelection", engineLicensingSelection, "GenericElement")
