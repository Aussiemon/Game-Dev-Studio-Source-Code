pf:setToIndexConversionFunc(function(x, y)
	return game.worldObject.floorTileGrid:getTileIndex(x, y)
end)
pf:setIndexToCoordinatesFunc(function(index)
	return game.worldObject.floorTileGrid:convertIndexToCoordinates(index)
end)

function pf:drawPath()
	if #self.RECONSTRUCTEDPATH > 0 then
		if not self.r then
			self.r = math.random(0, 255)
			self.g = math.random(0, 255)
			self.b = math.random(0, 255)
		end
		
		love.graphics.setColor(self.r, self.g, self.b, 200)
		
		for k, v in ipairs(self.RECONSTRUCTEDPATH) do
			local x, y = self.indexToCoordinatesFunc(v)
			
			love.graphics.rectangle("fill", x * 48, y * 48, 48, 48)
		end
	end
end
