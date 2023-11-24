registered.parallaxLayers = {}
parallax = {}
parallax.spriteBatchOrder = {}
parallax.spriteBatchContainers = {}
parallax.spriteBatchSize = 32

require("engine/parallax_layer")

function register.newParallaxLayer(tbl)
	local texture = cache.getImage(tbl.textureName)
	
	setmetatable(tbl, parallaxLayer.mtindex)
	
	tbl.w = texture:getWidth()
	tbl.h = texture:getHeight()
	tbl.renderW = tbl.w * tbl.scaleX
	tbl.renderH = tbl.h * tbl.scaleY
	tbl.mtindex = {
		__index = tbl
	}
	registered.parallaxLayers[tbl.name] = tbl
end

local mCeil, mFloor = math.ceil, math.floor
local gDraw = love.graphics.draw

local function sortByDepth(a, b)
	return a.depth > b.depth
end

function parallax:init()
	table.clear(self.spriteBatchOrder)
end

function parallax:setupSpriteBatch(textureName, sprites, depth)
	local texture = cache.getImage(textureName)
	
	sprites = sprites or self.spriteBatchSize
	depth = depth or 1
	
	local spriteBatch = love.graphics.newSpriteBatch(texture, sprites, "stream")
	local struct = {
		spritebatch = spriteBatch,
		depth = depth,
		textureName = textureName,
		layers = {}
	}
	
	self:prepareSlots(struct, sprites)
	
	self.spriteBatchContainers[textureName] = struct
end

function parallax:addSpriteBatchToOrder(textureName)
	local container = self.spriteBatchContainers[textureName]
	
	table.insert(self.spriteBatchOrder, container)
	table.sortl(self.spriteBatchOrder, sortByDepth)
end

function parallax:removeSpriteBatchFromOrder(textureName)
	local targetContainer = self.spriteBatchContainers[textureName]
	
	for key, container in ipairs(self.spriteBatchOrder) do
		if container == targetContainer then
			for key2, layer in pairs(container.layers) do
				layer:freeSpriteSlot()
				
				container.layers[key2] = nil
			end
			
			table.remove(self.spriteBatchOrder, key)
			
			return true
		end
	end
	
	return false
end

function parallax:getSpriteBatchContainer(textureName)
	return self.spriteBatchContainers[textureName]
end

function parallax:prepareSlots(struct, sprites)
	struct.slots = {}
	
	local spriteBatch = struct.spritebatch
	
	for i = 0, sprites - 1 do
		spriteBatch:add(0, 0, 0, 0, 0)
		
		struct.slots[i] = false
	end
end

function parallax:allocateSlot(textureName)
	local container = self.spriteBatchContainers[textureName]
	
	for i = 0, #container.slots do
		if not container.slots[i] then
			container.slots[i] = true
			
			return i
		end
	end
end

function parallax:deallocateSlot(textureName, slot)
	local container = self.spriteBatchContainers[textureName]
	
	container.spritebatch:set(slot, 0, 0, 0, 0, 0)
	
	container.slots[slot] = false
end

function parallax:addLayer(layerName)
	local targetLayer = registered.parallaxLayers[layerName]
	
	if not targetLayer then
		return nil
	end
	
	local container = self.spriteBatchContainers[targetLayer.textureName]
	
	for k, v in ipairs(container.layers) do
		if v.name == layerName then
			return false
		end
	end
	
	local slot = self:allocateSlot(targetLayer.textureName)
	local layer = parallaxLayer.new(targetLayer)
	
	parallaxLayer:setSpriteBatch(container, slot)
	table.insert(container.layers, layer)
	table.sortl(container.layers, sortByDepth)
	
	return true
end

function parallax:removeLayer(layerName)
	local targetLayer = registered.parallaxLayers[layerName]
	local container = self.spriteBatchContainers[targetLayer.textureName]
	
	for key, layer in ipairs(container.layers) do
		if layer.name == layerName then
			layer:freeSpriteSlot()
			table.remove(container.layers, key)
			
			return true
		end
	end
	
	return false
end

local cbg, baseX, baseY

function parallax:draw()
	love.graphics.setColor(255, 255, 255, 255)
	
	for k, v in ipairs(self.spriteBatchOrder) do
		v.spritebatch:setColor(tod.brightness, tod.brightness, tod.brightness, 255)
		
		for key, layer in ipairs(v.layers) do
			layer:process()
		end
		
		love.graphics.draw(v.spritebatch, 0, 0, 0, 1, 1)
	end
end

function parallax:createBuffers()
	game.FBOS.backgroundBuffer = love.graphics.newCanvas(scrW, scrH)
	
	game.FBOS.backgroundBuffer:setFilter("nearest", "nearest")
end

parallax:init()
