local sale = {}

sale.skinPanelFillColor = color(86, 104, 135, 255)
sale.skinPanelHoverColor = color(163, 176, 198, 255)
sale.barColor = color(168, 201, 255, 255)
sale.maxBarsToDisplay = 12
sale.spaceBetweenBars = 6
sale.baseBarOffset = 5
sale.barTopOffset = 3
sale.minimumBarHeight = 3

function sale:setProject(proj)
	self.project = proj
	
	self:setDisplayData(self.project:getSalesByWeek())
	self:updateBars()
end

gui.register("SaleDisplay", sale, "BarDisplay")
