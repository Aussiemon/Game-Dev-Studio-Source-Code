local function onClicked(self)
	self.baseButton:setScale(self.scaleID, self)
end

local scaleList = {}

function scaleList:init()
end

function scaleList:setScale(scaleID, element)
	self.project:setScale(scaleID)
	
	self.scaleID = scaleID
	
	self:updateText()
	
	for key, otherElement in ipairs(element.tree:getOptionElements()) do
		otherElement:highlight(otherElement.scaleID == scaleID)
	end
end

function scaleList:setProject(project)
	self.project = project
	
	self:updateText()
end

function scaleList:getProject()
	return self.project
end

function scaleList:onShow()
	self:updateText()
end

function scaleList:updateText()
	if self.scaleID then
		self:setText(project.SCALE_TRANSLATIONS[self.scaleID])
	else
		self:setText("Select scale")
	end
end

function scaleList:onClick()
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x, y + self.h)
	comboBox:setDepth(100)
	
	for key, data in ipairs(project.SCALE_TO_WORK) do
		local text = project.SCALE_TRANSLATIONS[key]
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, text, fonts.get("pix20"), onClicked)
		
		optionObject.scaleID = key
		optionObject.baseButton = self
		
		optionObject:highlight(self.project:getScale() == key)
		optionObject:setCloseOnClick(false)
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

gui.register("ScaleListComboBoxButton", scaleList, "Button")
