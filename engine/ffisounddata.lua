assert(love and love.sound, "love.sound is required")
assert(jit, "LuaJIT is required")

local tonumber, assert = tonumber, assert
local ffi = require("ffi")
local datatypes = {
	ffi.typeof("uint8_t *"),
	ffi.typeof("int16_t *")
}
local typemaxvals = {
	127,
	32767
}
local sounddata_mt

if debug then
	sounddata_mt = debug.getregistry().SoundData
else
	sounddata_mt = getmetatable(love.sound.newSoundData(1))
end

local _getBitDepth = sounddata_mt.__index.getBitDepth
local _getSampleCount = sounddata_mt.__index.getSampleCount
local _getChannels = sounddata_mt.__index.getChannels
local sd_registry = {
	__mode = "k"
}

function sd_registry:__index(sounddata)
	local bytedepth = _getBitDepth(sounddata) / 8
	local pointer = ffi.cast(datatypes[bytedepth], sounddata:getPointer())
	local p = {
		bytedepth = bytedepth,
		pointer = pointer,
		size = sounddata:getSize(),
		maxvalue = typemaxvals[bytedepth],
		samplecount = _getSampleCount(sounddata),
		channels = _getChannels(sounddata)
	}
	
	self[sounddata] = p
	
	return p
end

setmetatable(sd_registry, sd_registry)

local function SoundData_FFI_getSample(sounddata, i)
	local p = sd_registry[sounddata]
	
	assert(i >= 0 and i < p.size / p.bytedepth, "Attempt to get out-of-range sample!")
	
	if p.bytedepth == 2 then
		return tonumber(p.pointer[i]) / p.maxvalue
	else
		return (tonumber(p.pointer[i]) - 128) / 127
	end
end

local function SoundData_FFI_setSample(sounddata, i, value)
	local p = sd_registry[sounddata]
	
	assert(i >= 0 and i < p.size / p.bytedepth, "Attempt to set out-of-range sample!")
	
	if p.bytedepth == 2 then
		p.pointer[i] = value * p.maxvalue
	else
		p.pointer[i] = value * 127 + 128
	end
end

local function SoundData_FFI_getSampleCount(sounddata)
	local p = sd_registry[sounddata]
	
	return p.samplecount
end

local function SoundData_FFI_getChannels(sounddata)
	local p = sd_registry[sounddata]
	
	return p.channels
end

sounddata_mt.__index.getSample = SoundData_FFI_getSample
sounddata_mt.__index.setSample = SoundData_FFI_setSample
sounddata_mt.__index.getSampleCount = SoundData_FFI_getSampleCount
sounddata_mt.__index.getChannels = SoundData_FFI_getChannels
