noise = {}
registered.noiseTemplates = {}

function noise.createTemplate(targetTemplate)
	local newTemplate = {}
	
	setmetatable(newTemplate, {
		__index = noise
	})
	
	local template = registered.noiseTemplates[targetTemplate]
	
	for key, value in pairs(template) do
		newTemplate[key] = value
	end
	
	return newTemplate
end

function noise:setTargetTemplate(targetTemplate)
	self.targetTemplate = registered.noiseTemplates[targetTemplate]
end

function noise:attemptPickBlock(height)
	if self.targetTemplate then
		if self.targetTemplate.blockPicker then
			return self.targetTemplate:blockPicker(height)
		end
		
		return nil
	end
	
	if self.blockPicker then
		return self:blockPicker(height)
	end
	
	return nil
end

function noise:setElevation(min, max)
	self.minElevation = min
	self.maxElevation = max
end

function noise:approachTemplate()
	local template = self.targetTemplate
	
	if not template then
		return 
	end
	
	self.iterations = math.approach(self.iterations, template.iterations, 1)
	self.persistence = math.approach(self.persistence, template.persistence, 0.01)
	self.scale = math.approach(self.scale, template.scale, 0.001)
	self.low = math.approach(self.low, template.low * self.minElevation, 1)
	self.high = math.approach(self.high, template.high * self.maxElevation, 1)
	self.horizontal = math.approach(self.horizontal, template.horizontal, 0.01)
	self.vertical = math.approach(self.vertical, template.vertical, 0.01)
end

function register.noiseTemplate(noise)
	registered.noiseTemplates[noise.name] = noise
end

register.noiseTemplate({
	iterations = 4,
	name = "PLAINS",
	low = 40,
	horizontal = 1,
	high = 70,
	persistence = 0.5,
	scale = 0.007,
	vertical = 1
})
register.noiseTemplate({
	iterations = 6,
	name = "FOREST",
	low = 20,
	horizontal = 1,
	high = 80,
	persistence = 0.55,
	scale = 0.007,
	vertical = 1
})
register.noiseTemplate({
	iterations = 5,
	name = "SWAMPS",
	low = 40,
	horizontal = 1,
	high = 60,
	persistence = 0.5,
	scale = 0.007,
	vertical = 1
})
register.noiseTemplate({
	iterations = 5,
	name = "MOUNTAINS",
	low = 0,
	horizontal = 1,
	high = 90,
	persistence = 0.5,
	scale = 0.007,
	vertical = 1
})
register.noiseTemplate({
	iterations = 4,
	name = "LOWLANDS",
	low = 50,
	horizontal = 1,
	high = 100,
	persistence = 0.5,
	scale = 0.007,
	vertical = 1
})
register.noiseTemplate({
	iterations = 5,
	name = "SAND_IN_LOWLANDS",
	low = 0,
	horizontal = 1.5,
	high = 255,
	persistence = 0.65,
	scale = 0.01,
	vertical = 1
})
register.noiseTemplate({
	iterations = 5,
	name = "FOREST_HOLLOW_GROUNDS",
	low = 0,
	horizontal = 1,
	high = 100,
	persistence = 0.5,
	scale = 0.03,
	vertical = 1
})
register.noiseTemplate({
	iterations = 5,
	name = "CLAY_IN_SWAMPS",
	low = 0,
	horizontal = 1,
	high = 255,
	persistence = 0.6,
	scale = 0.1,
	vertical = 1
})
register.noiseTemplate({
	iterations = 5,
	name = "UNDERGROUND_WATER",
	low = 0,
	horizontal = 1,
	high = 255,
	persistence = 0.6,
	scale = 0.15,
	vertical = 1
})
register.noiseTemplate({
	iterations = 4,
	name = "PASSAGE_INTO_CAVES",
	low = 0,
	horizontal = 1,
	high = 360,
	persistence = 0.5,
	scale = 0.15,
	vertical = 1
})
