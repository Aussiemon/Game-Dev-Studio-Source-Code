local bar = {}

bar.id = "progress_bar_task"
bar.fillerColor = color(177, 204, 155, 255)
bar.spriteBorder = 3

function bar:init()
	self.barVisible = true
end

function bar:setSize(w, h)
	self.w = w
	self.h = h
end

function bar:setFillerColor(r, g, b, a)
	self.fillerColor = color(r, g, b, a)
end

function bar:setText(text)
	self.text = text
end

function bar:getText()
	return self.text
end

function bar:setBarVisible(vis)
	self.barVisible = vis
end

function bar:onSetAssignee()
	if not self.barVisible then
		return 
	end
	
	if self.assignee then
		if self.assignee:getEmployer() == studio and self.assignee:canBeRendered() then
			self:allocateSprites()
		end
	else
		self:deallocateSprites()
	end
end

function bar:getCompletionDisplay()
	return self:getCompletion()
end

function bar:allocateSprites()
	if self.progressBarSprite then
		return 
	end
	
	self.container = spriteBatchController:getContainer("world_ui")
	self.containerTwo = spriteBatchController:getContainer("world_ui_2")
	self.barQuad = quadLoader:getQuad("progress_bar")
	self.pixelQuad = quadLoader:getQuad("vertical_gradient_75")
	self.spriteW, self.spriteH = self.barQuad:getSize()
	
	local data = quadLoader:getQuadStructure("vertical_gradient_75")
	
	self.fillHeight = (self.spriteH - self.spriteBorder * 2) / data.h
	self.progressBarSprite = self.container:allocateSlot()
	self.progressBarFillSprite = self.containerTwo:allocateSlot()
	
	self.container:increaseVisibility()
	self.containerTwo:increaseVisibility()
end

function bar:deallocateSprites()
	if self.progressBarSprite then
		self.container:deallocateSlot(self.progressBarSprite)
		self.containerTwo:deallocateSlot(self.progressBarFillSprite)
		self.container:decreaseVisibility()
		self.containerTwo:decreaseVisibility()
		
		self.progressBarSprite = nil
		self.progressBarFillSprite = nil
	end
end

function bar:enterVisibilityRange()
	self:allocateSprites()
end

function bar:leaveVisibilityRange()
	self:deallocateSprites()
end

function bar:cancel()
	bar.baseClass.cancel(self)
	self:deallocateSprites()
end

function bar:onFinish()
	bar.baseClass.onFinish(self)
	
	if self:getUnassignOnFinish() then
		self:deallocateSprites()
	end
end

function bar:remove()
	bar.baseClass.remove(self)
	self:deallocateSprites()
end

function bar:draw(assignee)
	local x, y = assignee:getAvatar():getDrawPosition()
	local w, h = assignee:getSize()
	
	x = x - w
	y = y + 15
	
	self.container:setColor(255, 255, 255, 255)
	self.container:updateSprite(self.progressBarSprite, self.barQuad, x, y - 10)
	
	local colors = self.fillerColor
	
	self.containerTwo:setColor(colors.r, colors.g, colors.b, colors.a)
	self.containerTwo:updateSprite(self.progressBarFillSprite, self.pixelQuad, x + self.spriteBorder, y - (10 - self.spriteBorder), 0, (self.spriteW - self.spriteBorder * 2) * self:getCompletionDisplay(), self.fillHeight)
	self.containerTwo:resetColor()
end

task:registerNew(bar)
