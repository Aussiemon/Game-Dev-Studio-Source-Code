particleSystem.manager = {}
particleSystem.manager.renderOrder = {
	[particleSystem.RENDER_ORDER.back] = {},
	[particleSystem.RENDER_ORDER.mid] = {},
	[particleSystem.RENDER_ORDER.fore] = {}
}
particleSystem.manager.particleSystems = {}

function particleSystem.manager:update(dt)
	local realIndex = 1
	
	for i = 1, #self.particleSystems do
		local data = self.particleSystems[realIndex]
		
		if self:shouldBeRemoved(data) then
			self:cacheParticleSystem(data)
			table.remove(self.particleSystems, realIndex)
		else
			realIndex = realIndex + 1
			
			data:logicFunc(dt)
		end
	end
end

function particleSystem.manager:shouldBeRemoved(data)
	if data.forceRemove then
		return true
	end
	
	if data.removeOnOver and not data.particleSystem:isActive() and data.particleSystem:getCount() == 0 then
		return true
	end
	
	if data.removeCheckFunc and data:removeCheckFunc() then
		return true
	end
	
	return false
end

function particleSystem.manager:cacheParticleSystem(data)
	if not particleSystem.cachedEmitters[data.name] then
		particleSystem.cachedEmitters[data.name] = {}
	end
	
	table.insert(particleSystem.cachedEmitters[data.name], data.particleSystem)
	priorityRenderer:remove(data)
end
