require("engine/resolution_handler")

GAME_VERSION = "1.1.2.3"

function love.conf(t)
	t.window.title = string.gsub("Game Dev Studio VER", "VER", GAME_VERSION)
	t.window.width = 1280
	t.window.height = 720
	t.window.fullscreen = false
	t.window.vsync = false
	t.window.borderless = false
	t.console = false
	
	if arg.console then
		t.console = true
	else
		t.console = false
	end
end
