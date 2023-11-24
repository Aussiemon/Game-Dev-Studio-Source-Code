local objectiveTaskDisplay = {}

objectiveTaskDisplay.backgroundColor = color(73, 89, 114, 255)
objectiveTaskDisplay.completionIconSpacing = 2
objectiveTaskDisplay.textSpacing = 5
objectiveTaskDisplay.completedTextColor = color(181, 216, 153, 255)

function objectiveTaskDisplay:setDisplayData(displayData)
	self.displayData = displayData
end

function objectiveTaskDisplay:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.fontHeight = self.fontObject:getHeight()
end

function objectiveTaskDisplay:initVisual()
	self.fontObject = fonts.get("pix20")
	self.fontHeight = self.fontObject:getHeight()
end

function objectiveTaskDisplay:onMouseEntered()
	if self.displayData.description then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.displayData.description) do
			self.descBox:addText(data.text, data.font, data.color, data.lineSpace, 500)
		end
		
		self.descBox:centerToElement(self)
	end
end

function objectiveTaskDisplay:onMouseLeft()
	self:killDescBox()
end

function objectiveTaskDisplay:updateSprites()
	self:setNextSpriteColor(objectiveTaskDisplay.backgroundColor:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local smallest = math.min(self.rawW, self.rawH)
	local scaledSpacing = _S(objectiveTaskDisplay.completionIconSpacing)
	
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, "checkbox_off", 0, 0, 0, smallest, smallest, 0, 0, -0.1)
	
	local icon
	
	if self.displayData.icon then
		icon = self.displayData.icon
	else
		icon = self.displayData.completed and "checkmark" or "close_button"
	end
	
	if self.displayData.iconColor then
		self:setNextSpriteColor(self.displayData.iconColor:unpack())
	end
	
	self.stateSprite = self:allocateSprite(self.stateSprite, icon, scaledSpacing, scaledSpacing, 0, smallest - objectiveTaskDisplay.completionIconSpacing * 2, smallest - objectiveTaskDisplay.completionIconSpacing * 2, 0, 0, -0.1)
	self.textX = _S(smallest + objectiveTaskDisplay.textSpacing)
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
end

function objectiveTaskDisplay:draw(w, h)
	local tCol
	
	if self.displayData.completed then
		tCol = self.completedTextColor
	else
		tCol = select(2, self:getStateColor())
	end
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayData.text, self.textX, self.textY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

gui.register("ObjectiveTaskDisplay", objectiveTaskDisplay)
