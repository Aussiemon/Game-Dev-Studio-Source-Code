local objectInteraction = {}

function objectInteraction:bringUp()
	self:setDepth(1000)
end

function objectInteraction:setObjectList(list)
	local objCount = #list
	
	self.objects = list
	self.centeringObject = self.objects[1]
	self.objectGrid = self.centeringObject:getObjectGrid()
	self.centeringW = self.centeringObject:getTileSize()
	self.centeringW = self.centeringW * select(1, self.objectGrid:getTileSize())
	
	local oldObject = self.curObject
	local newObject = objectSelector:getCurrentInteractableObject()
	
	if oldObject ~= newObject then
		self.curObject = newObject
		
		self:updateDescbox()
	elseif self.objectCount ~= objCount then
		self:updateDescbox()
	end
	
	self.objectCount = objCount
	
	self:centerOnObject()
end

function objectInteraction:think(dt)
	self:doTimedAppear()
	self:centerOnObject()
end

function objectInteraction:centerOnObject()
	local gridX, gridY = self.centeringObject:getBottomTileCoordinates()
	local x, y = self.objectGrid:tileToScreen(gridX, gridY - 1)
	
	self:setPos(x, y)
end

function objectInteraction:handleEvent(event)
	if event == objectSelector.EVENTS.OBJECT_SELECTION_CYCLED then
		local oldObject = self.curObject
		local newObject = objectSelector:getCurrentInteractableObject()
		
		if oldObject ~= newObject then
			self.curObject = newObject
			
			self:updateDescbox()
		end
	end
end

function objectInteraction:setupDescbox()
	self:updateDescbox()
end

function objectInteraction:updateDescbox()
	self:removeAllText()
	
	local interactableObject = objectSelector:getCurrentInteractableObject()
	
	for key, object in ipairs(self.objects) do
		local textColor, bulletPointColor
		
		if object == interactableObject then
			textColor = game.UI_COLORS.LIGHT_BLUE
			bulletPointColor = game.UI_COLORS.DARK_LIGHT_BLUE
		else
			textColor = game.UI_COLORS.GREY
			bulletPointColor = game.UI_COLORS.VERY_DARK_LIGHT_BLUE
		end
		
		self:addText(object:getName(), "pix20", textColor, 0, 350, {
			{
				icon = "bullet_point",
				width = 16,
				height = 16,
				color = bulletPointColor
			}
		})
	end
	
	if #self.objects > 1 then
		self:addSpaceToNextText(6)
		self:addText(_T("CYCLE_OBJECT", "Cycle object"), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 350, "mouse_wheel", 24, 24)
	end
end

gui.register("ObjectInteractionDescbox", objectInteraction, "GenericDescbox")
