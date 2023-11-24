local confirmTreePlacementButton = {}

confirmTreePlacementButton.text = _T("PLACE_TREES", "Place trees")

function confirmTreePlacementButton:init()
	self:setFont("pix24")
end

function confirmTreePlacementButton:setRangeTextbox(box)
	self.textbox = box
end

function confirmTreePlacementButton:onClick()
	frameController:pop()
	mapEditor:placeTrees(math.random(), tonumber(self.textbox:getText()) or 100)
end

gui.register("ConfirmTreePlacementButton", confirmTreePlacementButton, "Button")
