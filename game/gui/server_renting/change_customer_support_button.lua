local csButton = {}

csButton.rightClickMult = 5
csButton.increaseText = {}
csButton.decreaseText = {
	{
		font = "bh20",
		icon = "mouse_left",
		iconHeight = 22,
		lineSpace = 4,
		iconWidth = 22,
		text = _format(_T("DECREASE_CUSTOMER_SUPPORT", "Decrease customer support by CHANGE"), "CHANGE", string.roundtobignumber(serverRenting:getCustomerSupportValue()))
	},
	{
		font = "bh20",
		icon = "mouse_right",
		iconHeight = 22,
		iconWidth = 22,
		text = _format(_T("DECREASE_CUSTOMER_SUPPORT", "Decrease customer support by CHANGE"), "CHANGE", string.roundtobignumber(serverRenting:getCustomerSupportValue() * csButton.rightClickMult))
	}
}

function csButton:setDirection(dir)
	self.direction = dir
	
	if self.direction > 0 then
		self:setIcon("increase")
		self:setHoverText(self.increaseText)
		table.clear(self.increaseText)
		table.insert(self.increaseText, {
			font = "bh20",
			icon = "mouse_left",
			iconWidth = 22,
			iconHeight = 22,
			lineSpace = 4,
			text = _format(_T("INCREASE_CUSTOMER_SUPPORT", "Increase customer support capacity by CHANGE"), "CHANGE", string.roundtobignumber(serverRenting:getCustomerSupportValue()))
		})
		table.insert(self.increaseText, {
			font = "bh20",
			icon = "mouse_right",
			iconWidth = 22,
			iconHeight = 22,
			lineSpace = 4,
			text = _format(_T("INCREASE_CUSTOMER_SUPPORT", "Increase customer support capacity by CHANGE"), "CHANGE", string.roundtobignumber(serverRenting:getCustomerSupportValue() * csButton.rightClickMult))
		})
		table.insert(self.increaseText, {
			font = "bh18",
			icon = "wad_of_cash",
			iconHeight = 22,
			iconWidth = 22,
			text = _format(_T("ADD_TO_MONTHLY_COSTS", "+$COST to monthly costs"), "COST", string.roundtobignumber(serverRenting:getMonthlyCustomerSupportFee()))
		})
	else
		self:setIcon("decrease")
		self:setHoverText(self.decreaseText)
	end
end

function csButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y - self.descBox.h - _S(5))
end

function csButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		serverRenting:changeCustomerSupport(self.direction)
	elseif key == gui.mouseKeys.RIGHT then
		serverRenting:changeCustomerSupport(self.direction * self.rightClickMult)
	end
end

gui.register("ChangeCustomerSupportButton", csButton, "IconButton")
