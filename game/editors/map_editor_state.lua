local mapEditorState = {}

function mapEditorState:update(dt)
	game.attemptMoveCamera(dt)
	camera:update(dt)
	mapEditor:update(dt)
	game.worldObject:update(dt)
end

return mapEditorState
