local mainMenuRenderer = {}

function mainMenuRenderer:draw()
	timer:process(dt)
	mainMenu:draw()
	gui.performDrawing()
end

return mainMenuRenderer
