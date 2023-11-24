local letsPlayCostDisplay = {}
local advertData = advertisement:getData("lets_plays")

letsPlayCostDisplay.CATCHABLE_EVENTS = {
	advertData.EVENTS.ADDED_DESIRED_LETS_PLAYER,
	advertData.EVENTS.REMOVED_DESIRED_LETS_PLAYER
}

function letsPlayCostDisplay:setConfirmButton(confirmButton)
	self.confirmButton = confirmButton
end

function letsPlayCostDisplay:handleEvent(event, removedLPID, listOfLPers)
	self:setCost(advertData:getDesiredLetsPlayerCost())
	self.confirmButton:updateCost(self.cost, listOfLPers)
end

gui.register("LetsPlayCostDisplay", letsPlayCostDisplay, "CostDisplay")
