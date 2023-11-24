lightCasters = {}
lightCasters.registered = {}
lightCasters.registeredByID = {}

function lightCasters:registerNew(data, inherit)
	if inherit then
		setmetatable(data, lightCasters.registeredByID[inherit].mtindex)
	end
	
	data.mtindex = {
		__index = data
	}
	lightCasters.registered[#lightCasters.registered + 1] = data
	lightCasters.registeredByID[data.id] = data
end

function lightCasters:create(id)
	local new = {}
	
	setmetatable(new, lightCasters.registeredByID[id].mtindex)
	new:init()
	
	return new
end

local lightCaster = {}

lightCaster.id = "light_caster"

function lightCaster:init()
	self.x = 0
	self.y = 0
	
	local clr = self.lightColor
	
	self.lightColor = color(clr.r, clr.g, clr.b, 255)
end

function lightCaster:setPos(x, y)
	self.x = x
	self.y = y
end

function lightCaster:setFloor(floor)
	self.floor = floor
end

function lightCaster:getFloor()
	return self.floor
end

function lightCaster:setCastPos(x, y)
	self.castX = x
	self.castY = y
end

function lightCaster:setCastRange(w, h)
	self.castW = w
	self.castH = h
end

function lightCaster:getCastPos()
	return self.castX, self.castY
end

function lightCaster:getCastRange()
	return self.castW, self.castH
end

function lightCaster:getPos()
	return self.x, self.y
end

function lightCaster:setSize(w, h)
	self.w = w
	self.h = h
end

function lightCaster:getSize()
	return self.w, self.h
end

function lightCaster:getBoundingBox()
	return self.x, self.y, self.w, self.h
end

function lightCaster:castLight(imageData, pixelX, pixelY)
	local clr = self.lightColor
	local r, g, b = imageData:getPixel(pixelX, pixelY)
	
	imageData:setPixel(pixelX, pixelY, math.max(r, clr.r), math.max(g, clr.g), math.max(b, clr.b), 255)
end

lightCasters:registerNew(lightCaster)

local lampCaster = {}

lampCaster.id = "lamp_caster"
lampCaster.w = 48
lampCaster.h = 48
lampCaster.lightColor = color(251, 255, 237, 255)

lightCasters:registerNew(lampCaster, "light_caster")

local vendingMachine = {}

vendingMachine.id = "vending_machine_caster"
vendingMachine.w = 96
vendingMachine.h = 48
vendingMachine.lightColor = color(178, 154, 121, 255)

lightCasters:registerNew(vendingMachine, "light_caster")

local workplace = {}

workplace.id = "workplace_caster"
workplace.w = 96
workplace.h = 96
workplace.lightColor = color(175, 195, 211, 255)

workplace.lightColor:lerp(0.2, 0, 0, 0, 255)
lightCasters:registerNew(workplace, "light_caster")
