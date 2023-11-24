local MAX_FOOTSTEPS = 3
local carpet = {}

carpet.name = "footstep_carpet"
carpet.sound = {}

local carpetString = "sounds/employees/footsteps/carpet/carpet-SOUND.ogg"

for i = 1, 14 do
	carpet.sound[#carpet.sound + 1] = _format(carpetString, "SOUND", string.format("%02d", i))
end

carpet.maxDistance = 400
carpet.fadeDistance = 400
carpet.soundType = "static"
carpet.looping = false
carpet.volume = 0.1
carpet.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(carpet)
register.newSoundChannel("footstep_carpet", MAX_FOOTSTEPS)

local tile = {}

tile.name = "footstep_tile"
tile.sound = {}

local tileString = "sounds/employees/footsteps/tile/tile-SOUND.ogg"

for i = 1, 26 do
	tile.sound[#tile.sound + 1] = _format(tileString, "SOUND", string.format("%02d", i))
end

tile.maxDistance = 400
tile.fadeDistance = 400
tile.soundType = "static"
tile.looping = false
tile.volume = 0.2
tile.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(tile)
register.newSoundChannel("footstep_tile", MAX_FOOTSTEPS)

local wood = {}

wood.name = "footstep_wood"
wood.sound = {}

local woodString = "sounds/employees/footsteps/wood/wood-SOUND.ogg"

for i = 1, 26 do
	wood.sound[#wood.sound + 1] = _format(woodString, "SOUND", string.format("%02d", i))
end

wood.maxDistance = 400
wood.fadeDistance = 400
wood.soundType = "static"
wood.looping = false
wood.volume = 0.33
wood.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(wood)
register.newSoundChannel("footstep_wood", MAX_FOOTSTEPS)

local asphalt = {}

asphalt.name = "footstep_asphalt"
asphalt.sound = {}

local asphaltString = "sounds/employees/footsteps/asphalt/asphalt-SOUND.ogg"

for i = 1, 16 do
	asphalt.sound[#asphalt.sound + 1] = _format(asphaltString, "SOUND", string.format("%02d", i))
end

asphalt.maxDistance = 400
asphalt.fadeDistance = 400
asphalt.soundType = "static"
asphalt.looping = false
asphalt.volume = 0.08
asphalt.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(asphalt)
register.newSoundChannel("footstep_asphalt", MAX_FOOTSTEPS)
