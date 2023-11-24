local taskGradient = {}

taskGradient.progressBarHeight = 8
taskGradient.progressBarInnerSpacing = 1
taskGradient.progressBarOffset = 1
taskGradient.progressBarHorizontalOffset = 2

function taskGradient:init(employee)
	self.employee = employee
	self.taskObject = self.employee:getTask()
end

function taskGradient:handleEvent(event, employee)
end

function taskGradient:updateSprites()
	taskGradient.baseClass.updateSprites(self)
	
	if self.taskObject then
		local verticalOffset = self:getProgressBarVerticalSpace()
		
		self:setNextSpriteColor(0, 0, 0, 255)
		
		self.progressBarOuter = self:allocateSprite(self.progressBarOuter, "generic_1px", _S(self.progressBarHorizontalOffset), self.h - _S(verticalOffset), 0, self.rawW - self.progressBarHorizontalOffset, self.progressBarHeight, 0, 0, -0.1)
		
		self:setNextSpriteColor(184, 232, 118, 255)
		
		self.progressBarInner = self:allocateSprite(self.progressBarInner, "generic_1px", _S(self.progressBarHorizontalOffset + self.progressBarInnerSpacing), self.h - _S(verticalOffset) + _S(self.progressBarInnerSpacing), 0, (self.rawW - self.progressBarHorizontalOffset - self.progressBarInnerSpacing * 2) * self.taskObject:getCompletionDisplay(), self.progressBarHeight - self.progressBarInnerSpacing * 2, 0, 0, -0.1)
	end
end

function taskGradient:getProgressBarVerticalSpace()
	return self.progressBarHeight + self.progressBarOffset
end

function taskGradient:getBackdropSpriteSize()
	if self.taskObject then
		return math.max(self.rawH, self.backdropSize) - _S(self:getProgressBarVerticalSpace())
	end
	
	return math.max(self.rawH, self.backdropSize)
end

function taskGradient:getIconSize()
	if self.taskObject then
		local largest = math.max(self.iconRenderW, self.iconRenderH)
		local largestResized = largest - _S(self:getProgressBarVerticalSpace())
		local scale = largestResized / largest
		
		return self.iconRenderW * scale, self.iconRenderH * scale
	end
	
	return self.iconRenderW, self.iconRenderH
end

function taskGradient:getTextY()
	if self.taskObject then
		return self.textDrawHeight - _S(1) - self:getProgressBarVerticalSpace() * 0.5
	end
	
	return self.textDrawHeight - _S(1)
end

gui.register("TaskGradientIconPanel", taskGradient, "GradientIconPanel")
