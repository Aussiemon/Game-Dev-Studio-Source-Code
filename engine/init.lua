function log(...)
	if DEBUG_MODE then
		print(...)
	end
end

function love.filesystem.loadLuaJITBytecode(filePath)
	loadstring(love.filesystem.read("src/" .. filePath .. ".ljb"))()
end

function love.window.setScreenSizeVariables()
	scrH = love.graphics.getHeight()
	scrW = love.graphics.getWidth()
	halfScrH = scrH * 0.5
	halfScrW = scrW * 0.5
end

love.window.setScreenSizeVariables()

function vunpack(t, i)
	i = i or 1
	
	if t[i] ~= nil then
		return t[i], unpack(t, i + 1)
	end
end

function getFrameTime()
	return frameTime
end

audio = {}
game = {}
curTime = 0

local dir = love.filesystem.getSourceBaseDirectory()
local success = love.filesystem.mount(dir, BASE_GAME_FOLDER)

class = require("engine/middleclass/middleclass")

require("engine/quadtree")
require("engine/translation")
require("engine/sprite_data")
require("engine/color")
require("engine/vector")
require("engine/timers")
require("engine/scaling")
require("engine/stream")
require("engine/config_loader")
require("engine/tilegrid")
require("engine/objectgrid")
require("engine/tilegrid_visibility_handler")
require("engine/json")
require("engine/bitser")
require("engine/extralove")
require("engine/extramath")
require("engine/extratable")
require("engine/extrastring")
require("engine/extrafilesystem")
require("engine/byteops")
require("engine/ffiimagedata")
require("engine/ffisounddata")
require("engine/registry")
require("engine/events")
require("engine/spritebatchcontroller")
require("engine/npcstates")
require("engine/util")
require("engine/cullingtester")
require("engine/screenshot_encoder_initializer")
require("engine/filecache")
require("engine/quad_loader")
require("engine/text_mixins")
require("engine/particle_system_registration")
require("engine/shaders")
require("engine/soundchannel")
require("engine/hooks")
require("engine/coroutinemanager")
require("engine/atlas")
require("engine/garbagecompare")
require("engine/noise_templates")
require("engine/inventory_slot")
require("engine/collision")
require("engine/camera")
require("engine/anim")
require("engine/splash")
require("engine/fonts")
require("engine/gui")
require("engine/parallax")
require("engine/dynmusic")
require("engine/pathfinding")
require("engine/middleofimage")
require("engine/npc_state_machines")
require("engine/profiler")
require("engine/spritesheet_parser")
require("engine/framebuffer")
require("engine/priority_renderer")
require("engine/post_init")
require("engine/key_binding")
require("engine/input_service")
require("engine/layer_renderer")
require("engine/game_state_service")
require("engine/particle_effects")
