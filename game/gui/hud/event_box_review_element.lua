local element = {}

element.textColor = color(255, 255, 255, 255)
element.textShadowColor = color(0, 0, 0, 255)

function element:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or element.textColor
	self.textShadowColor = textShadowColor or element.textShadowColor
	self.alpha = 1
	self.icon = "exclamation_point"
end

function element:setReview(review)
	self.review = review
end

function element:fillInteractionComboBox(comboBox)
	self.review:fillInteractionComboBox(comboBox)
	self:setFlash(false)
end

function element:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x - _S(20), y - _S(10))
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function element:saveData()
	local data = element.baseClass.saveData(self)
	
	return data
end

function element:loadData(data)
	element.baseClass.loadData(self, data)
end

gui.register("EventBoxReviewElement", element, "EventBoxElement")
