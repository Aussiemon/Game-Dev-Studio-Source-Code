local platRatings = {}

platRatings.barDisplayClass = "PlatformGameRatingsBarDisplay"

function platRatings:setData(obj)
	self.platform = obj
	
	local wrapW = self.rawW
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_T("PLATFORM_GAME_INFO", "Game info"), "bh18", nil, 0, wrapW)
	self.rightInfo:setY(self.leftInfo.h)
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("PLATFORM_ON_MARKET_GAMES", "On-market games"), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(#self.platform:getActiveGames(), "bh16", nil, 0, wrapW)
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("PLATFORM_TOTAL_GAMES_RELEASED", "Total games released"), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(self.platform:getTotalGamesReleased(), "bh16", nil, 0, wrapW)
	
	local totalMoney, moneyThisMonth = self.platform:getGameMoney()
	
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("PLATFORM_TOTAL_GAME_REVENUE", "Total game revenue"), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(string.roundtobigcashnumber(totalMoney), "bh16", nil, 0, wrapW)
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("PLATFORM_GAMES_BY_RATINGS", "Games by ratings"), "bh16", nil, 0, wrapW)
	self.barDisplay:setRatingData(self.platform:getGamesByRating())
	self.barDisplay:setSize(wrapW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.localY + self.leftInfo.h + _S(3))
	self.barDisplay:updateBars()
	self:updateRightDescboxPosition()
	self:setHeight(_US(self.barDisplay.localY + self.barDisplay.h) + 5)
end

gui.register("PlatformGameRatingsFrame", platRatings, "BarDisplayFrame")
