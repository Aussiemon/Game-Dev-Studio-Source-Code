assert(love and love.image, "love.image is required")
assert(jit, "LuaJIT is required")

local tonumber, assert = tonumber, assert
local ffi = require("ffi")

pcall(ffi.cdef, "typedef struct ImageData_Pixel\n{\n\tuint8_t r, g, b, a;\n} ImageData_Pixel;\n")

local pixelptr = ffi.typeof("ImageData_Pixel *")

local function inside(x, y, w, h)
	if not (x >= 0) or not (x < w) or not (y >= 0) or not (y < h) then
		print("outside of", x, y, w, h)
	end
	
	return x >= 0 and x < w and y >= 0 and y < h
end

local imagedata_mt

if debug then
	imagedata_mt = debug.getregistry().ImageData
else
	imagedata_mt = getmetatable(love.image.newImageData(1, 1))
end

local _getWidth = imagedata_mt.__index.getWidth
local _getHeight = imagedata_mt.__index.getHeight
local _getDimensions = imagedata_mt.__index.getDimensions
local id_registry = {
	__mode = "k"
}

function id_registry:__index(imagedata)
	local width, height = _getDimensions(imagedata)
	local pointer = ffi.cast(pixelptr, imagedata:getPointer())
	local p = {
		width = width,
		height = height,
		pointer = pointer
	}
	
	self[imagedata] = p
	
	return p
end

setmetatable(id_registry, id_registry)

local function ImageData_FFI_destroy(imagedata)
	id_registry[imagedata].width = nil
	id_registry[imagedata].height = nil
	id_registry[imagedata].pointer = nil
	id_registry[imagedata] = nil
end

local function ImageData_FFI_mapPixel(imagedata, func, ix, iy, iw, ih)
	local p = id_registry[imagedata]
	local idw, idh = p.width, p.height
	
	ix = ix or 0
	iy = iy or 0
	iw = iw or idw
	ih = ih or idh
	
	assert(inside(ix, iy, idw, idh) and inside(ix + iw - 1, iy + ih - 1, idw, idh), "Invalid rectangle dimensions")
	
	local pixels = p.pointer
	
	for y = iy, iy + ih - 1 do
		for x = ix, ix + iw - 1 do
			local pix = y * idw + x
			local p = pixels[pix]
			local r, g, b, a = func(x, y, tonumber(p.r), tonumber(p.g), tonumber(p.b), tonumber(p.a))
			
			pixels[pix].r = r
			pixels[pix].g = g
			pixels[pix].b = b
			pixels[pix].a = a == nil and 255 or a
		end
	end
end

local function ImageData_FFI_getPixel(imagedata, x, y)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to get out-of-range pixel!")
	
	local pos = y * p.width + x
	
	return tonumber(p.pointer[pos].r), tonumber(p.pointer[pos].g), tonumber(p.pointer[pos].b), tonumber(p.pointer[pos].a)
end

local function ImageData_FFI_getRGB(imagedata, x, y)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to get out-of-range pixel!")
	
	local pos = y * p.width + x
	
	return tonumber(p.pointer[pos].r), tonumber(p.pointer[pos].g), tonumber(p.pointer[pos].b)
end

local function ImageData_FFI_setPixel(imagedata, x, y, r, g, b, a)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to set out-of-range pixel!")
	
	local pos = y * p.width + x
	
	p.pointer[pos].r = r
	p.pointer[pos].g = g
	p.pointer[pos].b = b
	p.pointer[pos].a = a
end

local function ImageData_FFI_setRGB(imagedata, x, y, r, g, b)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to set out-of-range pixel!")
	
	local pos = y * p.width + x
	
	p.pointer[pos].r = r
	p.pointer[pos].g = g
	p.pointer[pos].b = b
end

local function ImageData_FFI_setChannels(imagedata, x, y, v)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to set out-of-range pixel!")
	
	local pos = y * p.width + x
	
	p.pointer[pos].r = v
	p.pointer[pos].g = v
	p.pointer[pos].b = v
end

local function ImageData_FFI_setAlpha(imagedata, x, y, a)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to set out-of-range pixel!")
	
	p.pointer[y * p.width + x].a = a
end

local function ImageData_FFI_setChannel(imagedata, x, y, chan, value)
	local p = id_registry[imagedata]
	
	assert(inside(x, y, p.width, p.height), "Attempt to set out-of-range pixel!")
	
	p.pointer[y * p.width + x][chan] = value
end

local function ImageData_FFI_getChannel(imagedata, x, y, chan)
	local p = id_registry[imagedata]
	
	return tonumber(p.pointer[y * p.width + x][chan])
end

local function ImageData_FFI_getWidth(imagedata)
	return id_registry[imagedata].width
end

local function ImageData_FFI_getHeight(imagedata)
	return id_registry[imagedata].height
end

local function ImageData_FFI_getDimensions(imagedata)
	local p = id_registry[imagedata]
	
	return p.width, p.height
end

local function lerpChannels(r1, r2, g1, g2, b1, b2, dt)
	local r = r1 + dt * (r2 - r1)
	local g = g1 + dt * (g2 - g1)
	local b = b1 + dt * (b2 - b1)
	
	return r, g, b
end

local max = math.max

local function ImageData_FFI_calculateLight(imagedata, x1, y1, x2, y2, lightPene, fadeSpeed)
	local p = id_registry[imagedata]
	local pos = y1 * p.width + x1
	local curR, curG, curB = tonumber(p.pointer[pos].r), tonumber(p.pointer[pos].g), tonumber(p.pointer[pos].b)
	local pos2 = y2 * p.width + x2
	local prevR, prevG, prevB = tonumber(p.pointer[pos2].r), tonumber(p.pointer[pos2].g), tonumber(p.pointer[pos2].b)
	local resR, resG, resB = lerpChannels(prevR * lightPene, curR, prevG * lightPene, curG, prevB * lightPene, curB, fadeSpeed)
	
	p.pointer[pos].r, p.pointer[pos].g, p.pointer[pos].b = max(curR, resR), max(curG, resG), max(curB, resB)
end

imagedata_mt.__index.mapPixel = ImageData_FFI_mapPixel
imagedata_mt.__index.getPixel = ImageData_FFI_getPixel
imagedata_mt.__index.getRGB = ImageData_FFI_getRGB
imagedata_mt.__index.setPixel = ImageData_FFI_setPixel
imagedata_mt.__index.setRGB = ImageData_FFI_setRGB
imagedata_mt.__index.calculateLight = ImageData_FFI_calculateLight
imagedata_mt.__index.setChannels = ImageData_FFI_setChannels
imagedata_mt.__index.setAlpha = ImageData_FFI_setAlpha
imagedata_mt.__index.setChannel = ImageData_FFI_setChannel
imagedata_mt.__index.getChannel = ImageData_FFI_getChannel
imagedata_mt.__index.getWidth = ImageData_FFI_getWidth
imagedata_mt.__index.getHeight = ImageData_FFI_getHeight
imagedata_mt.__index.getDimensions = ImageData_FFI_getDimensions
imagedata_mt.__index.buildDataTable = ImageData_FFI_buildDataTable
imagedata_mt.__index.destroy = ImageData_FFI_destroy
