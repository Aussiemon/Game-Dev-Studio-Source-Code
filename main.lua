jit.opt.start("maxmcode=2048", "maxtrace=2000")

RELEASE = true
MAIN_THREAD = true
BASE_GAME_FOLDER = "game_dev_studio/"

local exponent = 5
local range = 8000
local log = math.log(8000, 6)

require("load_engine")
require("load_game")

if table.find(arg, "--translationcompare") then
	require("localization/ignore_compile/translationcompare")
end

if table.find(arg, "--debug") then
	DEBUG_MODE = true
end

if love.filesystem.exists("dump_to_bytecode.lua") and table.find(arg, "--dump") then
	require("dump_to_bytecode")
end

if love.filesystem.exists("ignore_compile/match_translationkeys.lua") and table.find(arg, "--translationkeys") then
	require("ignore_compile/match_translationkeys")
end

math.randomseed(os.time())

function love.threaderror(thread, errorstr)
	love.errhand(errorstr)
end

function love.update(dt)
	if steam then
		steam.RunCallbacks()
	end
	
	frameTime = dt
	curTime = curTime + dt
	
	gameStateService:updateStates(dt)
	sound:think()
	musicPlayback:update(dt)
	gcm:collectGarbage()
	coroutineManager:process()
end

function love.draw()
	layerRenderer:draw()
end

game.onStarted()
