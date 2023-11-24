lightingManager = {}
lightingManager.overDrawRangeX = 10
lightingManager.overDrawRangeY = 10
lightingManager.createdImageData = {}
lightingManager.lightingUpdateFrequency = 60
lightingManager.sentIn = false
lightingManager.resolutionScale = 3
lightingManager.maxResolutionScale = 10
lightingManager.CHANNEL_IN = "LIGHTING_COMPUTE_IN"
lightingManager.CHANNEL_OUT = "LIGHTING_COMPUTE_OUT"
lightingManager.LOAD_CHANNEL_IN = "LIGHTING_LOAD_IN"
lightingManager.MULTI_CHANNEL_INDEXES = {
	"r",
	"g",
	"b"
}
lightingManager.SEND_DATA = {}
lightingManager.OFFICE_BRIGHTNESS_LEVEL = 30
lightingManager.OFFICE_BRIGHTNESS_LEVEL_EXPANSION_MODE = 110
lightingManager.START_LIGHT_FADE_SPEED = 0.5
lightingManager.FINISH_LIGHT_FADE_SPEED = 0.8
lightingManager.FILTER_MODE = "linear"
lightingManager.DEFAULT_OVERDRAW_RANGE_X = 7
lightingManager.DEFAULT_OVERDRAW_RANGE_Y = 7
lightingManager.channelIn = love.thread.getChannel(lightingManager.CHANNEL_IN)
lightingManager.channelOut = love.thread.getChannel(lightingManager.CHANNEL_OUT)
lightingManager.loadChannelIn = love.thread.getChannel(lightingManager.LOAD_CHANNEL_IN)
lightingManager.DRAW_PRIORITY = 51.5
lightingManager.LIGHTING = true
lightingManager.WORK_CHANNEL = "lighting_work_queue"
lightingManager.workChannels = {}

for i = 1, 4 do
	lightingManager.workChannels[i] = love.thread.getChannel(lightingManager.WORK_CHANNEL .. i)
end

lightingManager.PREPARE_CHANNEL = "lighting_prep_queue"
lightingManager.prepChannel = love.thread.getChannel(lightingManager.PREPARE_CHANNEL)
lightingManager.FLOOD_DIRECTION = {
	up = 2,
	down = 1,
	left = 3,
	right = 4
}

if MAIN_THREAD then
	local studioExpansion = studio.expansion
	
	lightingManager.CATCHABLE_EVENTS = {
		studioExpansion.EVENTS.POST_PLACED_OBJECT,
		studioExpansion.EVENTS.POST_REMOVED_OBJECT,
		studioExpansion.EVENTS.SOLD_MOVED_OBJECT,
		studioExpansion.EVENTS.FINISHED_MOVING_OBJECT,
		objects.getClassData("light_source_base").EVENTS.TOGGLED
	}
	lightingManager.DESCRIPTION = {
		{
			font = "pix20",
			wrapWidth = 400,
			text = _T("LIGHTMAP_QUALITY_DESCRIPTION_1", "Adjust the lighting quality.")
		},
		{
			font = "pix18",
			wrapWidth = 400,
			text = _T("LIGHTMAP_QUALITY_DESCRIPTION_2", "Lighting is computed on all available CPU threads.")
		},
		{
			font = "bh18",
			wrapWidth = 400,
			text = _T("LIGHTMAP_QUALITY_DESCRIPTION_3", "Increasing the screen resolution and the lightmap size will increase compute time."),
			textColor = game.UI_COLORS.IMPORTANT_1
		}
	}
	lightingManager.DEFAULT_QUALITY_PRESET = 2
	lightingManager.QUALITY_PRESETS = {
		{
			resolutionScale = 2,
			name = _T("LIGHTMAP_QUALITY_SMALL", "Small"),
			description = {
				{
					font = "pix20",
					text = _T("LIGHTMAP_QUALITY_SMALL_DESCRIPTION", "4 pixels per tile")
				}
			}
		},
		{
			resolutionScale = 3,
			name = _T("LIGHTMAP_QUALITY_NORMAL", "Normal"),
			description = {
				{
					font = "pix20",
					text = _T("LIGHTMAP_QUALITY_NORMAL_DESCRIPTION", "9 pixels per tile")
				}
			}
		},
		{
			resolutionScale = 4,
			name = _T("LIGHTMAP_QUALITY_LARGE", "Large"),
			description = {
				{
					font = "pix20",
					text = _T("LIGHTMAP_QUALITY_LARGE_DESCRIPTION", "16 pixels per tile")
				}
			}
		},
		{
			resolutionScale = 5,
			name = _T("LIGHTMAP_QUALITY_VERY_LARGE", "Very large"),
			description = {
				{
					font = "pix20",
					text = _T("LIGHTMAP_QUALITY_VERY_LARGE_DESCRIPTION", "25 pixels per tile")
				}
			}
		},
		{
			resolutionScale = 7,
			name = _T("LIGHTMAP_QUALITY_HUGE", "Huge"),
			description = {
				{
					font = "pix20",
					text = _T("LIGHTMAP_QUALITY_HUGE_DESCRIPTION", "49 pixels per tile\nNot recommended for anyone.")
				}
			}
		}
	}
	lightingManager.qualityPreset = lightingManager.DEFAULT_QUALITY_PRESET
end

lightingManager.MESSAGE_TYPE = {
	OFFICE_TILES = 112,
	COMPUTE_REQUEST = 104,
	OFFICE_TILE_UPDATE = 113,
	WORKER_LIST = 107,
	OVERDRAW_RANGE_CHANGED = 102,
	NEW_IMAGE_DATA = 101,
	STOP = 111,
	WORK_RANGE = 108,
	LIGHT_COLOR_CHANGED = 119,
	FADE_SPEED = 110,
	WORLD_SIZE = 120,
	LIGHT_DISABLED = 117,
	PREPARATION = 123,
	PREPARE_DONE = 124,
	test = 125,
	COMPUTE_FINISHED = 105,
	LIGHT_CREATED = 114,
	TASK_DONE = 109,
	STAGE_FINISHED = 106,
	RESET = 122,
	SCALE_CHANGED = 103,
	LIGHT_UPDATED = 115,
	LIGHT_ENABLED = 116,
	RESOLUTION_SCALE = 121,
	LIGHT_REMOVED = 118
}
lightingManager.ALPHA_TO_INFO = {
	OBSTRUCTION = 1,
	LIGHT = 2,
	NONE = 0
}
lightingManager.MULTI_THREAD_INIT_STRING = "\tjit.opt.start('maxmcode=2048', 'maxtrace=2000')\n\n\t-- load necessary modules\n\trequire(\"love.image\")\n\trequire(\"love.math\")\n\trequire(\"love.graphics\")\n\trequire(\"engine/extratable\")\n\n\trequire(\"engine/pathfinding\")\n\trequire(\"engine/quad_loader\")\n\trequire(\"engine/translation\")\n\trequire(\"engine/tilegrid\")\n\trequire(\"engine/objectgrid\")\n\t--require(\"engine/bitser\")\n\trequire(\"game/tilegrid/tilegrid\")\n\trequire(\"engine/ffiimagedata\")\n\n\trequire(\"game/world/floors\")\n\trequire(\"game/world/walls\")\n\n\trequire(\"game/pathfinder_thread\")\n\t--require(\"game/error_reporter\")\n\trequire(\"engine/extramath\")\n\n\t-- load lighting manager\n\trequire(\"game/lighting_manager\")\n\t\n\tCOMPUTE_THREAD = true\n\t\n\tlightingManager:init()\n\tlightingManager:setupComputeHandlers()\n\tlightingManager.channelInName = \"CHANNEL_IN_NAME\"\n\tlightingManager.channelIn = love.thread.getChannel(\"CHANNEL_IN_NAME\")\n\n\t--print(\"LIGHTING COMPUTE THREAD INITIALIZED\")\n\n\tlocal GC = 0\n\n\twhile not lightingManager.STOPPED do\n\t\tlightingManager:updateCompute() -- call the compute thread specific update method\n\t\t\n\t\tGC = GC + 1\n\t\t\n\t\tif GC >= 50 then\n\t\t\tcollectgarbage(\"step\", 10)\n\t\t\tGC = 0\n\t\tend\n\tend\n\t\n\t--lightingManager.imageData = nil\n\t--lightingManager.lightData = nil\n\t--lightingManager.channelIn = nil\n\t--lightingManager.channelOut = nil\n\t\n\t--for i = 1, 2 do \n\t--\tcollectgarbage()\n\t--end\n"
lightingManager.LOAD_DISTRIBUTOR_THREAD_INIT = "\tjit.opt.start('maxmcode=2048', 'maxtrace=2000')\n\n\t-- load necessary modules\n\trequire(\"love.image\")\n\trequire(\"love.math\")\n\trequire(\"engine/extratable\")\n\n\trequire(\"engine/pathfinding\")\n\trequire(\"engine/quad_loader\")\n\trequire(\"engine/translation\")\n\trequire(\"engine/tilegrid\")\n\trequire(\"engine/objectgrid\")\n\t--require(\"engine/bitser\")\n\trequire(\"game/tilegrid/tilegrid\")\n\trequire(\"engine/ffiimagedata\")\n\n\trequire(\"game/world/floors\")\n\trequire(\"game/world/walls\")\n\n\trequire(\"game/pathfinder_thread\")\n\t--require(\"game/error_reporter\")\n\trequire(\"engine/extramath\")\n\n\trequire(\"engine/color\")\n\t\n\t-- load the lightCasters library\n\trequire(\"game/light_caster\")\n\t\n\t-- load lighting manager\n\trequire(\"game/lighting_manager\")\n\t\n\t-- load the quadtree class\n\tclass = require(\"engine/middleclass/middleclass\")\n\trequire(\"engine/quadtree\")\n\trequire(\"game/floor_quadtree\")\n\n\tlightingManager:init()\n\tlightingManager:setupDistributorHandlers()\n\tlightingManager.lightCasters = {}\n\tlightingManager.activeLightCasters = {}\n\tlightingManager.lightCasterMap = {}\n\tlightingManager.computeTable = {}\n\tlightingManager.prepareTable = {}\n\n\tlocal GC = 0\n\n\twhile not lightingManager.STOPPED do\n\t\tlightingManager:updateLoadDistributor()\n\t\t\n\t\tGC = GC + 1\n\t\t\n\t\tif GC >= 50 then\n\t\t\tcollectgarbage(\"step\", 10)\n\t\t\tGC = 0\n\t\tend\n\tend\n"

local ffi = require("ffi")
local tonumber, pairs, ipairs, type, collectgarbage = tonumber, pairs, ipairs, type, collectgarbage

ffi.cdef("\ttypedef struct {uint8_t a, r, g, b;} floodLightData;\n")

local floodLightData = ffi.typeof("floodLightData")

lightingManager.MAX_COMPUTE_THREADS = 16

function lightingManager:init()
	self.nextLightCompute = 0
	
	self:setUpdateFrequency(60)
	
	self.createdImageData = {}
	
	if MAIN_THREAD then
		self.lightCasterUpdate = {}
		
		if not self.lightingComputeThreads then
			self.loadDistributorThread = love.thread.newThread(lightingManager.LOAD_DISTRIBUTOR_THREAD_INIT)
			
			self.loadDistributorThread:start()
			
			self.lightingComputeThreads = {}
			
			local workerNames = {}
			local coreCount = math.min(lightingManager.MAX_COMPUTE_THREADS, love.system.getProcessorCount())
			
			for i = 1, coreCount do
				local channelName = self:getColorChannelThreadChannel(i)
				
				workerNames[#workerNames + 1] = channelName
				
				local thread = love.thread.newThread(_format(lightingManager.MULTI_THREAD_INIT_STRING, "CHANNEL_IN_NAME", channelName))
				
				thread:start()
				
				local channel = love.thread.getChannel(channelName)
				
				table.insert(self.lightingComputeThreads, {
					thread = thread,
					channel = channel
				})
			end
			
			self:sendInLoad(lightingManager.MESSAGE_TYPE.WORKER_LIST, workerNames)
		end
		
		local tileW, tileH = game.worldObject:getFloorTileGrid():getTileSize()
		
		self:sendInLoadWait(self.MESSAGE_TYPE.WORLD_SIZE, {
			game.WORLD_WIDTH * tileW + tileW,
			game.WORLD_HEIGHT * tileH + tileH,
			game.worldObject:getFloorCount(),
			game.WORLD_WIDTH,
			game.WORLD_HEIGHT
		})
		self:sendInLoad(lightingManager.MESSAGE_TYPE.OFFICE_TILES, studio:getOfficeBuildingMap():makeThreadTable())
		timeOfDay:init()
		self:setTileGrid(game.worldObject:getFloorTileGrid())
		self:setOverdrawRange(lightingManager.DEFAULT_OVERDRAW_RANGE_X, lightingManager.DEFAULT_OVERDRAW_RANGE_Y)
		self:setOfficeBrightnessLevel(lightingManager.OFFICE_BRIGHTNESS_LEVEL)
		priorityRenderer:add(self, lightingManager.DRAW_PRIORITY)
		self:initEventHandler()
	else
		self.floor = 1
	end
end

function lightingManager:prepareLightCasterData(obj)
	local worldX, worldY = obj:getPos()
	local gridX, gridY = obj:getLightCastCoordinates()
	local iterX, iterY = obj:getLightCastRange()
	local lightClr = obj:getLightColor()
	local floor = obj:getFloor()
	local data = obj.__lightCastData
	
	if not data then
		data = {
			tostring(obj),
			worldX,
			worldY,
			gridX,
			gridY,
			iterX,
			iterY,
			floor,
			lightClr:saveRGB()
		}
		obj.__lightCastData = data
	else
		data[2] = worldX
		data[3] = worldY
		data[4] = gridX
		data[5] = gridY
		data[6] = iterX
		data[7] = iterY
		data[8] = floor
		
		local clr = obj.lightColor
		local dest = data[9]
		
		dest[1] = clr.r
		dest[2] = clr.g
		dest[3] = clr.b
	end
	
	return data
end

function lightingManager:initializeLightCaster(obj)
	local data = self:prepareLightCasterData(obj)
	
	table.insert(data, obj:getLightCasterClass())
	self:sendInLoad(self.MESSAGE_TYPE.LIGHT_CREATED, data)
end

function lightingManager:updateLightCaster(obj)
	self:sendInLoad(self.MESSAGE_TYPE.LIGHT_UPDATED, self:prepareLightCasterData(obj))
end

function lightingManager:enableLightCaster(obj)
	self:sendInLoad(self.MESSAGE_TYPE.LIGHT_ENABLED, tostring(obj))
end

function lightingManager:disableLightCaster(obj)
	self:sendInLoad(self.MESSAGE_TYPE.LIGHT_DISABLED, tostring(obj))
end

function lightingManager:updateLightCasterColors(data)
	self:sendInLoad(self.MESSAGE_TYPE.LIGHT_COLOR_CHANGED, data)
end

function lightingManager:removeLightCaster(obj)
	self:sendInLoad(self.MESSAGE_TYPE.LIGHT_REMOVED, tostring(obj))
end

function lightingManager:_updateLightCasterColors(data)
	local clr = data[1]
	
	for i = 2, #data do
		local obj = self.lightCasterMap[data[i]]
		
		if obj then
			local dest = obj.lightColor
			
			dest.r, dest.g, dest.b = clr[1], clr[2], clr[3]
		end
	end
end

function lightingManager:stopAllThreads()
	if self.lightingComputeThreads then
		self:sendInWait(lightingManager.MESSAGE_TYPE.STOP, nil)
		
		for key, data in ipairs(self.lightingComputeThreads) do
			data.channel:clear()
			
			self.lightingComputeThreads[key] = nil
		end
		
		self.lightingComputeThreads = nil
		
		self:sendInLoad(lightingManager.MESSAGE_TYPE.STOP)
		
		self.loadDistributorThread = nil
		
		self.channelOut:clear()
		self.channelIn:clear()
	end
end

function lightingManager:getColorChannelThreadChannel(core)
	return lightingManager.CHANNEL_IN .. core
end

if MAIN_THREAD then
	function lightingManager:initEventHandler()
		events:addDirectReceiver(self, lightingManager.CATCHABLE_EVENTS)
	end
	
	function lightingManager:removeEventHandler()
		events:removeDirectReceiver(self, lightingManager.CATCHABLE_EVENTS)
	end
end

function lightingManager:getQualityPresets()
	return lightingManager.QUALITY_PRESETS
end

function lightingManager:setQualityPreset(presetId)
	presetId = presetId or lightingManager.DEFAULT_QUALITY_PRESET
	self.qualityPreset = presetId
	
	local presetData = lightingManager.QUALITY_PRESETS[presetId]
	
	self:setResolutionScale(presetData.resolutionScale)
	self:forceUpdate()
end

function lightingManager:getResolutionScale()
	return self.resolutionScale
end

function lightingManager:getPresetByResolutionScale(scale)
	for key, data in ipairs(lightingManager.QUALITY_PRESETS) do
		if data.resolutionScale == scale then
			return data
		end
	end
	
	return lightingManager.QUALITY_PRESETS[1]
end

function lightingManager:setOverdrawRange(x, y)
	self.overDrawRangeX = x
	self.overDrawRangeY = y
	
	if MAIN_THREAD then
		self:sendInWait(lightingManager.MESSAGE_TYPE.OVERDRAW_RANGE_CHANGED, {
			x,
			y
		})
		self:createImageData()
	end
end

local function resetColors(x, y, r, g, b, a)
	return 255, 255, 255, 255
end

function lightingManager:remove()
	if MAIN_THREAD then
		timeOfDay:remove()
		self:removeEventHandler()
		self.imageData:mapPixel(resetColors)
		self.image:refresh()
		self:sendInLoadWait(self.MESSAGE_TYPE.RESET)
	end
	
	self:removeObjectReferences()
	
	self.sentIn = false
end

function lightingManager:removeObjectReferences()
	self.imageData:destroy()
	
	self.imageData = nil
	self.image = nil
	self.lightData = nil
end

function lightingManager:onResolutionChanged()
	table.clearArray(self.createdImageData)
	self:createImageData()
	self:forceUpdate()
end

function lightingManager:setOfficeBrightnessLevel(level)
	self.officeBrightnessLevel = level
end

function lightingManager:getDataForScale(scale)
	for key, data in ipairs(self.createdImageData) do
		if data.zoomLevel == scale then
			return data
		end
	end
	
	return nil
end

local bitser = require("engine/bitser")

function lightingManager:createImageData()
	local curScale = camera:getZoomLevel()
	local prevData = self:getDataForScale(curScale)
	local tileW, tileH, width, height, scale
	
	if prevData then
		tileW, tileH = prevData.iterW, prevData.iterH
		width, height = prevData.width, prevData.height
		scale = prevData.scale
	else
		tileW, tileH = math.ceil(scrW / game.WORLD_TILE_WIDTH / camera.scaleX), math.ceil(scrH / game.WORLD_TILE_HEIGHT / camera.scaleX)
		width, height = tileW + self.overDrawRangeX * 2, tileH + self.overDrawRangeY * 2
		scale = self.resolutionScale
	end
	
	self.tileWidth = tileW
	self.tileHeight = tileH
	
	self:sendInWait(lightingManager.MESSAGE_TYPE.SCALE_CHANGED, bitser.dumps({
		resolutionScale = self.resolutionScale,
		iterationX = self.tileWidth,
		iterationY = self.tileHeight
	}))
	
	self.nextLightCompute = 0
	
	if prevData then
		self.imageData = prevData.imageData
		self.image = prevData.image
	else
		local w, h = width * scale + scale * 2, height * scale + scale * 2
		
		self.imageData = love.image.newImageData(w, h)
		self.image = love.graphics.newImage(self.imageData)
		
		self.image:setFilter(lightingManager.FILTER_MODE, lightingManager.FILTER_MODE)
		
		self.createdImageData[#self.createdImageData + 1] = {
			imageData = self.imageData,
			image = self.image,
			iterW = tileW,
			iterH = tileH,
			width = width,
			height = height,
			scale = scale,
			zoomLevel = curScale
		}
		
		for x = 0, w - 1 do
			for y = 0, h - 1 do
				self.imageData:setAlpha(x, y, 255)
			end
		end
	end
	
	self:updateImageDataDimensions()
	self:sendInLoadWait(lightingManager.MESSAGE_TYPE.NEW_IMAGE_DATA, self.imageData)
	self:sendInWait(lightingManager.MESSAGE_TYPE.NEW_IMAGE_DATA, self.imageData)
end

function lightingManager:setResolutionScale(scale)
	local oldScale = self.resolutionScale
	
	self.resolutionScale = math.max(1, math.min(lightingManager.maxResolutionScale, scale))
	self.resIterScale = self.resolutionScale - 1
	
	self:sendInLoad(lightingManager.MESSAGE_TYPE.RESOLUTION_SCALE, self.resolutionScale)
	
	if MAIN_THREAD and self.imageData and oldScale ~= self.resolutionScale then
		table.clearArray(self.createdImageData)
		self:createImageData()
	end
end

function lightingManager:updateImageDataDimensions()
	local w, h = self.imageData:getDimensions()
	local scale = self.resolutionScale
	
	self.imageWidth, self.imageHeight = w - scale, h - scale
end

function lightingManager:setUpdateFrequency(freq)
	self.updateFrequency = freq
	self.updateDelay = 1 / freq
end

function lightingManager:setImageData(data)
	self.imageData = data
	
	self:updateImageDataDimensions()
	
	if not MAIN_THREAD then
		self.lightData = ffi.new("floodLightData[?]", (self.imageHeight + 2) * (self.imageWidth + 2))
		self.indexOffset = 1 * (self.imageWidth + 2) + 1
		self.realImageWidth = self.imageWidth + 2
		self.realImageHeight = self.imageHeight + 2
		self.lightDataIndexCount = (self.imageHeight - 1) * self.imageWidth + (self.imageWidth - 1)
	end
end

function lightingManager:updateMain()
	if #self.lightCasterUpdate > 0 then
		for key, object in ipairs(self.lightCasterUpdate) do
		end
	end
	
	if self.paused and not self.forcingUpdate and not camera.updatedCamera then
		return 
	end
	
	self.nextLightCompute = self.nextLightCompute - frameTime
	
	if self.nextLightCompute <= 0 then
		self:prepareLightData()
		
		self.sentIn = true
		self.nextLightCompute = self.updateDelay
		self.forcingUpdate = false
	end
end

function lightingManager:setupDistributorHandlers()
	local msgType = lightingManager.MESSAGE_TYPE
	
	self.payloadHandler = {
		[msgType.TASK_DONE] = function(lm, data)
			lm.doneCompute = lm.doneCompute + 1
			
			if lm.doneCompute == lm.workerCount then
				if lm.secondFlood then
					if lm.workStage >= lightingManager.FLOOD_DIRECTION.left then
						lm:sendOut(msgType.COMPUTE_FINISHED)
					else
						lm.workStage = lm.workStage + 2
						
						lm:sendComputeRequest()
					end
				elseif lm.workStage >= lightingManager.FLOOD_DIRECTION.left then
					lm.secondFlood = true
					lm.workStage = lightingManager.FLOOD_DIRECTION.down
					
					lm:sendComputeRequest(lightingManager.FINISH_LIGHT_FADE_SPEED)
				else
					lm.workStage = lm.workStage + 2
					
					lm:sendComputeRequest()
				end
			end
		end,
		[msgType.test] = function(lm, data)
			lightingManager.WAVE_SIZE = data.payload
		end,
		[msgType.PREPARE_DONE] = function(lm, data)
			lm.finishedWorkers = lm.finishedWorkers + 1
			
			if lm.finishedWorkers == lm.workerCount then
				lm:castLight()
				lm:sendComputeRequest(lightingManager.START_LIGHT_FADE_SPEED)
				lm:_fillWorkQueue(lm.FLOOD_DIRECTION.left)
				lm:_fillWorkQueue(lm.FLOOD_DIRECTION.down)
				lm:_fillWorkQueue(lm.FLOOD_DIRECTION.left)
			end
		end,
		[msgType.WORK_RANGE] = function(lm, data)
			local decoded = data.payload
			
			lm.startX, lm.startY, lm.finishX, lm.finishY = decoded.startX, decoded.startY, decoded.finishX, decoded.finishY
			lm.computeTable[1] = decoded.baseX
			lm.computeTable[2] = decoded.baseY
			lm.officeBright = decoded.officeBright
			lm.workStage = lightingManager.FLOOD_DIRECTION.down
			lm.workChannelID = 1
			lm.curChannelID = 1
			lm.secondFlood = false
			
			lm:_prepareLightData(decoded)
		end,
		[msgType.WORKER_LIST] = function(lm, data)
			lm.lightingComputeThreads = {}
			lm.workerCount = #data.payload
			
			for key, channel in ipairs(data.payload) do
				lm.lightingComputeThreads[key] = {
					channel = love.thread.getChannel(channel)
				}
			end
		end,
		[pathfinderThread.MESSAGE_TYPE.GRID] = function(lm, data)
			lm:setTileGrid(data.payload)
			collectgarbage("collect")
			collectgarbage("collect")
		end,
		[pathfinderThread.MESSAGE_TYPE.GRID_UPDATE] = function(lm, data)
			lm:updateTileGrid(data.payload)
		end,
		[msgType.NEW_IMAGE_DATA] = function(lm, data)
			lm:setImageData(data.payload)
		end,
		[msgType.OFFICE_TILES] = function(lm, data)
			for key, data in pairs(data.payload) do
				lm.officeTileGrid[key] = true
				lm.floorMap[key] = self.cameraFloor
			end
			
			lm:sendInWait(msgType.OFFICE_TILES, {
				lm.ptrToOfficeTileGrid,
				lm.floorMapPtr,
				lm.firstFloorPtr,
				lm.cameraFloorPtr
			})
		end,
		[msgType.OFFICE_TILE_UPDATE] = function(lm, data)
			for key, index in ipairs(data.payload) do
				lm.officeTileGrid[index] = true
				lm.floorMap[index] = self.cameraFloor
			end
		end,
		[msgType.RESOLUTION_SCALE] = function(lm, data)
			lm.resolutionScale = data.payload
		end,
		[msgType.STOP] = function(lm, data)
			lm.STOPPED = true
		end,
		[msgType.LIGHT_CREATED] = function(lm, data)
			lm:_initializeLightCaster(data.payload)
		end,
		[msgType.LIGHT_DISABLED] = function(lm, data)
			lm:_disableLightCaster(data.payload)
		end,
		[msgType.LIGHT_ENABLED] = function(lm, data)
			lm:_enableLightCaster(data.payload)
		end,
		[msgType.LIGHT_REMOVED] = function(lm, data)
			lm:_removeLightCaster(data.payload)
		end,
		[msgType.LIGHT_UPDATED] = function(lm, data)
			lm:_updateLightCaster(data.payload)
		end,
		[msgType.LIGHT_COLOR_CHANGED] = function(lm, data)
			lm:_updateLightCasterColors(data.payload)
		end,
		[msgType.WORLD_SIZE] = function(lm, data)
			local pl = data.payload
			local container = floorQuadTree.new(pl[1], pl[2], pl[3])
			
			lm.lightQuadTree = container
			lm.worldW, lm.worldH = pl[4], pl[5]
			
			lm:initOfficeTileGrid()
			
			if lm.floor then
				lm.curLightQuadTree = container:getQuadTree(lm.floor)
			end
			
			for key, caster in ipairs(lm.lightCasters) do
				container:insert(caster)
			end
			
			self:sendInWait(msgType.WORLD_SIZE, {
				pl[4],
				pl[5]
			})
		end,
		[msgType.RESET] = function(lm, data)
			for key, casterObj in ipairs(lm.lightCasters) do
				lm.lightCasters[key] = nil
				lm.lightCasterMap[casterObj._id] = nil
			end
			
			table.clearArray(lm.activeLightCasters)
			
			lm.lightQuadTree = nil
			lm.officeTileGrid = nil
			lm.floorMap = nil
			lm.firstFloor = nil
			lm.cameraFloor = nil
			
			lm:removeObjectReferences()
			
			if lm.grid then
				lm.grid:remove()
				
				lm.grid = nil
			end
			
			collectgarbage("collect")
			collectgarbage("collect")
		end,
		[pathfinderThread.MESSAGE_TYPE.FLOOR] = function(lm, data)
			lm.floor = data.payload
			
			if lm.cameraFloor then
				lm.cameraFloor[0] = lm.floor
			end
			
			if lm.lightQuadTree then
				lm.curLightQuadTree = lm.lightQuadTree:getQuadTree(lm.floor)
			end
			
			lm:sendInWait(pathfinderThread.MESSAGE_TYPE.FLOOR, data.payload)
		end
	}
end

function lightingManager:updateLoadDistributor()
	local data = self.loadChannelIn:demand()
	
	self.payloadHandler[data.type](self, data)
end

function lightingManager:_initializeLightCaster(data)
	local obj = lightCasters:create(data[10])
	
	obj:setPos(data[2], data[3])
	obj:setCastPos(data[4], data[5])
	obj:setCastRange(data[6], data[7])
	obj:setFloor(data[8])
	
	local clr = data[9]
	local dest = obj.lightColor
	
	dest.r, dest.g, dest.b = clr[1], clr[2], clr[3]
	
	local id = data[1]
	
	table.insert(self.lightCasters, obj)
	
	self.lightCasterMap[id] = obj
	obj._active = true
	obj._id = id
	
	if self.lightQuadTree then
		self.lightQuadTree:insert(obj)
	end
end

function lightingManager:_updateLightCaster(data)
	local obj = self.lightCasterMap[data[1]]
	
	obj:setPos(data[2], data[3])
	obj:setCastPos(data[4], data[5])
	obj:setCastRange(data[6], data[7])
	
	local prevFloor, newFloor = obj:getFloor(), data[8]
	
	if obj._active then
		if prevFloor ~= newFloor then
			self.lightQuadTree:move(obj, newFloor)
			table.removeObject(self.activeLightCasters, obj)
		else
			self.lightQuadTree:insert(obj)
		end
	end
	
	obj:setFloor(newFloor)
end

function lightingManager:_enableLightCaster(id)
	local obj = self.lightCasterMap[id]
	
	self.lightQuadTree:insert(obj)
	
	obj._active = true
end

function lightingManager:_disableLightCaster(id)
	local obj = self.lightCasterMap[id]
	
	if obj then
		self.lightQuadTree:remove(obj)
		
		obj._active = false
	end
end

function lightingManager:_removeLightCaster(id)
	local obj = self.lightCasterMap[id]
	
	table.removeObject(self.lightCasters, obj)
	self.lightQuadTree:remove(obj)
	
	self.lightCasterMap[id] = nil
end

local taskTable = {}

lightingManager.WAVE_SIZE = 6

function lightingManager:_fillWorkQueue(direction)
	local channel = self.workChannels[self.workChannelID]
	local dirs = self.FLOOD_DIRECTION
	local topBottom = dirs.down
	local leftRight = dirs.left
	local wave = self.WAVE_SIZE
	
	if direction == topBottom then
		taskTable[3] = topBottom
		
		local iter = self.startX + 1
		local size = self.finishX - 1
		local rng = math.ceil((size - iter) / wave)
		
		while iter < size do
			local new = math.min(size, iter + wave)
			
			taskTable[1] = iter
			taskTable[2] = new
			iter = new + 1
			
			channel:push(taskTable)
		end
	elseif direction == leftRight then
		taskTable[3] = leftRight
		
		local iter = self.startY + 1
		local size = self.finishY - 1
		local rng = math.ceil((size - iter) / wave)
		
		while iter < size do
			local new = math.min(size, iter + wave)
			
			taskTable[1] = iter
			taskTable[2] = new
			iter = new + 1
			
			channel:push(taskTable)
		end
	end
	
	self.workChannelID = self.workChannelID + 1
end

function lightingManager:sendComputeRequest(fadeSpeed)
	self.computeTable[3] = fadeSpeed
	self.computeTable[4] = self.curChannelID
	
	self:sendIn(self.MESSAGE_TYPE.COMPUTE_REQUEST, self.computeTable)
	
	self.doneCompute = 0
	self.curChannelID = self.curChannelID + 1
end

function lightingManager:setupComputeHandlers()
	local msgType = lightingManager.MESSAGE_TYPE
	
	self.payloadHandler = {
		[msgType.SCALE_CHANGED] = function(lm, data)
			local decoded = bitser.loads(data.payload)
			
			lm:setResolutionScale(decoded.resolutionScale)
			
			lm.tileWidth = decoded.iterationX
			lm.tileHeight = decoded.iterationY
		end,
		[msgType.NEW_IMAGE_DATA] = function(lm, data)
			lm:setImageData(data.payload)
		end,
		[msgType.WORLD_SIZE] = function(lm, data)
			lm.worldW, lm.worldH = data.payload[1], data.payload[2]
		end,
		[msgType.COMPUTE_REQUEST] = function(lm, data)
			lm.baseX, lm.baseY, lm.finishX, lm.finishY = lm:getIterationRange(data.payload[1], data.payload[2])
			
			if data.payload[3] then
				lm.fadeSpeed = data.payload[3]
			end
			
			local channel = lm.workChannels[data.payload[4]]
			local res = lm.resolutionScale
			
			lm.xDiff = (lm.finishX - lm.baseX) * res
			lm.yDiff = (lm.finishY - lm.baseY) * res
			
			local fadeSpeed = (lm.fadeSpeed or lm.LIGHT_FADE_SPEED) / lm.resolutionScale
			
			while true do
				local task = channel:pop()
				
				if not task then
					break
				else
					lm:_performFloodTask(task, fadeSpeed)
				end
			end
			
			lm:sendInLoad(lm.MESSAGE_TYPE.TASK_DONE)
		end,
		[msgType.PREPARATION] = function(lm, data)
			local pl = data.payload
			local prepXS, prepXF, prepY = pl[1], pl[2], pl[3]
			local bright, r, g, b = pl[4], pl[5], pl[6], pl[7]
			
			lm.fadeSpeed = pl[8]
			lm.taskData = data.payload
			
			while true do
				local y = lm.prepChannel:pop()
				
				if not y then
					break
				else
					lm:performPrepareTask(y)
				end
			end
			
			lm.taskData = nil
			
			lm:sendInLoad(lm.MESSAGE_TYPE.PREPARE_DONE)
		end,
		[pathfinderThread.MESSAGE_TYPE.GRID_UPDATE] = function(lm, data)
			lm:updateTileGrid(data.payload)
		end,
		[pathfinderThread.MESSAGE_TYPE.GRID] = function(lm, data)
			lm:setTileGrid(data.payload)
			collectgarbage("collect")
			collectgarbage("collect")
		end,
		[msgType.OVERDRAW_RANGE_CHANGED] = function(lm, data)
			lm:setOverdrawRange(data.payload[1], data.payload[2])
		end,
		[msgType.FADE_SPEED] = function(lm, data)
			lm.fadeSpeed = data.payload
		end,
		[msgType.OFFICE_TILES] = function(lm, data)
			lm.officeTileGrid = ffi.cast("bool *", data.payload[1])
			lm.floorMap = ffi.cast("char **", data.payload[2])
			lm.firstFloor = ffi.cast("char *", data.payload[3])
			lm.cameraFloor = ffi.cast("char *", data.payload[4])
		end,
		[msgType.STOP] = function(lm, data)
			lm.STOPPED = true
		end,
		[pathfinderThread.MESSAGE_TYPE.FLOOR] = function(lm, data)
			lm.floor = data.payload
			
			if lm.cameraFloor then
				lm.cameraFloor[0] = data.payload
			end
		end
	}
end

function lightingManager:initFloorTiles()
	for i = 0, (self.worldW + 1) * (self.worldH + 1) - 1 do
		if self.officeTileGrid[i] then
			self.floorMap[i] = self.cameraFloor
		end
	end
end

function lightingManager:applyOfficeTiles(data)
	for key, index in ipairs(data) do
		self.floorMap[index] = self.cameraFloor
		self.officeTileGrid[index] = true
	end
end

function lightingManager:updateCompute()
	local data = self.channelIn:demand()
	
	if data then
		self.payloadHandler[data.type](self, data)
	end
end

function lightingManager:sendIn(type, payload)
	local sendData = self.SEND_DATA
	
	sendData.type = type
	sendData.payload = payload
	
	if self.lightingComputeThreads then
		for key, data in ipairs(self.lightingComputeThreads) do
			data.channel:push(sendData)
		end
	end
end

function lightingManager:sendInWait(type, payload)
	local sendData = self.SEND_DATA
	
	sendData.type = type
	sendData.payload = payload
	
	if self.lightingComputeThreads then
		for key, data in ipairs(self.lightingComputeThreads) do
			data.channel:supply(sendData)
		end
	end
end

function lightingManager:sendInLoad(type, payload)
	local sendData = self.SEND_DATA
	
	sendData.type = type
	sendData.payload = payload
	
	lightingManager.loadChannelIn:push(sendData)
end

function lightingManager:sendInLoadWait(type, payload)
	local sendData = self.SEND_DATA
	
	sendData.type = type
	sendData.payload = payload
	
	if self.loadDistributorThread then
		lightingManager.loadChannelIn:supply(sendData)
	end
end

function lightingManager:sendOut(type, payload)
	local sendData = self.SEND_DATA
	
	sendData.type = type
	sendData.payload = payload
	
	self.channelOut:push(sendData)
end

function lightingManager:getIterationRange(baseX, baseY)
	local gridW, gridH = self.grid:getSize()
	
	return math.max(1, baseX - self.overDrawRangeX), math.max(1, baseY - self.overDrawRangeY), math.min(baseX + self.tileWidth + self.overDrawRangeX, gridW), math.min(baseY + self.tileHeight + self.overDrawRangeY, gridH)
end

function lightingManager:queueLightQuery()
	self.requiresQuery = true
end

function lightingManager:handleEvent(event)
	self.requiresQuery = true
end

lightingManager.LOAD_INFO_TABLE = {}

function lightingManager:prepareLightData()
	timeOfDay:updateLightValues()
	
	local brightnessLevel = timeOfDay:getBrightness()
	local lightColor = timeOfDay:getLightColor()
	local cameraX, cameraY = camera:getPosition()
	local floorTileGrid = game.worldObject:getFloorTileGrid()
	local objectGrid = game.worldObject:getObjectGrid()
	local camTileX, camTileY = floorTileGrid:worldToGrid(cameraX, cameraY)
	local startX, startY, finishX, finishY = self:getIterationRange(camTileX, camTileY)
	local officeBright
	
	if studio.expansion:isActive() then
		officeBright = math.max(self.officeBrightnessLevel, math.min(brightnessLevel, self.officeBrightnessLevel))
	else
		officeBright = math.min(brightnessLevel, self.officeBrightnessLevel)
	end
	
	local lightR, lightG, lightB = lightColor.r, lightColor.g, lightColor.b
	local resScale = self.resolutionScale
	local resScaleIterationRange = resScale - 1
	
	self.baseComputeX, self.baseComputeY = camTileX, camTileY
	self.iterStartX, self.iterStartY = startX, startY
	self.prevStartX, self.prevStartY, self.prevEndX, self.prevEndY = startX, startY, finishX, finishY
	
	local info = lightingManager.LOAD_INFO_TABLE
	
	info.startX = startX
	info.startY = startY
	info.finishX = finishX
	info.finishY = finishY
	info.queryX = startX * game.WORLD_TILE_WIDTH
	info.queryY = startY * game.WORLD_TILE_HEIGHT
	info.queryW = math.dist(startX, finishX) * game.WORLD_TILE_WIDTH
	info.queryH = math.dist(startY, finishY) * game.WORLD_TILE_HEIGHT
	info.officeBright = officeBright
	info.lightR = lightColor.r
	info.lightG = lightColor.g
	info.lightB = lightColor.b
	info.baseX = self.baseComputeX
	info.baseY = self.baseComputeY
	
	self:sendInLoad(lightingManager.MESSAGE_TYPE.WORK_RANGE, info)
end

function lightingManager:_prepareLightData(data)
	self:fillPreparationQueue(data)
	
	self.lStartX, self.lStartY = data.startX, data.startY
	
	self.curLightQuadTree:query(data.queryX, data.queryY, data.queryW, data.queryH, self.activeLightCasters)
end

function lightingManager:castLight()
	local resScale = self.resolutionScale
	local resScaleIterationRange = resScale - 1
	local imgData = self.imageData
	local casters = self.activeLightCasters
	local startX, startY = self.lStartX, self.lStartY
	
	for key, object in ipairs(casters) do
		local gridX, gridY = object:getCastPos()
		local iterX, iterY = object:getCastRange()
		local gridXFinish = gridX + iterX
		
		for y = gridY, gridY + iterY do
			local localY = (y - startY) * resScale + resScale
			
			for x = gridX, gridXFinish do
				local localX = (x - startX) * resScale + resScale
				
				for pixelY = 0, resScaleIterationRange do
					local realY = localY + pixelY
					
					for pixelX = 0, resScaleIterationRange do
						object:castLight(imgData, localX + pixelX, realY)
					end
				end
			end
		end
		
		casters[key] = nil
	end
end

function lightingManager:fillPreparationQueue(data)
	self.finishedWorkers = 0
	
	local startY, finishY = data.startY, data.finishY
	local prep = self.prepareTable
	
	prep[1], prep[2], prep[3] = data.startX, data.finishX, data.startY
	prep[4] = self.officeBright
	prep[5], prep[6], prep[7] = data.lightR, data.lightG, data.lightB
	
	local channel = self.prepChannel
	
	for y = startY, finishY do
		channel:push(y)
	end
	
	prep[8] = lightingManager.START_LIGHT_FADE_SPEED
	
	self:sendIn(self.MESSAGE_TYPE.PREPARATION, self.prepareTable)
	self:_fillWorkQueue(self.FLOOD_DIRECTION.down)
end

function lightingManager:performPrepareTask(y)
	local resScale = self.resolutionScale
	local resScaleIterationRange = resScale - 1
	local imgData = self.imageData
	local tData = self.taskData
	local startX, finishX, startY = tData[1], tData[2], tData[3]
	local officeBright = tData[4]
	local lightR, lightG, lightB = tData[5], tData[6], tData[7]
	local gridW = self.grid.gridWidth + 1
	local localY = y - startY
	local realY = localY * resScale + resScale
	local baseY = y * gridW
	
	for x = startX, finishX do
		local localX = x - startX
		local realX = localX * resScale + resScale
		
		if self.officeTileGrid[baseY + x] then
			for pixelY = 0, resScaleIterationRange do
				local y = realY + pixelY
				
				for pixelX = 0, resScaleIterationRange do
					imgData:setChannels(realX + pixelX, y, officeBright)
				end
			end
		else
			for pixelY = 0, resScaleIterationRange do
				local y = realY + pixelY
				
				for pixelX = 0, resScaleIterationRange do
					imgData:setRGB(realX + pixelX, y, lightR, lightG, lightB)
				end
			end
		end
	end
end

function lightingManager:initOfficeTileGrid()
	if not self.officeTileGrid then
		local size = (self.worldW + 1) * (self.worldH + 1)
		
		self.officeTileGrid = ffi.new(ffi.typeof("bool[?]"), size)
		
		local ptr = ffi.typeof("uintptr_t")
		
		self.ptrToOfficeTileGrid = tonumber(ffi.cast(ptr, self.officeTileGrid))
		self.floorMap = ffi.new(ffi.typeof("char *[?]"), size)
		self.floorMapPtr = tonumber(ffi.cast(ptr, self.floorMap))
		self.firstFloor = ffi.new(ffi.typeof("char[?]"), 0)
		self.firstFloor[0] = 1
		self.firstFloorPtr = tonumber(ffi.cast(ptr, self.firstFloor))
		self.cameraFloor = ffi.new(ffi.typeof("char[?]"), 0)
		self.cameraFloor[0] = self.floor
		self.cameraFloorPtr = tonumber(ffi.cast(ptr, self.firstFloor))
	end
end

function lightingManager:setTileGrid(data)
	if MAIN_THREAD then
		self.grid = data
	else
		self.grid = obstructionGrid.new(data.gridWidth, data.gridHeight, data.floors, nil, tileGrid.CUSTOM_STRUCTURES.FLOOR_STRUCTURE, data.pointers)
		self.gridW, self.gridH = data.gridWidth, data.gridHeight
		
		if COMPUTE_THREAD then
			local w, h = data.gridWidth, data.gridHeight
			
			for y = 1, h do
				for x = 1, w do
					self.floorMap[self.grid:getTileIndex(x, y)] = self.firstFloor
				end
			end
		end
		
		for i = 1, data.floors do
			local deserialised = bitser.loads(data.tiles[i])
			
			if i == 1 and COMPUTE_THREAD then
				local cameraFloor = self.cameraFloor
				
				for key, tileData in ipairs(deserialised.tiles) do
					self.floorMap[tileData.index] = self.cameraFloor
				end
			end
		end
	end
end

function lightingManager:checkForLighting()
	if self.sentIn then
		local result = self.channelOut:demand()
		
		if result then
			if result.type == lightingManager.MESSAGE_TYPE.COMPUTE_FINISHED then
				self.image:refresh()
			end
			
			self.sentIn = false
		end
	end
end

function lightingManager:pause()
	self.paused = true
end

function lightingManager:forceUpdate()
	self.forcingUpdate = true
	self.nextLightCompute = 0
end

function lightingManager:unpause()
	self.paused = false
end

function lightingManager:updateLightData()
	local imageData = self.imageData
	
	for y = 0, self.imageHeight - 1 do
		for x = 0, self.imageWidth - 1 do
			local data = self.lightData[self.indexOffset + y * self.realImageWidth + x]
			local r, g, b, a = imageData:getPixel(x, y)
			
			data.r, data.g, data.b, data.a = r, g, b, a
		end
	end
end

local function lerpChannel(from, to, dt)
	local final = from + dt * (to - from)
	
	final = final < 5 and 0 or final
	
	return final
end

local function lerpChannels(r1, r2, g1, g2, b1, b2, dt)
	local r = r1 + dt * (r2 - r1)
	local g = g1 + dt * (g2 - g1)
	local b = b1 + dt * (b2 - b1)
	
	return r, g, b
end

local function lerpLight(from, to, dt, fromMultiplier)
	return lerpChannel(tonumber(from.r) * fromMultiplier, tonumber(to.r), dt), lerpChannel(tonumber(from.g) * fromMultiplier, tonumber(to.g), dt), lerpChannel(tonumber(from.b) * fromMultiplier, tonumber(to.b), dt)
end

function lightingManager:_performFloodTask(taskData, fadeSpeed)
	local scale = self.resolutionScale
	local lightDataIndexCount = self.lightDataIndexCount
	local resScaleIterationRange = self.resIterScale
	local grid = self.grid
	local imageData = self.imageData
	local dirs = self.FLOOD_DIRECTION
	local WALL_UP = walls.UP
	local WALL_DOWN = walls.DOWN
	local WALL_LEFT = walls.LEFT
	local WALL_RIGHT = walls.RIGHT
	local max = math.max
	local dir = taskData[3]
	local gridW = grid.gridWidth + 1
	local wallMap = walls.penetrationByID
	local rotToID = walls.ROTATION_TO_ID
	
	if dir == dirs.down then
		for i = taskData[1], taskData[2] do
			local x = i
			local curPixelX = scale + (x - self.baseX) * scale
			local curPixelY = scale * 2
			local sideID = rotToID[WALL_UP]
			local xEnd = curPixelX + resScaleIterationRange
			
			for y = self.baseY + 1, self.finishY - 1 do
				local index = y * gridW + x
				local lightPenetration = wallMap[grid.tiles[self.floorMap[index][0]][index].wallIDs[sideID]]
				
				for pixelY = curPixelY, curPixelY + resScaleIterationRange do
					local curYBack = pixelY - 1
					
					for pixelX = curPixelX, xEnd do
						imageData:calculateLight(pixelX, pixelY, pixelX, curYBack, lightPenetration, fadeSpeed)
					end
				end
				
				curPixelY = curPixelY + scale
			end
			
			x = i
			curPixelX = scale + (x - self.baseX) * scale
			curPixelY = self.yDiff
			sideID = rotToID[WALL_DOWN]
			
			local xEnd = curPixelX + resScaleIterationRange
			
			for y = self.finishY - 1, self.baseY + 1, -1 do
				local index = y * gridW + x
				local lightPenetration = wallMap[grid.tiles[self.floorMap[index][0]][index].wallIDs[sideID]]
				
				for pixelY = curPixelY + resScaleIterationRange, curPixelY, -1 do
					local curYFront = pixelY + 1
					
					for pixelX = curPixelX, xEnd do
						imageData:calculateLight(pixelX, pixelY, pixelX, curYFront, lightPenetration, fadeSpeed)
					end
				end
				
				curPixelY = curPixelY - scale
			end
		end
	elseif dir == dirs.left then
		for i = taskData[1], taskData[2] do
			local y = i
			local curPixelY = scale + (y - self.baseY) * scale
			local curPixelX = scale * 2
			local sideID = rotToID[WALL_LEFT]
			local yEnd = curPixelY + resScaleIterationRange
			
			for x = self.baseX + 1, self.finishX - 1 do
				local index = y * gridW + x
				local lightPenetration = wallMap[grid.tiles[self.floorMap[index][0]][index].wallIDs[sideID]]
				local xEnd = curPixelX + resScaleIterationRange
				
				for pixelY = curPixelY, yEnd do
					for pixelX = curPixelX, xEnd do
						imageData:calculateLight(pixelX, pixelY, pixelX - 1, pixelY, lightPenetration, fadeSpeed)
					end
				end
				
				curPixelX = curPixelX + scale
			end
			
			curPixelY = curPixelY + scale
			y = i
			curPixelY = scale + (y - self.baseY) * scale
			curPixelX = self.xDiff
			sideID = rotToID[WALL_RIGHT]
			
			local yEnd = curPixelY + resScaleIterationRange
			
			for x = self.finishX - 1, self.baseX + 1, -1 do
				local index = y * gridW + x
				local lightPenetration = wallMap[grid.tiles[self.floorMap[index][0]][index].wallIDs[sideID]]
				local xStart = curPixelX + resScaleIterationRange
				
				for pixelY = curPixelY, yEnd do
					for pixelX = xStart, curPixelX, -1 do
						imageData:calculateLight(pixelX, pixelY, pixelX + 1, pixelY, lightPenetration, fadeSpeed)
					end
				end
				
				curPixelX = curPixelX - scale
			end
			
			curPixelY = curPixelY + scale
		end
	end
end

function lightingManager:applyToImageData(startX, startY, finishX, finishY)
	local curPixelX, curPixelY = 0, 0
	local scale = self.resolutionScale
	local resScaleIterationRange = scale - 1
	local lightData = self.lightData
	
	if self.channel then
		for y = startY, finishY - 1 do
			curPixelX = 0
			
			for x = startX, finishX - 1 do
				for pixelY = 0, resScaleIterationRange do
					local curY = curPixelY + pixelY
					
					for pixelX = 0, resScaleIterationRange do
						local curData = lightData[self.indexOffset + curY * self.realImageWidth + (curPixelX + pixelX)]
						
						self.imageData:setChannel(curPixelX + pixelX, curY, self.channel, tonumber(curData[self.channel]))
					end
				end
				
				curPixelX = curPixelX + scale
			end
			
			curPixelY = curPixelY + scale
		end
	else
		for y = startY, finishY - 1 do
			curPixelX = 0
			
			for x = startX, finishX - 1 do
				for pixelY = 0, resScaleIterationRange do
					local curY = curPixelY + pixelY
					
					for pixelX = 0, resScaleIterationRange do
						local curData = lightData[self.indexOffset + curY * self.realImageWidth + (curPixelX + pixelX)]
						
						self.imageData:setPixel(curPixelX + pixelX, curY, tonumber(curData.r), tonumber(curData.g), tonumber(curData.b), 255)
					end
				end
				
				curPixelX = curPixelX + scale
			end
			
			curPixelY = curPixelY + scale
		end
	end
end

function lightingManager:draw()
	if self.image then
		self:checkForLighting()
		
		local width, height = game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT
		local x, y = (self.iterStartX - 2) * width, (self.iterStartY - 2) * height
		local resScale = self.resolutionScale
		
		love.graphics.setBlendMode("multiply", "alphamultiply")
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.image, x, y, 0, width / resScale, height / resScale)
		love.graphics.setBlendMode("alpha", "alphamultiply")
	end
end
