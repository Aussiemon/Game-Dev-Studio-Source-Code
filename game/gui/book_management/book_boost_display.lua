local bookBoostDisplay = {}

bookBoostDisplay.skinTextFillColor = color(200, 200, 200, 255)
bookBoostDisplay.skinTextHoverColor = color(255, 255, 255, 255)
bookBoostDisplay.baseColorInactive = color(86, 104, 135, 255)
bookBoostDisplay.baseColor = color(163, 176, 198, 255)
bookBoostDisplay.underIconColor = color(0, 0, 0, 100)
bookBoostDisplay.progressBarColor = color(190, 226, 145, 255)
bookBoostDisplay.progressBarHeight = 8
bookBoostDisplay.font = "bh22"
bookBoostDisplay.canPracticeSkillTextColor = color(200, 255, 200, 255)

function bookBoostDisplay:practiceSkillOption()
	local taskObj = game.createPracticeTask(self.skillID, developer.PRACTICE_EXP_MIN, developer.PRACTICE_EXP_MAX, developer.PRACTICE_TIME_MIN, developer.PRACTICE_TIME_MAX, developer.PRACTICE_SESSIONS)
	
	taskObj:setSkillLevelExperienceIncreaseMultiplier(developer.PRACTICE_LEVEL_EXP_MULTIPLIER)
	self.assignee:setTask(taskObj)
end

function bookBoostDisplay:init()
	self:updateFont()
end

function bookBoostDisplay:updateFont()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
end

function bookBoostDisplay:setScalingState(hor, vert)
	bookBoostDisplay.baseClass.setScalingState(self, true, true)
end

function bookBoostDisplay:setSkillID(skillID)
	self.skillData = skills:getData(skillID)
	
	self:updateDisplay()
end

function bookBoostDisplay:getSkillID()
	return self.skillData.id
end

function bookBoostDisplay:updateDisplay()
	self.boostText = string.easyformatbykeys(_T("EXP_BOOST_FROM_BOOK_LAYOUT", "+BOOST% XP"), "BOOST", math.round((bookController:getSkillExperienceBoost(self.skillData.id) - 1) * 100, 1))
	
	self:updateSprites()
end

function bookBoostDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(string.easyformatbykeys(_T("BOOK_BOOST_TO_SKILL_LAYOUT", "+BOOST% total experience gain to SKILL"), "BOOST", math.round((bookController:getSkillExperienceBoost(self.skillData.id) - 1) * 100, 1), "SKILL", self.skillData.display), "pix20", game.UI_COLORS.GREEN, 0, 400)
	
	local bookshelf = bookController:getCurrentBookshelfObject()
	local contributedBoost = bookshelf:getContributedSkill(self.skillData.id)
	
	if contributedBoost > 0 then
		self.descBox:addSpaceToNextText(4)
		self.descBox:addText(string.easyformatbykeys(_T("BOOKSHELF_BOOST_TO_SKILL_LAYOUT", "+BOOST% experience gain to SKILL from this bookshelf"), "BOOST", math.round(contributedBoost * 100, 1), "SKILL", self.skillData.display), "pix18", game.UI_COLORS.IMPORTANT_1, 0, 400)
	end
	
	self.descBox:centerToElement(self)
end

function bookBoostDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function bookBoostDisplay:getIconSize()
	return self.rawH - (4 + bookBoostDisplay.progressBarHeight)
end

function bookBoostDisplay:getIcon()
	return self.skillData.icon
end

function bookBoostDisplay:getProgress()
	return (bookController:getSkillExperienceBoost(self.skillData.id) - 1) / bookController:getMaxSkillBoost(self.skillData.id)
end

function bookBoostDisplay:getBaseNonHoverColor()
	return bookBoostDisplay.baseColorInactive
end

function bookBoostDisplay:updateSprites()
	local underColor = self:isMouseOver() and bookBoostDisplay.baseColor or self:getBaseNonHoverColor()
	
	self:setNextSpriteColor(underColor:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local scaledProgressBarHeight = _S(bookBoostDisplay.progressBarHeight)
	local iconSize = self:getIconSize()
	local scaledTwo = _S(2)
	local scaledFour = _S(4)
	
	self:setNextSpriteColor(bookBoostDisplay.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	self.iconSprite = self:allocateSprite(self.iconSprite, self:getIcon(), scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	
	local realBarWidth = self.rawW - 4
	local realBarHeight = bookBoostDisplay.progressBarHeight - 2
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.underProgressbarSprite = self:allocateSprite(self.underProgressbarSprite, "generic_1px", scaledTwo, self.h - scaledTwo - _S(realBarHeight), 0, realBarWidth, realBarHeight, 0, 0, -0.1)
	
	self:setNextSpriteColor(bookBoostDisplay.progressBarColor:unpack())
	
	self.progressBarSprite = self:allocateSprite(self.progressBarSprite, "generic_1px", scaledFour, self.h - _S(realBarHeight), 0, (realBarWidth - 4) * self:getProgress(), realBarHeight - 4, 0, 0, -0.1)
end

function bookBoostDisplay:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.boostText, _S(self:getIconSize() + 4), _S(1), tcol.r, tcol.g, tcol.b, tcol.a)
end

gui.register("BookBoostDisplay", bookBoostDisplay)
