local mmoSubsBar = {}

mmoSubsBar.costBarColor = game.UI_COLORS.RED

function mmoSubsBar:init()
	self.costSpriteIDs = {}
end

function mmoSubsBar:setLogicPiece(piece)
	self.logicPiece = piece
	self.serverCostData = piece:getServerCostData()
end

function mmoSubsBar:updateVisualBars()
	self:_updateVisualBars(self.displayData, self.backdropSpriteIDs, self.spriteIDs, 0, 0, self.barColor)
	self:_updateVisualBars(self.serverCostData, nil, self.costSpriteIDs, 0.05, -_S(2), self.costBarColor, true)
end

function mmoSubsBar:getHighestValue()
	local highestValue = 0
	local data = self.displayData
	local costData = self.serverCostData
	
	for i = self.displayRange, #self.displayData do
		highestValue = math.max(highestValue, data[i], costData[i])
	end
	
	self.highestValue = highestValue
end

gui.register("MMOSubsBarDisplay", mmoSubsBar, "BarDisplay")
