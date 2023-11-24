local competitor = {}

function competitor:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:addDepth(100)
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:setShowRectSprites(false)
	
	self.rightDescbox = gui.create("GenericDescbox", self)
	
	self.rightDescbox:setAlignToRight(true)
	self.rightDescbox:addDepth(100)
	self.rightDescbox:setFadeInSpeed(0)
	self.rightDescbox:setShowRectSprites(false)
end

function competitor:setGameData(data)
	self.gameData = data
	
	local name, genre, rating
	
	if data.fakeGameAwardGame then
		name = data.name
		genre = data.genre
		rating = data.rating
	else
		name = data:getName()
		genre = data:getGenre()
		rating = data:getReviewRating()
	end
	
	local wrapW = self.rawW - 25
	
	self.descriptionBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(name, "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, genres:getGenreUIIconConfig(genres:getData(genre), 24, 24, 22))
	self.rightDescbox:addTextLine(-1, game.UI_COLORS.LIGHT_GREEN, nil, "weak_gradient_horizontal")
	self.rightDescbox:addText(_format(_T("ANNUAL_GAME_AWARD_", "Rating: RATING/MAX"), "RATING", math.round(rating, 1), "MAX", review.maxRating), "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapW, "star", 24, 24)
	self:setHeight(_US(self.descriptionBox.rawH))
end

function competitor:onSizeChanged()
	self.rightDescbox:setPos(self.w - self.rightDescbox.w - _S(3), self.rightDescbox.localY)
end

function competitor:updateSprites()
	competitor.baseClass.updateSprites(self)
end

gui.register("GameAwardsCompetitor", competitor, "GenericElement")
