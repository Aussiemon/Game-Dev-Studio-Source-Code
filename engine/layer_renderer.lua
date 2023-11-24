layerRenderer = {}
layerRenderer.layers = {}

function layerRenderer:addLayer(layer)
	table.insert(self.layers, layer)
end

function layerRenderer:removeLayer(layer)
	table.removeObject(self.layers, layer)
end

function layerRenderer:draw()
	for key, layer in ipairs(self.layers) do
		layer:draw()
	end
end
