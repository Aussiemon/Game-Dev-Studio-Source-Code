local skillChange = {}

skillChange.displayTexture = cache.getImage("textures/icons/change.png")
skillChange.iconSize = 24
skillChange.skinPanelFillColor = color(65, 65, 65, 255)
skillChange.skinPanelHoverColor = color(175, 160, 75, 255)
skillChange.skinPanelSelectColor = color(125, 175, 125, 255)
skillChange.skinPanelDisableColor = color(45, 45, 45, 255)
skillChange.skinTextFillColor = color(220, 220, 220, 255)
skillChange.skinTextHoverColor = color(240, 240, 240, 255)
skillChange.skinTextSelectColor = color(255, 255, 255, 255)
skillChange.skinTextDisableColor = color(150, 150, 150, 255)

function skillChange:init()
	skillChange.font = fonts.get("pix24")
	skillChange.fontHeight = skillChange.font:getHeight()
	skillChange.fontWidth = skillChange.fontHeight * 6
end

function skillChange:setSkill(skill, level)
	self.skill = skill
	self.curLevel = level
	self.displayText = skills.registeredByID[skill].display
	self.iconScale = skillChange.displayTexture:getScaleToSize(skillChange.iconSize)
	self.textY = (self.h - skillChange.fontHeight) * 0.5
end

function skillChange:isDisabled()
	return false
end

function skillChange:setPreviousSkill(skill)
	self.prevLevel = skill
end

function skillChange:onMouseEntered()
	self:queueSpriteUpdate()
end

function skillChange:onMouseLeft()
	self:queueSpriteUpdate()
end

function skillChange:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, 5, self.textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, textColor.a)
	love.graphics.printST(self.prevLevel, skillChange.fontWidth + 5, self.textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, textColor.a)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(skillChange.displayTexture, skillChange.fontWidth + 55 + skillChange.iconSize * 0.5, (h - skillChange.iconSize) / 2, 0, self.iconScale, self.iconScale)
	love.graphics.printST(self.curLevel, skillChange.fontWidth + 105 + skillChange.iconSize, self.textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, textColor.a)
end

gui.register("SkillChangeDisplay", skillChange)
skillChange:copyPanelSkinColorsOfElement("Button")

skillChange.updateSprites = gui.getClassTable("Button").updateSprites
