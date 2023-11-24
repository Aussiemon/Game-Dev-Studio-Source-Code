fonts = {}
fonts.createdFonts = {}
fonts.namesByObjects = {}
fonts.allDesiredFonts = {}
fonts.fallbackFontDB = {}

function fonts.createNewFont(font, name, size, scaler, skipScaling, fallbacks)
	scaler = scaler or "ui"
	fallbacks = fallbacks or {}
	
	local fontConfig = {
		font = font,
		name = name,
		size = size,
		scaler = scaler,
		skipScaling = skipScaling,
		fallbacks = fallbacks,
		fallbackFonts = {}
	}
	
	fonts.allDesiredFonts[#fonts.allDesiredFonts + 1] = fontConfig
	
	local scaledSize = fonts.getFontSize(fontConfig)
	local fontObject = love.graphics.newFont(font, scaledSize)
	
	fontObject:setFilter("nearest", "nearest", 0)
	fonts.initSymbolWidthData(fontObject)
	
	fonts.createdFonts[name] = fontObject
	fonts.namesByObjects[fontObject] = name
	
	if #fallbacks > 0 then
		for key, fontName in ipairs(fallbacks) do
			fonts.initFallback(fontConfig, fontName)
		end
	end
	
	return fontObject
end

local createdFonts = {}

function fonts.createNewFonts(font, baseName, sizeOffset, scaler, ...)
	table.clear(createdFonts)
	
	sizeOffset = sizeOffset or 0
	
	for i = 1, select("#", ...) do
		local size = select(i, ...)
		
		createdFonts[#createdFonts + 1] = fonts.createNewFont(font, baseName .. size, size + sizeOffset, scaler)
	end
	
	return createdFonts
end

function fonts.getFontSize(fontData)
	if not fontData.skipScaling then
		return scaling[fontData.scaler](fontData.size)
	else
		return fontData.size
	end
end

function fonts.setFallbacks(fontPath, fallbackFont)
	if not fonts.fallbackFontDB[fallbackFont] then
		fonts.fallbackFontDB[fallbackFont] = {
			__mode = "k"
		}
	end
	
	for key, fontData in ipairs(fonts.allDesiredFonts) do
		if fontData.font == fontPath then
			fontData.fallbacks[#fontData.fallbacks + 1] = fallbackFont
			
			fonts.initFallback(fontData, fallbackFont)
		end
	end
end

function fonts.initFallback(data, fallbackFont)
	local size = fonts.getFontSize(data)
	local object = fonts.fallbackFontDB[fallbackFont][size]
	
	if not object then
		object = love.graphics.newFont(fallbackFont, size)
		fonts.fallbackFontDB[fallbackFont][size] = object
	end
	
	data.fallbackFonts[#data.fallbackFonts + 1] = object
	
	fonts.updateFallbacks(data)
	fonts.initSymbolWidthData(object)
end

function fonts.updateFallbacks(data)
	fonts.createdFonts[data.name]:setFallbacks(unpack(data.fallbackFonts))
end

function fonts.initSymbolWidthData(fontObject)
	local sWidth = string.symbolWidth
	
	sWidth[fontObject] = sWidth[fontObject] or {}
	sWidth[fontObject]["..."] = fontObject:getWidth("...")
end

function fonts.recreateFonts()
	table.clear(string.symbolWidth)
	
	local createdFonts, namesByObjects = fonts.createdFonts, fonts.namesByObjects
	
	for i = #fonts.allDesiredFonts, 1, -1 do
		local data = fonts.allDesiredFonts[i]
		
		if data.fallbackFonts then
			local fontObject = createdFonts[data.name]
			
			createdFonts[data.name] = nil
			namesByObjects[fontObject] = nil
			
			if fontObject then
				fontObject:setFallbacks()
				table.clearArray(data.fallbackFonts)
			end
		end
		
		table.remove(fonts.allDesiredFonts, i)
		fonts.createNewFont(data.font, data.name, data.size, data.scaler, data.skipScaling, data.fallbacks)
	end
end

function fonts.get(name)
	return fonts.createdFonts[name]
end

local registry = debug.getregistry()
local fontClass = registry.Font

function fontClass:getTextHeight(text)
	return string.countlines(text) * self:getHeight()
end
