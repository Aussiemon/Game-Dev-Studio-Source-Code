cache = {}
cache.imageCounter = 0
cache.cachedTextures = {}
cache.cachedTexturesList = {}
cache.texturesByID = {}
cache.idsByTextures = {}
cache.cachedSounds = {}
cache.texturePaths = {}
cache.texturePathsByID = {}
cache.soundVolumes = {}

local newImage = love.graphics.newImage
local newSource = love.audio.newSource

love.graphics.setDefaultFilter("linear", "nearest", 0)

function cache.getTexturePath(textureObject)
	return cache.texturePaths[textureObject]
end

function cache.getTexturePathByID(id)
	return cache.texturePathsByID[id]
end

function cache.newImage(img, filterMin, filterMag)
	if cache.cachedTextures[img] then
		return cache.cachedTextures[img]
	end
	
	filterMin = filterMin or "nearest"
	filterMag = filterMag or "nearest"
	cache.imageCounter = cache.imageCounter + 1
	
	local image = newImage(img)
	
	image:setFilter(filterMin, filterMag, 16)
	image:setWrap("repeat", "repeat")
	
	cache.cachedTextures[img] = image
	
	table.insert(cache.cachedTexturesList, img)
	
	cache.texturePaths[image] = img
	cache.texturePathsByID[cache.imageCounter] = img
	cache.texturesByID[cache.imageCounter] = image
	cache.idsByTextures[image] = cache.imageCounter
	
	return image
end

function cache.getImageID(texture)
	return cache.idsByTextures[texture]
end

function cache.getImageByID(id)
	return cache.texturesByID[id]
end

function cache.newSound(name, stype, vol, loop)
	vol = vol or 1
	loop = loop or false
	stype = stype or "static"
	
	local src = newSource(name, stype)
	
	src:setVolume(vol)
	src:setLooping(loop)
	
	cache.soundVolumes[name] = vol
	cache.cachedSounds[name] = src
	
	return cache.cachedSounds[name]
end

function cache.newImageNamed(name, img, wraph, wrapv, filterMin, filterMag)
	if cache.cachedTextures[name] then
		return cache.cachedTextures[name]
	end
	
	filterMin = filterMin or "nearest"
	filterMag = filterMag or "nearest"
	img = newImage(img)
	
	img:setFilter(filterMin, filterMag, 16)
	
	cache.cachedTextures[name] = img
	cache.texturePaths[img] = name
	
	if wraph then
		wrapv = wrapv or "clamp"
		
		img:setWrap(wraph, wrapv)
	end
	
	return cache.cachedTextures[name]
end

function cache.newSoundNamed(name, sound, stype, vol, loop)
	if cache.cachedSounds[name] then
		return cache.cachedSounds[name]
	end
	
	vol = vol or 1
	loop = loop or false
	stype = stype or "static"
	
	local src = newSource(sound, stype)
	
	src:setVolume(vol)
	src:setLooping(loop)
	
	cache.soundVolumes[name] = vol
	cache.cachedSounds[name] = src
	
	return cache.cachedSounds[name]
end

function cache.getImage(img)
	if cache.cachedTextures[img] then
		return cache.cachedTextures[img]
	end
	
	return cache.newImage(img)
end

function cache.removeImage(img)
	local imgObj = cache.cachedTextures[img]
	
	cache.cachedTextures[img] = nil
	cache.texturesByID[cache.idsByTextures[imgObj]] = nil
	cache.idsByTextures[imgObj] = nil
	
	table.removeObject(cache.cachedTexturesList, imgObj)
end

function cache.getSound(snd)
	if cache.cachedSounds[snd] then
		return cache.cachedSounds[snd]
	end
	
	return cache.newSound(snd, "static")
end

function cache.removeSound(snd)
	cache.cachedSounds[snd] = nil
	cache.soundVolumes[snd] = nil
end

function cache.getSoundVolume(sound)
	return cache.soundVolumes[sound]
end
