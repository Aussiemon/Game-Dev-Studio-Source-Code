function love.filesystem.saveFileTo(dir, name, data)
	love.filesystem.setIdentity(dir)
	love.filesystem.write(name, data)
end

function love.filesystem.readFileFrom(dir, name)
	love.filesystem.setIdentity(dir)
	love.filesystem.read(name)
end

love.graphics.oldPrint = love.graphics.print

function love.graphics.print(text, x, y, ...)
	love.graphics.oldPrint(text, math.round(x), math.round(y), ...)
end

function love.graphics.printST(text, x, y, tr, tg, tb, ta, sr, sg, sb, sa, rotation, xScale, yScale, originOffX, originOffY)
	local r, g, b, a = love.graphics.getColor()
	
	tr, tg, tb, ta = tr or 255, tg or 255, tb or 255, ta or 255
	sr, sg, sb, sa = sr or 0, sg or 0, sb or 0, sa or 255
	x, y = math.round(x), math.round(y)
	
	love.graphics.setColor(sr, sg, sb, sa)
	love.graphics.print(text, x + 1, y + 1, rotation, xScale, yScale, originOffX, originOffY)
	love.graphics.setColor(tr, tg, tb, ta)
	love.graphics.print(text, x, y, rotation, xScale, yScale, originOffX, originOffY)
	love.graphics.setColor(r, g, b, a)
end

love.graphics.colorMod = color(1, 1, 1, 1)

function love.graphics.setColorModulation(r, g, b, a)
	love.graphics.colorMod.r = r
	love.graphics.colorMod.g = g
	love.graphics.colorMod.b = b
	love.graphics.colorMod.a = a
end

love.graphics.lastColor = color(255, 255, 255, 255)

local lc = love.graphics.lastColor
local oldSetColor = love.graphics.setColor

function love.graphics.setColor(r, g, b, a)
	local mod = love.graphics.colorMod
	
	oldSetColor(r * mod.r, g * mod.g, b * mod.b, a * mod.a)
end

function love.graphics.setColorX(r, g, b, a)
	if r ~= lc.r or g ~= lc.g or b ~= lc.b or a ~= lc.a then
		love.graphics.setColor(r, g, b, a)
		
		lc.r = r
		lc.g = g
		lc.b = b
		lc.a = a
	end
end

function love.audio.playX(snd, x, y)
	if type(snd) == "table" then
		snd = table.random(snd)
	end
	
	snd:rewind()
	snd:play()
	
	if not audio[snd] then
		audio[snd] = snd
	end
end

function love.audio.playSoundChannel(snd)
	local chan = sound.pickChannel(snd)
	
	chan:rewind()
	chan:play()
end

function love.filesystem.findAllFiles(dir, tbl)
	for k, v in pairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. v) then
			love.filesystem.findAllFiles(dir .. "/" .. v, tbl)
		else
			table.insert(tbl, dir .. "/" .. v)
		end
	end
end

function love.filesystem.getGameDirectory()
	return love.filesystem.getWorkingDirectory() .. "/" .. game.name .. "/"
end

function love.filesystem.loadAllLuaFiles(directory)
	for key, fileName in pairs(love.filesystem.getDirectoryItems(directory)) do
		local file = love.filesystem.load(directory .. "/" .. fileName)
		
		if file then
			file()
		end
	end
end

function dofile_game(filePath)
	return dofile(game.rootPath .. filePath)
end

local totalFiles = {}

for k, v in pairs(love.filesystem.getDirectoryItems("mods")) do
	local dir = "mods/" .. v .. "/lua"
	
	if love.filesystem.isDirectory(dir) then
		for k2, v2 in pairs(love.filesystem.getDirectoryItems(dir)) do
			local subDir = dir .. "/" .. v2
			
			if love.filesystem.isDirectory(subDir) then
				love.filesystem.findAllFiles(subDir, totalFiles)
			end
		end
	end
end

local registry = debug.getregistry()
local imageClass = registry.Image

function imageClass:getScaleToSize(desiredSize)
	local w, h = self:getDimensions()
	local largest = math.max(w, h)
	
	return desiredSize / largest
end

function imageClass:getCenterTo(x, y, scale)
	scale = scale or 1
	
	local w, h = self:getDimensions()
	
	w, h = w * scale, h * scale
	
	return math.round(x * 0.5 - w * 0.5), math.round(y * 0.5 - h * 0.5)
end

function printd(...)
	print(debug.getinfo(2, "S").source, ...)
end
