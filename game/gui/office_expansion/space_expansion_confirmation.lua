local spaceExpandConfirm = {}

function spaceExpandConfirm:init()
	self.purchase = 0
end

function spaceExpandConfirm:setRow(row)
	self.rowData = row
	self.baseText = _T("EXPAND_OFFICE", "Expand office")
	self.costText = _format(_T("ROW_EXPANSION_COST", "$COST"), "COST", string.comma(studio.expansion:getRowCost(studio.expansion:getRowTiles(self.rowData))))
	
	self:setupDisplay()
end

function spaceExpandConfirm:setText(text)
	self.baseText = text
	
	self:setupDisplay()
end

function spaceExpandConfirm:getIcon()
	return "wad_of_cash"
end

function spaceExpandConfirm:increasePurchaseState()
	self.purchase = self.purchase + 1
	
	if self.purchase >= 2 then
		if studio.expansion:attemptPurchaseRow(self.rowData) then
			sound:play("expand_building", nil, nil, nil)
		end
	elseif self.purchase == 1 then
		self:setText(_T("EXPAND_OFFICE_CONFIRM", "Click to confirm"))
	end
end

function spaceExpandConfirm:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:increasePurchaseState()
	end
end

function spaceExpandConfirm:think()
	self:updateCameraPosition()
end

function spaceExpandConfirm:setupDisplay()
	self.costTextX = self.iconSize + self.iconOffset * 2
	self.costTextY = self.baseFont:getHeight() + self.baseOffset
	
	local baseTextWidth = self.baseFont:getWidth(self.baseText)
	
	self:setWidth(math.max(baseTextWidth, self.costTextX + self.costFont:getWidth(self.costText)) + 5)
	
	self.baseTextX = (self.w - baseTextWidth) * 0.5
	self.midX, self.midY = studio.expansion:getRowMid(self.rowData)
	self.midX = self.midX - game.WORLD_TILE_WIDTH * 0.5
	self.midY = self.midY - game.WORLD_TILE_HEIGHT * 0.5
	self.prevCamX, self.prevCamY = nil
end

gui.register("SpaceExpandConfirmation", spaceExpandConfirm, "OfficeCostDisplay")
