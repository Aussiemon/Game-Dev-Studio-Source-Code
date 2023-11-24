local wall = {}

function wall:setPurchaseData(id)
	local data = walls.registeredByID[id]
	
	self.wallData = data
	self.id = id
	self.name = data.display
	self.cost = table.concatEasy("", "$", data.cost)
	self.quadName = data.menuDisplayQuad
end

function wall:isOn()
	return studio.expansion:getPurchaseID(studio.expansion.CONSTRUCTION_MODE.WALLS) == self.id
end

function wall:handleEvent(event, purchaseID)
	local expansion = studio.expansion
	
	if event == expansion.EVENTS.PURCHASE_ID_CHANGED and expansion:getConstructionMode() == expansion.CONSTRUCTION_MODE.WALLS then
		self:queueSpriteUpdate()
	end
end

gui.register("WallPurchaseOption", wall, "FloorTilePurchaseOption")
