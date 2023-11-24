local appearanceAdjustmentButton = {}

appearanceAdjustmentButton.mouseOverColor = color(255, 255, 255, 255)
appearanceAdjustmentButton.mouseNotOverColor = color(140, 140, 140, 255)
appearanceAdjustmentButton.inactiveColor = color(100, 100, 100, 255)

function appearanceAdjustmentButton:setDirection(dir)
	self.direction = dir
	
	self:onSetDirection()
end

function appearanceAdjustmentButton:setColorAdjustment(state)
	self.colorAdjustment = state
end

function appearanceAdjustmentButton:setFemale(female)
	self.female = female
end

function appearanceAdjustmentButton:getPartType()
	return self.partType
end

function appearanceAdjustmentButton:onSetDirection()
	local part = self:getPart()
	
	if part then
		local data, key = portrait.findPartDataIndex(part, self.female)
		
		self:getParent():setCurrentPartIndex(key)
		
		self.partType = data.part
	end
end

function appearanceAdjustmentButton:setPartType(type)
	if not self.partType then
		self:getParent():setCurrentPartIndex(0)
	end
	
	self.partType = type
end

function appearanceAdjustmentButton:onClick(x, y, key)
	local parent = self:getParent()
	local employee = parent:getEmployee()
	local portrait = employee:getPortrait()
	
	self:clickedCallback(portrait)
end

function appearanceAdjustmentButton:verifyAdjustmentValidity()
	return true
end

function appearanceAdjustmentButton:setIconOverride(icon)
	self.iconOverride = icon
end

function appearanceAdjustmentButton:loopIndex(index, total)
	if total < index then
		if portrait.OPTIONAL_PARTS[self.partType] then
			return 0
		else
			return 1
		end
	elseif index < 1 then
		if portrait.OPTIONAL_PARTS[self.partType] and index == 0 then
			return 0
		else
			return total
		end
	end
	
	return index
end

function appearanceAdjustmentButton:handleEvent(event, employee)
	local ourEmployee = self:getParent():getEmployee()
	
	if employee ~= ourEmployee then
		return 
	end
	
	self.female = employee:isFemale()
	
	local parent = self:getParent()
	
	parent:setFemale(self.female)
	
	if self.colorAdjustment then
		parent:setCurrentColorIndex(1)
	else
		parent:setCurrentPartIndex(1)
	end
end

function appearanceAdjustmentButton:getPartList()
	if self.female then
		return portrait.registeredDataByPart.female
	end
	
	return portrait.registeredDataByPart.male
end

function appearanceAdjustmentButton:advanceStep()
	local parent = self:getParent()
	local portraitObj = parent:getEmployee():getPortrait()
	local partList = self:getPartList()[self.partType]
	local currentIndex
	
	if self.colorAdjustment then
		currentIndex = parent:getCurrentColorIndex()
	else
		currentIndex = parent:getCurrentPartIndex()
	end
	
	local partCount = #partList
	
	currentIndex = self:loopIndex(currentIndex + self.direction, partCount)
	
	if currentIndex ~= 0 and not portraitObj:isValidForFace(partList[currentIndex]) then
		local startIndex = currentIndex
		
		repeat
			currentIndex = self:loopIndex(currentIndex + self.direction, partCount)
			
			if currentIndex == 0 or portraitObj:isValidForFace(partList[currentIndex]) or currentIndex == startIndex then
				break
			end
			
			if false then
				break
			end
		until false
	end
	
	if self.colorAdjustment then
		parent:setCurrentColorIndex(currentIndex)
	else
		parent:setCurrentPartIndex(currentIndex)
	end
	
	return partList[currentIndex]
end

function appearanceAdjustmentButton:clickedCallback(portrait)
end

function appearanceAdjustmentButton:onMouseEntered()
	self:queueSpriteUpdate()
end

function appearanceAdjustmentButton:onMouseLeft()
	self:queueSpriteUpdate()
end

function appearanceAdjustmentButton:getPart()
	return nil
end

function appearanceAdjustmentButton:updateSprites()
	local clr
	
	if not self.canClick then
		clr = self.inactiveColor
	else
		clr = self:isMouseOver() and self.mouseOverColor or self.mouseNotOverColor
	end
	
	local x, sizeX
	
	if self.iconOverride then
		x = 0
		sizeX = self.rawW
	elseif self.direction < 0 then
		x = 0
		sizeX = self.rawW
	else
		x = self.w
		sizeX = -self.rawW
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.iconSprite = self:allocateSprite(self.iconSprite, self.iconOverride or "previous", x, 0, 0, sizeX, self.rawH, 0, 0, 0.1)
end

gui.register("AppearanceAdjustmentButton", appearanceAdjustmentButton)
require("game/gui/character_designer/hair_adjustment_button")
require("game/gui/character_designer/nose_adjustment_button")
require("game/gui/character_designer/eye_adjustment_button")
require("game/gui/character_designer/skin_color_adjustment_button")
require("game/gui/character_designer/randomize_appearance_button")
require("game/gui/character_designer/eye_color_adjustment_button")
require("game/gui/character_designer/eyebrow_adjustment_button")
require("game/gui/character_designer/face_adjustment_button")
require("game/gui/character_designer/facial_hair_adjustment_button")
require("game/gui/character_designer/glasses_adjustment_button")
require("game/gui/character_designer/shirt_adjustment_button")
