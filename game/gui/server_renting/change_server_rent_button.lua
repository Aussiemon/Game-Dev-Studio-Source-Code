local rentButton = {}

rentButton.increaseText = {
	{
		font = "bh20",
		lineSpace = 4,
		text = _T("RENT_A_SERVER", "Rent out a server")
	}
}
rentButton.decreaseText = {
	{
		font = "bh20",
		icon = "mouse_left",
		iconHeight = 22,
		lineSpace = 4,
		iconWidth = 22,
		text = _T("DECREASE_SERVER_RENT_ONE", "Reduce rented server count by 1")
	},
	{
		font = "bh20",
		icon = "mouse_right",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("DECREASE_SERVER_RENT_FIVE", "Reduce rented server count by 5")
	}
}

function rentButton:setDirection(dir)
	self.direction = dir
	
	if self.direction > 0 then
		self:setIcon("increase")
		self:setHoverText(self.increaseText)
		
		while self.increaseText[2] do
			table.remove(self.increaseText, 2)
		end
		
		table.insert(self.increaseText, {
			font = "bh18",
			icon = "wad_of_cash",
			iconHeight = 22,
			iconWidth = 22,
			text = _format(_T("ADD_TO_MONTHLY_COSTS", "+$COST to monthly costs"), "COST", string.roundtobignumber(serverRenting:getMonthlyRentFee()))
		})
		table.insert(self.increaseText, {
			font = "bh18",
			icon = "projects_finished",
			iconHeight = 22,
			iconWidth = 22,
			text = _format(_T("SERVER_RENT_CAPACITY_INCREASE", "+$CAP to server capacity"), "CAP", string.roundtobignumber(serverRenting:getCapacity()))
		})
	else
		self:setIcon("decrease")
		self:setHoverText(self.decreaseText)
	end
end

function rentButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y - self.descBox.h - _S(5))
end

function rentButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		serverRenting:changeRentedServers(self.direction)
	elseif key == gui.mouseKeys.RIGHT then
		serverRenting:changeRentedServers(self.direction * 5)
	end
end

gui.register("ChangeServerRentButton", rentButton, "IconButton")
