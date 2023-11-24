local jobs = {}

function jobs:init()
	self:setFont(fonts.get("pix20"))
	self:setText("Expenses")
end

function jobs:onClick()
	monthlyCost.createOfficeMenu()
end

gui.register("OfficeExpensesButton", jobs, "Button")
