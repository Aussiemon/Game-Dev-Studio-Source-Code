local engineSellingSelection = {}

function engineSellingSelection:init()
end

function engineSellingSelection:getEngine()
	return self.engine
end

function engineSellingSelection:setEngine(engine)
	self.engine = engine
	
	self:createInfoLists()
end

function engineSellingSelection:createInfoLists()
	local releaseDate = self.engine:getReleaseDate()
	local cost = self.engine:getCost()
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
	nameDisplay:setGradientColor(self.gradientColor)
	
	local attractivenessDisplay = self.engine:createAttractivenessDisplay(self.leftList)
	
	attractivenessDisplay:setTextColor(game.UI_COLORS.IMPORTANT_1)
	attractivenessDisplay:setFont("bh20")
	attractivenessDisplay:setBaseSize(baseElementSize, 0)
	attractivenessDisplay:setBackdropSize(backdropSize)
	attractivenessDisplay:setIconSize(22, nil)
	attractivenessDisplay:setIconOffset(-2, 1)
	self.leftList:updateLayout()
	
	self.rightList = gui.create("List", self)
	
	self.rightList:setPos(self.leftList.localX + self.leftList.w)
	self.rightList:setPanelColor(developer.employeeMenuListColor)
	self.rightList:setCanHover(false)
	
	self.rightList.shouldDraw = false
	
	local featureCountDisplay = gui.create("GradientIconPanel", self.rightList)
	
	featureCountDisplay:setIcon("skill_development")
	featureCountDisplay:setFont("pix20")
	featureCountDisplay:setText(_format(_T("ENGINE_FEATURE_COUNT", "FEATURES Features"), "FEATURES", self.engine:getFeatureCount()))
	featureCountDisplay:setBaseSize(baseElementSize, 0)
	featureCountDisplay:setIconSize(iconSize, iconSize)
	featureCountDisplay:setBackdropSize(backdropSize)
	featureCountDisplay:setIconOffset(1, 1)
	
	local moneyMade = gui.create("GradientIconPanel", self.rightList)
	
	moneyMade:setIcon("wad_of_cash_plus")
	moneyMade:setFont("pix20")
	moneyMade:setText(_format(_T("ENGINE_MONEY_MADE", "MONEY made"), "MONEY", string.roundtobigcashnumber(self.engine:getMoneyMade())))
	moneyMade:setBaseSize(baseElementSize, 0)
	moneyMade:setIconSize(iconSize, iconSize)
	moneyMade:setBackdropSize(backdropSize)
	moneyMade:setIconOffset(1, 1)
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

function engineSellingSelection:onClick(x, y, key)
	events:fire(engineLicensing.EVENTS.ENGINE_SELECTED, self.engine)
end

function engineSellingSelection:onMouseEntered()
	engineSellingSelection.baseClass.onMouseEntered(self)
	gui:getElementByID(projectsMenu.SELLABLE_ENGINE_INFO):setEngine(self.engine)
end

function engineSellingSelection:onMouseLeft()
	engineSellingSelection.baseClass.onMouseLeft(self)
	gui:getElementByID(projectsMenu.SELLABLE_ENGINE_INFO):hideDisplay()
end

function engineSellingSelection:onKill()
	self:killDescBox()
end

function engineSellingSelection:draw(w, h)
end

gui.register("EngineSellingSelection", engineSellingSelection, "EngineLicensingSelection")
