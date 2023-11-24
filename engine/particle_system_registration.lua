particleSystem = {}
particleSystem.RENDER_ORDER = {
	fore = 3,
	back = 1,
	mid = 2
}
particleSystem.defaultParticleLimit = 100
particleSystem.cachedEmitters = {}
particleSystem.defaultPriority = 5
registered.particleSystems = {}

local baseParticleSystem = {}

baseParticleSystem.forceRemove = nil
baseParticleSystem.removeOnOver = nil
baseParticleSystem.particleLimit = particleSystem.defaultParticleLimit
baseParticleSystem.startOnCreation = nil
baseParticleSystem.PARTICLESYSTEM = true

function baseParticleSystem:setPosition(x, y)
	self.particleSystem:setPosition(x, y)
end

function baseParticleSystem:setupParticleSystem()
	if self.particleEffect then
		self.particleData = particleEffects:getData(self.particleEffect)
		
		self.particleData:applyTo(self.particleSystem)
	end
end

function baseParticleSystem:initFunc()
end

function baseParticleSystem:emitSprites(amt, stopAfterEmitting)
	amt = amt or 1
	
	self.particleSystem:emit(amt)
	
	if stopAfterEmitting then
		self.particleSystem:stop()
	end
end

function baseParticleSystem:draw()
	self.particleSystem:update(frameTime)
	love.graphics.draw(self.particleSystem, 0, 0, 0, 1, 1, 15, 15)
end

function baseParticleSystem:logicFunc(deltaTime)
end

function baseParticleSystem:removeCheckFunc()
	return nil
end

baseParticleSystem.emit = baseParticleSystem.emitSprites
baseParticleSystem.mtindex = {
	__index = baseParticleSystem
}

function particleSystem.register(tbl)
	setmetatable(tbl, baseParticleSystem.mtindex)
	
	if tbl.removeOnOver == nil then
		tbl.removeOnOver = true
	end
	
	if tbl.startOnCreation == nil then
		tbl.startOnCreation = true
	end
	
	if not tbl.lifetime then
		tbl.lifetime = 1
	end
	
	if not tbl.texture and tbl.particleEffect then
		local effectData = particleEffects:getData(tbl.particleEffect)
		
		if effectData.texture then
			tbl.texture = cache.getImage(effectData.texture)
		elseif effectData.textures then
			tbl.texture = cache.getImage(effectData.textures[1])
		end
	end
	
	tbl.mtindex = {
		__index = tbl
	}
	registered.particleSystems[tbl.name] = tbl
end

function particleSystem.getParticleSystem(name)
	return registered.particleSystems[name]
end

function particleSystem.instantiate(name, priority)
	local targetSystem = registered.particleSystems[name]
	
	if not targetSystem then
		return nil
	end
	
	local newParticleSystem = particleSystem.prepareParticleSystem(targetSystem)
	
	table.insert(particleSystem.manager.particleSystems, newParticleSystem)
	priorityRenderer:add(newParticleSystem, priority or particleSystem.defaultPriority)
	
	return newParticleSystem
end

function particleSystem.prepareParticleSystem(targetSystem)
	if type(targetSystem) == "string" then
		targetSystem = particleSystem.getParticleSystem(targetSystem)
	end
	
	local newParticleSystem = {}
	
	setmetatable(newParticleSystem, targetSystem.mtindex)
	particleSystem.initializeEmitter(newParticleSystem, targetSystem)
	
	return newParticleSystem
end

function particleSystem.initializeEmitter(system, targetSystem)
	system.particleSystem = particleSystem.getEmitter(system, targetSystem)
	
	system:setupParticleSystem()
	system:initFunc()
	
	if system.startOnCreation then
		system.particleSystem:start()
	end
end

function particleSystem.getEmitter(system, targetSystem)
	local targetTable = particleSystem.cachedEmitters[targetSystem.name]
	local desiredEmitter
	
	if targetTable then
		local emitter = targetTable[1]
		
		if emitter then
			table.remove(targetTable, 1)
			emitter:reset()
			
			desiredEmitter = emitter
		end
	end
	
	desiredEmitter = desiredEmitter or love.graphics.newParticleSystem(targetSystem.texture, targetSystem.particleLimit)
	
	desiredEmitter:setEmitterLifetime(system.lifetime)
	
	return desiredEmitter
end

require("engine/particle_system_manager")
