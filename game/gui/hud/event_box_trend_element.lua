local element = {}

element.textColor = color(255, 255, 255, 255)
element.textShadowColor = color(0, 0, 0, 255)

function element:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or element.textColor
	self.textShadowColor = textShadowColor or element.textShadowColor
	self.alpha = 1
end

function element:setTrendData(trendType, trendID)
	self.trendType = trendType
	self.trendID = trendID
end

function element:saveData()
	local saved = element.baseClass.saveData(self)
	
	saved.trendType = self.trendType
	saved.trendID = self.trendID
	
	return saved
end

function element:loadData(data)
	element.baseClass.loadData(self, data)
	self:setTrendData(data.trendType, data.trendID)
end

local function onClicked(self)
	trends:createTrendingPopup(self.tree.baseButton.trendType, self.tree.baseButton.trendID)
end

function element:fillInteractionComboBox(comboBox)
	comboBox:addOption(0, 0, 0, 0, _T("MORE_INFO", "More info"), fonts.get("pix20"), onClicked)
end

function element:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x - 20, y)
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	
	comboBox.baseButton = self
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

gui.register("EventBoxTrendElement", element, "EventBoxElement")
