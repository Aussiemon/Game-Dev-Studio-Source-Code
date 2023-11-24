carryObjects = {}
carryObjects.registered = {}
carryObjects.registeredByID = {}

local defaultCarryFuncs = {}

defaultCarryFuncs.mtindex = {
	__index = defaultCarryFuncs
}
defaultCarryFuncs.animation = avatar.ANIM_WALK_CARRY
defaultCarryFuncs.animationFemale = avatar.ANIM_WALK_CARRY_F

function defaultCarryFuncs:onCarry(employee)
end

function defaultCarryFuncs:getWalkAnim(employee)
	if employee:isFemale() then
		return self.animationFemale
	end
	
	return self.animation
end

function defaultCarryFuncs:getFrameOffsets(employee)
	if employee:isFemale() then
		return self.frameOffsetsFemale
	end
	
	return self.frameOffsets
end

carryObjects.zeroZeroOffset = {
	0,
	0
}

function carryObjects.registerNew(data, inherit)
	table.insert(carryObjects.registered, data)
	
	carryObjects.registeredByID[data.id] = data
	
	if inherit then
		setmetatable(data, carryObjects.registeredByID[inherit].mtindex)
	else
		setmetatable(data, defaultCarryFuncs.mtindex)
	end
	
	data.quadObject = quadLoader:load(data.quad)
	data.frameOffsets = data.frameOffsets or {}
	
	local frames, events, images = tdas.getAnimData(avatar.LAYER_COLLECTIONS_BY_ID[data.animation].layers[1])
	
	for key, frame in ipairs(frames) do
		if not data.frameOffsets[key] then
			if data.reuseFirstOffset then
				data.frameOffsets[key] = data.frameOffsets[1]
			else
				data.frameOffsets[key] = data.frameOffsets[key] or carryObjects.zeroZeroOffset
			end
		end
	end
	
	data.mtindex = {
		__index = data
	}
end

function carryObjects.getData(index)
	return carryObjects.registeredByID[index]
end

function carryObjects.getQuad(index)
	return carryObjects.registeredByID[index].quadObject
end

function carryObjects.getDrawables(index)
	local data = carryObjects.registeredByID[index]
	
	return data.quadObject, data.spritebatch
end

function carryObjects:attemptPickOffset(data, offsets, animObj, animName)
	local x, y
	
	if data.animations[animName] then
		local frameID = animObj:getCurFrameID()
		local frameOffset = offsets[frameID]
		local w, h = data.quadObject:getSize()
		
		if frameOffset then
			x, y = w * 0.5 + frameOffset[1], h * 0.5 + frameOffset[2]
		end
	end
	
	return x, y
end

function carryObjects:getWalkAnim(index, employee)
	return carryObjects.registeredByID[index]:getWalkAnim(employee)
end

local femOffsetOne = {
	-8,
	16.5
}
local femOffsetTwo = {
	-7,
	15.5
}

carryObjects.registerNew({
	quad = "coffee_cup",
	id = "coffee_mug",
	spritebatch = "worker_carrying",
	reuseFirstOffset = true,
	animations = {
		[avatar.ANIM_WALK_CARRY] = true,
		[avatar.ANIM_WALK_CARRY_F] = true
	},
	frameOffsets = {
		{
			-9,
			12
		},
		{
			-8,
			11
		},
		{
			-8.5,
			11.5
		},
		{
			-9.5,
			12
		},
		{
			-9.5,
			12
		},
		{
			-9.5,
			12
		},
		{
			-9,
			12.5
		},
		{
			-8.5,
			12
		},
		{
			-9,
			12.5
		},
		{
			-9.5,
			12
		}
	},
	frameOffsetsFemale = {
		femOffsetOne,
		{
			-8,
			17
		},
		femOffsetOne,
		{
			-8.5,
			15.5
		},
		{
			-8.5,
			15.5
		},
		{
			-8.5,
			16
		},
		{
			-8.5,
			16
		},
		{
			-8.5,
			16
		},
		{
			-8.5,
			15
		},
		{
			-8.5,
			15.5
		}
	}
})
