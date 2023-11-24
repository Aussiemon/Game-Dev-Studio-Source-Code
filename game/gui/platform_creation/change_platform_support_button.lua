local changeSupportButton = {}

changeSupportButton.increaseText = {
	{
		font = "bh20",
		lineSpace = 4,
		text = _T("INCREASE_PLATFORM_CUSTOMER_SUPPORT", "Increase customer support to allow for more repairs")
	}
}
changeSupportButton.decreaseText = {
	{
		font = "bh20",
		icon = "mouse_left",
		iconHeight = 22,
		lineSpace = 4,
		iconWidth = 22,
		text = _T("DECREASE_PLATFORM_CUSTOMER_SUPPORT_ONE", "Reduce platform customer support by 1")
	},
	{
		font = "bh20",
		icon = "mouse_right",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("DECREASE_PLATFORM_CUSTOMER_SUPPORT_FIVE", "Reduce platform customer support by 5")
	}
}

function changeSupportButton:setPlatform(plat)
	self.platform = plat
end

function changeSupportButton:setDirection(dir)
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
			text = _format(_T("ADD_TO_MONTHLY_COSTS", "+$COST to monthly costs"), "COST", string.roundtobignumber(self.platform:getMonthlySupportFee()))
		})
		table.insert(self.increaseText, {
			font = "bh18",
			icon = "projects_finished",
			iconHeight = 22,
			iconWidth = 22,
			text = _format(_T("PLATFORM_CUSTOMER_SUPPORT_INCREASE", "+CAP to customer support"), "CAP", string.comma(self.platform:getSupportIncrease()))
		})
	else
		while self.decreaseText[3] do
			table.remove(self.decreaseText, 3)
		end
		
		if not self.platform:isReleased() then
			table.insert(self.decreaseText, {
				font = "bh18",
				iconWidth = 22,
				iconHeight = 22,
				icon = "question_mark",
				preLineSpace = 4,
				text = _T("PLATFORM_CANNOT_REDUCE_TO_ZERO", "Can not reduce to 0 until the console is released."),
				color = game.UI_COLORS.LIGHT_BLUE
			})
		end
		
		self:setIcon("decrease")
		self:setHoverText(self.decreaseText)
	end
end

function changeSupportButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y - self.descBox.h - _S(5))
end

function changeSupportButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.platform:changeSupport(self.direction)
	elseif key == gui.mouseKeys.RIGHT then
		self.platform:changeSupport(self.direction * 5)
	end
end

gui.register("ChangePlatformSupportButton", changeSupportButton, "IconButton")
