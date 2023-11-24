local regInfo = {}

function regInfo:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:addDepth(100)
	self.descriptionBox:setPos(_S(3), _S(3))
end

function regInfo:setupDisplay()
	local desc = self.descriptionBox
	local wrapW = self.rawW - 25
	
	desc:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	desc:addText(_format(_T("GAME_AWARDS_BEGIN_TIME", "Game Awards begin in TIME"), "TIME", gameAwards:getTimeUntilBegin()), "bh22", game.UI_COLORS.LIGHT_BLUE, 5, wrapW, "exclamation_point", 24, 24)
	
	local plyGame = gameAwards:getPlayerGame()
	
	if plyGame then
		desc:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		desc:addText(_format(_T("GAME_AWARDS_REGISTERED", "You've nominated 'GAME'"), "GAME", plyGame:getName()), "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapW, "exclamation_point", 24, 24)
	elseif gameAwards:canRegisterFor() then
		desc:addTextLine(-1, game.UI_COLORS.LIGHT_GREEN, nil, "weak_gradient_horizontal")
		desc:addText(_format(_T("GAME_AWARDS_REGISTRATION_END_TIME", "Registration ends in TIME"), "TIME", gameAwards:getTimeUntilRegistrationEnd()), "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapW, "exclamation_point", 24, 24)
	else
		desc:addTextLine(-1, game.UI_COLORS.YELLOW, nil, "weak_gradient_horizontal")
		desc:addText(_format(_T("GAME_AWARDS_REGISTRATION_START_TIME", "Registration begins in TIME"), "TIME", gameAwards:getTimeUntilRegistration()), "bh20", game.UI_COLORS.YELLOW, 0, wrapW, "exclamation_point_yellow", 24, 24)
	end
	
	self:setHeight(_US(desc.h + self.regButton:getHeight()) + 3)
	self:adjustButtonPosition()
end

function regInfo:onSizeChanged()
	if self.regButton then
		self:adjustButtonPosition()
	end
end

function regInfo:createButtons()
	self.regButton = gui.create("RegisterGameAwardsButton", self)
	
	self.regButton:setFont("bh20")
	self.regButton:setText(_T("GAME_AWARDS_REGISTER_FOR", "Register for..."))
	self.regButton:setSize(190, 24)
	
	self.compButton = gui.create("GameAwardsCompetitorsButton", self)
	
	self.compButton:setFont("bh20")
	self.compButton:setText(_T("GAME_AWARDS_VIEW_NOMINEES", "View nominees..."))
	self.compButton:setSize(190, 24)
	self:disableButtonClicks()
end

function regInfo:disableButtonClicks()
	if gameAwards:getPlayerGame() or not gameAwards:canRegisterFor() then
		self.regButton:setCanClick(false)
	end
	
	if not gameAwards:canViewNominees() then
		self.compButton:setCanClick(false)
	end
end

function regInfo:getRegisterButton()
	return self.regButton
end

function regInfo:adjustButtonPosition()
	self.regButton:setPos(_S(3), self.h - self.regButton.h - _S(5))
	self.compButton:setPos(self.regButton.localX + self.regButton.w + _S(3), self.regButton.localY)
end

gui.register("GameAwardRegistrationInfo", regInfo, "GenericElement")
