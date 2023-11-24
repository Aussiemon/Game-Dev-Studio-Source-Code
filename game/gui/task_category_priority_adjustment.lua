taskPriority = {}
taskPriority.baseText = _T("CATEGORY_COMPLEXITY", "Complexity SLIDER_VALUE%")
taskPriority.valueMult = 100
taskPriority.mouseWheelIncrement = 0.01
taskPriority.arrowKeyIncrement = 0.05
taskPriority.centerTextX = false
taskPriority.CATCHABLE_EVENTS = {
	gameProject.EVENTS.CATEGORY_PRIORITY_CHANGED
}

function taskPriority:init()
end

function taskPriority:handleEvent(event)
	if not self.suppress then
		self.value = self.task:getProject():getCategoryPriority(self.categoryType)
		
		self:updateText()
		self:queueSpriteUpdate()
	end
end

function taskPriority:setCategoryUIObject(task)
	self.task = task
	self.categoryType = self.task:getCategory()
	
	self:setFont("bh18")
end

function taskPriority:onSetValue()
	self.suppress = true
	
	self.task:getProject():setCategoryPriority(self.categoryType, self.value)
	
	self.suppress = false
end

function taskPriority:onScroll(xVel, yVel)
	self:setValue(self.value - self.mouseWheelIncrement * yVel)
end

function taskPriority:onMouseEntered()
	taskPriority.baseClass.onMouseEntered(self)
	self:setupDescbox()
end

function taskPriority:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("CATEGORY_PRIORITY_DESCRIPTION", "Affects time spent on tasks and gained Quality points in this category"), "bh18", nil, 0, 300, "question_mark", 22, 22)
	self.descBox:centerToElement(self)
end

function taskPriority:onMouseLeft()
	taskPriority.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function taskPriority:canSelect()
	return false
end

function taskPriority:onKeyPress(key)
	if key == keyBinding.ARROW_KEYS.LEFT then
		self:setValue(self.value - self.arrowKeyIncrement)
	elseif key == keyBinding.ARROW_KEYS.RIGHT then
		self:setValue(self.value + self.arrowKeyIncrement)
	end
end

function taskPriority:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	self:setNextSpriteColor(60, 60, 60, 255)
	
	self.innerSprite = self:allocateSprite(self.innerSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.5)
	
	local minMaxDist = self:getProgressToMax()
	local displayPercentage = math.min(math.max((self.value - self.minValue) / minMaxDist, 0), 1)
	
	self:setNextSpriteColor(game.UI_COLORS.LIGHT_BLUE:unpack())
	
	self.barSprite = self:allocateSprite(self.barSprite, "vertical_gradient_75", _S(1), _S(1), 0, (self.rawW - 2) * displayPercentage, self.rawH - 2, 0, 0, -0.5)
end

function taskPriority:draw(w, h)
	local minMaxDist = self:getProgressToMax()
	local displayPercentage = math.min(math.max((self.value - self.minValue) / minMaxDist, 0), 1)
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self:getTextX(), self:getTextY())
end

gui.register("TaskCategoryPriorityAdjustment", taskPriority, "Slider")
