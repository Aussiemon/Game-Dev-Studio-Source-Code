spritesheetParser = {}
spritesheetParser.defaultTextureFormat = ".png"
spritesheetParser.defaultAtlasFormat = ".txt"
spritesheetParser.log = 0
spritesheetParser.PARSED_SPRITESHEETS = {}
spritesheetParser.PARSED_SPRITESHEETS_BY_ID = {}

function spritesheetParser:parse(path, textureFormat, atlasFormat, filteringModeMin, filteringModeMag)
	textureFormat = textureFormat or spritesheetParser.defaultTextureFormat
	atlasFormat = atlasFormat or spritesheetParser.defaultAtlasFormat
	filteringModeMin = filteringModeMin or "nearest"
	filteringModeMag = filteringModeMag or "nearest"
	
	local name = path .. textureFormat
	local texture = cache.newImage(name, filteringModeMin, filteringModeMag)
	local atlas = love.filesystem.read(path .. atlasFormat)
	local quads = string.explode(atlas, "\n")
	local total = 0
	local struct = {
		texture = texture,
		name = name,
		quads = {}
	}
	
	self.PARSED_SPRITESHEETS[#self.PARSED_SPRITESHEETS + 1] = struct
	self.PARSED_SPRITESHEETS_BY_ID[name] = struct
	
	local quadsList = struct.quads
	
	for key, quadConfig in ipairs(quads) do
		local quadData = string.explode(quadConfig, " = ")
		local quadName, quadDimensions = quadData[1], quadData[2]
		
		if quadDimensions then
			quadDimensions = string.explode(quadDimensions, " ")
			
			local x, y, w, h = quadDimensions[1], quadDimensions[2], quadDimensions[3], quadDimensions[4]
			local quad = quadLoader:load(quadName, texture, x, y, w, h)
			
			quadsList[#quadsList + 1] = quadName
			total = total + 1
		end
	end
	
	if spritesheetParser.log > 0 then
		print("parsed spritesheet", path, "total quads created:", total)
	end
	
	return texture
end

function spritesheetParser:deconstruct(path)
end

function spritesheetParser:getTextureData(textureName)
	return self.PARSED_SPRITESHEETS_BY_ID[textureName]
end
