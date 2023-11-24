quadLoader = {}
quadLoader.allQuads = {}
quadLoader.allQuadsByObjects = {}

local quadStructFuncs = {}

quadStructFuncs.mtindex = {
	__index = quadStructFuncs
}

local registry = debug.getregistry()
local quadClass = registry.Quad

function quadStructFuncs:getScaleToSize(desiredSize)
	local largest = math.max(self.w, self.h)
	
	return desiredSize / largest
end

function quadLoader:load(quadName, texturePath, x, y, w, h)
	if self.allQuads[quadName] then
		return self.allQuads[quadName].quad
	end
	
	local texture
	
	if type(texturePath) == "string" then
		texture = cache.getImage(texturePath)
	else
		texture = texturePath
	end
	
	local refW, refH = texture:getDimensions()
	local quad = love.graphics.newQuad(x, y, w, h, refW, refH)
	local struct = {
		quad = quad,
		texture = texture,
		textureID = cache.getImageID(texture),
		name = quadName,
		x = x,
		y = y,
		w = w,
		h = h,
		imgW = refW,
		imgH = refH
	}
	
	setmetatable(struct, quadStructFuncs.mtindex)
	
	self.allQuads[quadName] = struct
	self.allQuadsByObjects[quad] = struct
	
	return quad
end

function quadLoader:getQuad(quadName)
	return self.allQuads[quadName].quad
end

function quadLoader:getQuadTexture(quadName)
	return self.allQuads[quadName].texture
end

function quadLoader:getQuadTextureID(quadName)
	return cache.getImageID(self.allQuads[quadName].texture)
end

function quadLoader:getQuadStructure(quadName)
	return self.allQuads[quadName]
end

function quadLoader:getQuadObjectStructure(quadObject)
	return self.allQuadsByObjects[quadObject]
end

function quadLoader:getQuadSize(quadName)
	local data = self.allQuads[quadName]
	
	return data.w, data.h
end

if quadClass then
	function quadClass:getScaleToSize(desiredSize)
		local data = quadLoader.allQuadsByObjects[self]
		local w, h = data.w, data.h
		local largest = math.max(w, h)
		
		return desiredSize / largest
	end
	
	function quadClass:getQuadDimensions(desiredSize)
		local data = quadLoader.allQuadsByObjects[self]
		local w, h = data.w, data.h
		local largest = math.max(w, h)
		local mul = desiredSize / largest
		
		return w * mul, h * mul
	end
	
	function quadClass:getOffsetToMiddle()
		local data = quadLoader.allQuadsByObjects[self]
		local w, h = data.w, data.h
		
		return w * 0.5, h * 0.5
	end
	
	function quadClass:getSize()
		local data = quadLoader.allQuadsByObjects[self]
		
		return data.w, data.h
	end
	
	function quadClass:getSpriteScale(desiredW, desiredH)
		local data = quadLoader.allQuadsByObjects[self]
		local w, h = data.w, data.h
		
		return desiredW / w, desiredH / h
	end
end

local spriteBatchClass = registry.SpriteBatch
local imageClass = registry.Image

if imageClass then
	function imageClass:getSpriteScale(desiredW, desiredH)
		local w, h = self:getDimensions()
		
		return desiredW / w, desiredH / h
	end
	
	function imageClass:getScaleToSize(desiredSize)
		local w, h = self:getDimensions()
		local largest = math.max(w, h)
		
		return desiredSize / largest
	end
end
