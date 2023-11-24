local bookExperienceBoostDisplay = {}

bookExperienceBoostDisplay.GRADIENT_COLOR = gui.genericOutlineColor

function bookExperienceBoostDisplay:setOffice(office)
	self.office = office
end

function bookExperienceBoostDisplay:setSkillID(skillID)
	self.skillID = skillID
	self.skillData = skills:getData(self.skillID)
	
	self:setFont("pix22")
	self:setIcon(self.skillData.icon, 2, 2)
	self:addText(self.skillData.display, nil, nil, nil)
	
	if bookController:getSkillExperienceBoost(skillID, self.office) > 1 then
		self:addText(bookController:formulateSkillBoostText(skillID, true, self.office), game.UI_COLORS.GREEN_2, nil, nil, "pix20")
	else
		self:addText(_T("NO_BOOK_EXPERIENCE_BOOST", "No boost"), game.UI_COLORS.IMPORTANT_1, _S(10), nil, "pix20")
	end
end

function bookExperienceBoostDisplay:addTextToDescbox()
	local boost = bookController:getSkillExperienceBoost(self.skillID, self.office)
	
	if boost > 1 then
		self.descBox:addText(string.easyformatbykeys(_T("EMPLOYEES_RECEIVE_BOOK_BONUS", "Employees will receive additional BONUS% SKILL skill experience."), "BONUS", math.round(boost * 100 - 100), "SKILL", self.skillData.display), "pix20", game.UI_COLORS.GREEN_2, 0, 400)
	else
		self.descBox:addText(string.easyformatbykeys(_T("NO_BOOK_BOOST_RECEIVED", "Employees won't receive any additional SKILL skill experience."), "SKILL", self.skillData.display), "pix20", game.UI_COLORS.IMPORTANT_1, 8, 400)
		self.descBox:addSpaceToNextText(4)
		self.descBox:addText(string.easyformatbykeys(_T("BOOK_BOOST_HINT", "Place bookshelves and fill them with books to provide a bonus to gained SKILL experience."), "SKILL", self.skillData.display), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, 400, "question_mark", 24, 24)
	end
end

gui.register("BookExperienceBoostDisplay", bookExperienceBoostDisplay, "DescboxGradientIconTextDisplay")
