particleEffects:registerFromFile("particle_effects/interaction_smoke" .. particleEffects.FILE_FORMAT)
particleEffects:registerFromFile("particle_effects/object_placement_dust" .. particleEffects.FILE_FORMAT)
particleSystem.register({
	particleEffect = "interaction_smoke",
	name = "interaction_smoke"
})
particleSystem.register({
	particleEffect = "object_placement_dust",
	name = "object_placement_dust"
})
