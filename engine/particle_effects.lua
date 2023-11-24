particleEffects = {}
particleEffects.registered = {}
particleEffects.registeredByID = {}
particleEffects.DEFAULT_MAX_BUFFER_SIZE = 20
particleEffects.DEFAULT_AREA_SPREAD = "normal"
particleEffects.FILE_FORMAT = ".gdspfx"

local baseParticleEffectFuncs = {}

baseParticleEffectFuncs.mtindex = {
	__index = baseParticleEffectFuncs
}

function baseParticleEffectFuncs:applyTo(particleSystem, editor)
	particleSystem:setBufferSize(self.bufferSize or particleEffects.DEFAULT_MAX_BUFFER_SIZE)
	particleSystem:setSpinVariation(self.spinVariation or 0)
	particleSystem:setInsertMode(self.insertMode or "normal")
	particleSystem:setAreaSpread(particleEffects.DEFAULT_AREA_SPREAD, self.spread[1], self.spread[2])
	
	if self.textures then
		particleSystem:setTexture(cache.getImage(self.textures[math.random(1, #self.textures)]))
	else
		particleSystem:setTexture(cache.getImage(self.texture))
	end
	
	if self.quads then
		if self.randomQuad and not editor then
			particleSystem:setQuads(self.quadObjects[math.random(1, #self.quadObjects)])
		else
			particleSystem:setQuads(self.quadObjects)
		end
	end
	
	if self.spin then
		particleSystem:setSpin(math.rad(self.spin[1]), math.rad(self.spin[2]))
	end
	
	if self.linearDamping then
		particleSystem:setLinearDamping(self.linearDamping[1], self.linearDamping[2])
	end
	
	if self.tangentialAcceleration then
		particleSystem:setTangentialAcceleration(self.tangentialAcceleration[1], self.tangentialAcceleration[2])
	end
	
	if self.emitterLifetime then
		particleSystem:setEmitterLifetime(self.emitterLifetime)
	end
	
	if self.linearAcceleration then
		local acc = self.linearAcceleration
		
		particleSystem:setLinearAcceleration(acc[1], acc[2], acc[3], acc[4])
	end
	
	if self.emissionRate then
		particleSystem:setEmissionRate(self.emissionRate)
	end
	
	if self.speed then
		particleSystem:setSpeed(self.speed[1], self.speed[2])
	end
	
	if self.particleLifetime then
		if type(self.particleLifetime) == "table" then
			particleSystem:setParticleLifetime(math.randomf(self.particleLifetime[1], self.particleLifetime[2]))
		else
			particleSystem:setParticleLifetime(self.particleLifetime)
		end
	end
	
	if self.sizes then
		particleSystem:setSizes(unpack(self.sizes))
	end
	
	if self.colors then
		local clr = self.colors
		
		particleSystem:setColors(clr[1], clr[2], clr[3], clr[4], clr[1], clr[2], clr[3], 0)
	end
	
	if self.radialAcceleration then
		particleSystem:setRadialAcceleration(self.radialAcceleration[1], self.radialAcceleration[2])
	end
	
	if self.rotation then
		particleSystem:setRotation(self.rotation[1], self.rotation[2])
	end
end

function particleEffects:registerNew(data, inherit)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		data.baseClass = self.registeredByID[inherit]
		
		setmetatable(data, data.baseClass.mtindex)
	else
		data.baseClass = baseParticleEffectFuncs
		
		setmetatable(data, baseParticleEffectFuncs.mtindex)
	end
	
	if data.quads then
		data.quadObjects = {}
		
		for key, quad in ipairs(data.quads) do
			data.quadObjects[#data.quadObjects + 1] = quadLoader:load(quad)
		end
	end
end

function particleEffects:registerFromFile(filePath)
	local data = json.decodeFile(filePath)
	
	data.id, data.name = data.name
	
	self:removeData(data.id)
	self:registerNew(data)
	
	return particleEffects.registeredByID[data.id], data
end

function particleEffects:getData(id)
	return self.registeredByID[id]
end

function particleEffects:removeData(effectID)
	for key, data in ipairs(self.registered) do
		if data.id == effectID then
			table.remove(self.registered, key)
			
			break
		end
	end
	
	self.registeredByID[effectID] = nil
end
