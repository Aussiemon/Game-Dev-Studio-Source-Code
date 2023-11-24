local mapEditorRenderer = {}

function mapEditorRenderer:draw()
	love.graphics.setCanvas(game.mainFrameBufferObject)
	mapEditor:draw()
	camera:set()
	priorityRenderer:draw()
	camera:unset()
	mapEditor:postDraw()
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	game.mainFrameBuffer:draw()
	gui.performDrawing()
end

return mapEditorRenderer
