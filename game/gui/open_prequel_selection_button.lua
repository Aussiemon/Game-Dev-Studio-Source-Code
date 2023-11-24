local openPrequelList = {}

openPrequelList.highlightColor = color(0, 0, 0, 255):duplicate()

local button = gui.getElementType("Button")

openPrequelList.startColor = button.skinPanelFillColor
openPrequelList.finishColor = button.skinPanelSelectColor

function openPrequelList:init()
	self.removePrequelButton = gui.create("RemoveSelectedPrequelButton", self)
end

function openPrequelList:onSizeChanged()
	openPrequelList.baseClass.onSizeChanged(self)
	self.removePrequelButton:setSize(self.rawH - 4, self.rawH - 4)
	self.removePrequelButton:setPos(self.w - self.removePrequelButton.w - _S(2), _S(2))
end

function openPrequelList:setProject(obj)
	self.project = obj
	
	self.removePrequelButton:setProject(obj)
	self:updateText()
	self:updateInheritButtonState()
end

function openPrequelList:updateInheritButtonState()
	if self.inheritButton then
		if not self.project:getSequelTo() then
			self.inheritButton:setCanClick(false)
		else
			self.inheritButton:setCanClick(true)
		end
		
		self.inheritButton:queueSpriteUpdate()
	end
end

function openPrequelList:setInheritButton(button)
	self.inheritButton = button
	
	self:updateInheritButtonState()
end

function openPrequelList:think()
	if self.highlighted then
		openPrequelList.highlightColor:lerpFromTo(math.sin(self.flashTime), openPrequelList.startColor, openPrequelList.finishColor)
		
		self.flashTime = self.flashTime + frameTime * 3
		
		if self.flashTime >= math.pi then
			self.flashTime = self.flashTime - math.pi
		end
		
		self:queueSpriteUpdate()
	end
end

function openPrequelList:highlight()
	self.highlighted = true
	self.flashTime = 0
end

function openPrequelList:unhighlight()
	self.highlighted = false
	self.flashTime = 0
	
	self:queueSpriteUpdate()
end

function openPrequelList:getStateColor()
	local pCol, tCol = openPrequelList.baseClass.getStateColor(self)
	
	if self.highlighted then
		return openPrequelList.highlightColor, tCol
	end
	
	return pCol, tCol
end

function openPrequelList:updateText()
	if self.project:getSequelTo() then
		self:setText(string.easyformatbykeys(_T("SELECTED_PREQUEL", "Prequel: GAME_NAME"), "GAME_NAME", self.project:getSequelTo():getName()))
		self:setAlignment(openPrequelList.LEFT)
	else
		self:setText(_T("SELECT_RELATED_GAME", "Select related game"))
		self:setAlignment(openPrequelList.MIDDLE)
	end
	
	self.removePrequelButton:updateVisibility()
end

function openPrequelList:getMaxTextWidth()
	if self.project and self.project:getSequelTo() then
		return self.w - _S(10) - self.removePrequelButton:getWidth()
	end
	
	return self.w - _S(6)
end

function openPrequelList:updateElement()
	self:updateText()
	self:updateInheritButtonState()
end

function openPrequelList:onClick(x, y, key)
	if key == gui.mouseKeys.RIGHT then
		self.project:setSequelTo(nil)
		self:updateText()
		self:updateInheritButtonState()
	else
		self.project:createPrequelSelectionMenu()
	end
end

gui.register("OpenPrequelSelectionButton", openPrequelList, "Button")
