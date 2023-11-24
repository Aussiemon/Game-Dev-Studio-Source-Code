objectGrid._addObject = objectGrid.addObject

function objectGrid:addObject(x, y, object)
	object:setObjectGrid(self)
	objectGrid._addObject(self, x, y, object)
end
