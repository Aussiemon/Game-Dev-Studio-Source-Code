local entry = {}

function entry:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setPos(0, _S(3))
	self.descriptionBox:overwriteDepth(50)
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:setShowRectSprites(false)
end

function entry:setData(data)
	self.entryData = data
	
	local wrapWidth = self.rawW
	local descBox = self.descriptionBox
	
	descBox:addText(_format(_T("GAME_AWARDS_PARTICIPATION_DATE", "Participated in YEAR"), "YEAR", data.year), "pix22", nil, 5, wrapWidth)
	descBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	descBox:addText(_format(_T("GAME_AWARDS_NOMINATED_GAME", "Nominated 'GAME'"), "GAME", data.game), "bh20", game.UI_COLORS.LIGHT_BLUE, 4, wrapWidth, "icon_games_tab", 24, 20)
	
	if #data.data == 0 then
		descBox:addTextLine(-1, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		descBox:addText(_T("GAME_AWARDS_NO_AWARDS", "No awards won."), "bh20", game.UI_COLORS.IMPORTANT_1, 0, wrapWidth, "question_mark", 24, 24)
	else
		descBox:addSpaceToNextText(5)
		
		for key, subData in ipairs(data.data) do
			gameAwards:formatWinText(subData, descBox, wrapWidth)
		end
	end
	
	local pen = data.penalties
	
	if pen > 0 then
		local penText = gameAwards.PENALTY_TEXT
		
		for key, id in ipairs(gameAwards.PENALTY_ORDER) do
			if bit.band(pen, id) == id then
				descBox:addTextLine(-1, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
				descBox:addText(penText[id], "bh20", game.UI_COLORS.IMPORTANT_1, 0, wrapWidth, "exclamation_point_red", 24, 24)
			end
		end
	end
	
	local repChange = data.repChange
	local text
	
	descBox:addSpaceToNextText(3)
	
	if repChange < 0 then
		descBox:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		descBox:addText(_format(_T("GAME_AWARDS_REP_CHANGE_NEGATIVE", "Lost REP Reputation pts."), "REP", string.comma(data.repChange)), "bh20", game.UI_COLORS.RED, 3, wrapWidth, "decrease_red", 24, 24)
	elseif repChange > 0 then
		descBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		descBox:addText(_format(_T("GAME_AWARDS_REP_CHANGE_POSITIVE", "Got REP Reputation pts."), "REP", string.comma(data.repChange)), "bh20", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth, "increase", 24, 24)
	else
		descBox:addTextLine(-1, game.UI_COLORS.IMPORTANT_2, nil, "weak_gradient_horizontal")
		descBox:addText(_T("GAME_AWARDS_REP_CHANGE_NONE", "No change in Reputation"), "bh20", game.UI_COLORS.IMPORTANT_2, 3, wrapWidth, "exclamation_point", 24, 24)
	end
	
	self:setHeight(_US(self.descriptionBox.rawH) + 3)
end

gui.register("GameAwardEntry", entry, "GenericElement")
