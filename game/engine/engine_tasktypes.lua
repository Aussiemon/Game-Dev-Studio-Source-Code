taskTypes:registerCategoryTitle("projection", _T("ENGINE_PROJECTION_CATEGORY", "Projection"), nil, nil, nil, nil, "category_projection")
taskTypes:registerCategoryTitle("visual_features", _T("ENGINE_VISUAL_FEATURES_CATEGORY", "Visual features"), nil, nil, nil, nil, "category_visual_features")
taskTypes:registerCategoryTitle("audio", _T("ENGINE_AUDIO_CATEGORY", "Audio playback"), nil, nil, nil, nil, "category_audio")
taskTypes:registerCategoryTitle("input", _T("ENGINE_INPUT_CATEGORY", "Input"), nil, nil, nil, nil, "category_input")
taskTypes:registerCategoryTitle("development", _T("ENGINE_DEVELOPMENT_CATEGORY", "Development"), nil, nil, nil, nil, "category_development")
taskTypes:registerCategoryTitle("platform_support", _T("ENGINE_PLATFORM_SUPPORT_CATEGORY", "Platform support"), nil, nil, nil, nil, "category_platform_support")
taskTypes:registerNew({
	workField = "software",
	requiresResearch = false,
	noIssues = true,
	workAmount = 50,
	category = "projection",
	id = "2d_projection",
	taskID = "engine_task",
	minimumLevel = 5,
	display = _T("2D_PROJECTION", "2D Projection"),
	statAffector = {
		id = "performance",
		amount = -1
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	gameQuality = {
		graphics = 5
	}
})
taskTypes:registerNew({
	workField = "software",
	workAmount = 110,
	id = "3d_projection",
	requiresResearch = true,
	noIssues = true,
	licensingAttractiveness = 1.5,
	category = "projection",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 15,
	display = _T("3D_PROJECTION", "3D Projection"),
	statAffector = {
		id = "performance",
		amount = -2
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	releaseDate = {
		year = 1990,
		month = 2
	},
	gameQuality = {
		graphics = 10
	}
})
taskTypes:registerNew({
	workAmount = 100,
	computerLevelRequirement = 3,
	id = "particle_systems",
	noIssues = true,
	licensingAttractiveness = 1.5,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	implementation = "game_particle_effects",
	minimumLevel = 15,
	display = _T("PARTICLE_SYSTEMS", "Particle systems"),
	statAffector = {
		id = "easeOfUse",
		amount = -1
	},
	description = {
		{
			font = "pix20",
			text = _T("PARTICLE_SYSTEMS_DESC_1", "Particle systems allow for rapid creation of complex particle effects.")
		},
		{
			font = "pix20",
			text = _T("PARTICLE_SYSTEMS_DESC_2", "Implementing this feature will increase the Graphics score.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	releaseDate = {
		year = 1997,
		month = 6
	}
})
taskTypes:registerNew({
	computerLevelRequirement = 4,
	id = "supersampling",
	workField = "software",
	requiresResearch = true,
	noIssues = true,
	workAmount = 100,
	category = "visual_features",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 15,
	display = _T("NATIVE_SUPERSAMPLING_SUPPORT", "Native supersampling support"),
	description = {
		{
			font = "pix20",
			text = _T("NATIVE_SUPERSAMPLING_SUPPORT_DESC_1", "Some people are obsessed with good graphics.")
		},
		{
			font = "pix20",
			text = _T("NATIVE_SUPERSAMPLING_SUPPORT_DESC_2", "Adding native supersampling support to an engine will increase the Graphics score by a bit.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	releaseDate = {
		year = 2002,
		month = 3
	},
	gameQuality = {
		graphics = 10
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 2,
	id = "global_illumination",
	workField = "software",
	noIssues = true,
	workAmount = 200,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	computerLevelRequirement = 5,
	category = "visual_features",
	implementation = "game_global_illumination",
	minimumLevel = 65,
	display = _T("REAL_TIME_GLOBAL_ILLUMINATION", "Real-time global illumination"),
	description = {
		{
			font = "pix20",
			text = _T("REAL_TIME_GLOBAL_ILLUMINATION_DESCRIPTION_1", "Simulates rays of light bouncing off surfaces.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -4
	},
	releaseDate = {
		year = 2007,
		month = 3
	},
	gameQuality = {
		graphics = 40
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 2,
	workAmount = 100,
	id = "ambient_occlusion",
	noIssues = true,
	computerLevelRequirement = 5,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	implementation = "game_ambient_occlusion",
	minimumLevel = 40,
	display = _T("AMBIENT_OCCLUSION", "Ambient occlusion"),
	description = {
		{
			font = "pix20",
			text = _T("AMBIENT_OCCLUSION_DESC_1", "Ambient occlusion provides an approximation of indirect lighting.")
		},
		{
			font = "pix20",
			text = _T("AMBIENT_OCCLUSION_DESC_2", "Incorporating this feature will increase the Graphics score by a bit.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -2
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2006,
		month = 5
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	noIssues = true,
	computerLevelRequirement = 2,
	licensingAttractiveness = 1.5,
	workAmount = 100,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "baked_lighting",
	minimumLevel = 25,
	display = _T("BAKED_LIGHTING", "Baked lighting"),
	description = {
		{
			font = "pix20",
			text = _T("BAKED_LIGHTING_DESC_1", "Baked lighting can provide lighting quality similar to global illumination, however it is completely static.")
		},
		{
			font = "pix20",
			text = _T("BAKED_LIGHTING_DESC_2", "Incorporating this feature will increase the Graphics score by a bit.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -1
	},
	releaseDate = {
		year = 1993,
		month = 2
	},
	gameQuality = {
		graphics = 15
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 2,
	workAmount = 100,
	computerLevelRequirement = 5,
	noIssues = true,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "subsurface_scattering",
	minimumLevel = 60,
	display = _T("SUBSURFACE_SCATTERING", "Subsurface scattering"),
	description = {
		{
			font = "pix20",
			text = _T("SUBSURFACE_SCATTERING_DESC_1", "Provides more realistic shading of surfaces that light can penetrate.")
		},
		{
			font = "pix20",
			text = _T("SUBSURFACE_SCATTERING_DESC_2", "Incorporating this feature will increase the Graphics score.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -3
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2007,
		month = 3
	},
	gameQuality = {
		graphics = 25
	}
})
taskTypes:registerNew({
	noIssues = true,
	licensingAttractiveness = 2,
	workField = "software",
	workAmount = 100,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	computerLevelRequirement = 4,
	category = "visual_features",
	id = "shadowmaps",
	minimumLevel = 60,
	display = _T("SHADOWMAPS", "Shadowmaps"),
	description = {
		{
			font = "pix20",
			text = _T("SHADOWMAPS_DESC_1", "Adds shadows that can be cast dynamically from any point in the game world.")
		},
		{
			font = "pix20",
			text = _T("SHADOWMAPS_DESC_2", "Incorporating this feature will increase the Graphics score.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -2
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2003,
		month = 6
	},
	gameQuality = {
		graphics = 25
	}
})
taskTypes:registerNew({
	workAmount = 100,
	computerLevelRequirement = 5,
	noIssues = true,
	licensingAttractiveness = 1.5,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "texture_streaming",
	minimumLevel = 25,
	display = _T("TEXTURE_STREAMING", "Texture streaming"),
	description = {
		{
			font = "pix20",
			text = _T("TEXTURE_STREAMING_DESC_1", "Texture streaming is a very useful feature for reducing video memory usage.")
		},
		{
			font = "pix20",
			text = _T("TEXTURE_STREAMING_DESC_2", "Incorporating this feature will increase sales by a bit.")
		}
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -2.5
	},
	releaseDate = {
		year = 2006,
		month = 5
	},
	gameQuality = {
		graphics = 10
	}
})
taskTypes:registerNew({
	computerLevelRequirement = 3,
	workField = "software",
	requiresResearch = true,
	noIssues = true,
	workAmount = 100,
	category = "visual_features",
	id = "lens_flare",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 15,
	display = _T("LENS_FLARE", "Lens flare"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	statAffector = {
		id = "performance",
		amount = -0.5
	},
	releaseDate = {
		year = 1996,
		month = 3
	},
	gameQuality = {
		graphics = 5
	}
})
taskTypes:registerNew({
	workAmount = 100,
	computerLevelRequirement = 2,
	licensingAttractiveness = 1.5,
	noIssues = true,
	taskID = "engine_task",
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "per_vertex_lighting",
	minimumLevel = 25,
	display = _T("PER_VERTEX_LIGHTING", "Per-vertex lighting"),
	outdatedTechTime = timeline.DAYS_IN_YEAR * 10,
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("PER_VERTEX_LIGHTING_DESC", "A must-have minimum for any 3D game.")
		}
	},
	releaseDate = {
		year = 1991,
		month = 4
	},
	statAffector = {
		id = "performance",
		amount = -1.5
	},
	gameQuality = {
		graphics = 40
	}
})
taskTypes:registerNew({
	computerLevelRequirement = 4,
	workAmount = 100,
	licensingAttractiveness = 2,
	noIssues = true,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "per_pixel_lighting",
	minimumLevel = 25,
	display = _T("PER_PIXEL_LIGHTING", "Per-pixel lighting"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("PER_PIXEL_LIGHTING_DESC", "Unlocks a wide variety of various graphical features for implementation.")
		}
	},
	releaseDate = {
		year = 2000,
		month = 11
	},
	statAffector = {
		id = "performance",
		amount = -3
	},
	gameQuality = {
		graphics = 40
	}
})
taskTypes:registerNew({
	workAmount = 100,
	computerLevelRequirement = 4,
	noIssues = true,
	licensingAttractiveness = 1.5,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "normal_mapping",
	minimumLevel = 30,
	display = _T("NORMAL_MAPPING", "Normal mapping"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("NORMAL_MAPPING_DESC", "Provides a visual effect that can be used to simulate bumps and dents on a surface.")
		}
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2001,
		month = 3
	},
	statAffector = {
		id = "performance",
		amount = -2
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	workAmount = 100,
	computerLevelRequirement = 3,
	noIssues = true,
	licensingAttractiveness = 1.5,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "environment_mapping",
	minimumLevel = 35,
	display = _T("ENVIRONMENT_MAPPING", "Environment mapping"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("ENVIRONMENT_MAPPING_DESC", "Allows to draw pre-rendered reflections onto surfaces that would reflect light in real life.")
		}
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2001,
		month = 10
	},
	statAffector = {
		id = "performance",
		amount = -2
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 1.5,
	workField = "software",
	noIssues = true,
	workAmount = 100,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	computerLevelRequirement = 4,
	category = "visual_features",
	id = "specular_mapping",
	minimumLevel = 40,
	display = _T("SPECULAR_MAPPING", "Specular mapping"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("SPECULAR_MAPPING_DESC", "Offers an effect which simulates specular reflections on a per-surface basis.")
		}
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2002,
		month = 10
	},
	statAffector = {
		id = "performance",
		amount = -2
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 1.5,
	workField = "software",
	noIssues = true,
	workAmount = 100,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	computerLevelRequirement = 4,
	category = "visual_features",
	id = "parallax_mapping",
	minimumLevel = 40,
	display = _T("PARALLAX_MAPPING", "Parallax mapping"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("PARALLAX_MAPPING_DESC", "Provides an illusion of depth for surfaces like brick walls, holes, etc.")
		}
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2004,
		month = 11
	},
	statAffector = {
		id = "performance",
		amount = -3
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 1.5,
	workField = "software",
	noIssues = true,
	workAmount = 100,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	computerLevelRequirement = 4,
	category = "visual_features",
	id = "bloom",
	minimumLevel = 25,
	display = _T("BLOOM", "Bloom"),
	description = {
		{
			font = "pix20",
			text = _T("BLOOM_DESC", "An effect which simulates glowing of very bright surfaces.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2000,
		month = 12
	},
	statAffector = {
		id = "performance",
		amount = -1.5
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	licensingAttractiveness = 1.5,
	workField = "software",
	noIssues = true,
	workAmount = 100,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	computerLevelRequirement = 4,
	category = "visual_features",
	id = "depth_of_field",
	minimumLevel = 30,
	display = _T("DEPTH_OF_FIELD", "Depth of Field"),
	description = {
		{
			font = "pix20",
			text = _T("DEPTH_OF_FIELD_DESC", "An effect which simulates out-of-focus blurring.")
		}
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	requirements = {
		per_pixel_lighting = true
	},
	releaseDate = {
		year = 2001,
		month = 1
	},
	statAffector = {
		id = "performance",
		amount = -2
	},
	gameQuality = {
		graphics = 20
	}
})
taskTypes:registerNew({
	implementation = "game_virtual_reality",
	computerLevelRequirement = 3,
	workAmount = 50,
	noIssues = true,
	licensingAttractiveness = 2,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	category = "visual_features",
	id = "virtual_reality",
	minimumLevel = 30,
	display = _T("VIRTUAL_REALITY_HEADSETS", "Virtual reality headsets"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("VIRTUAL_REALITY_HEADSETS_DESC_1", "VR headsets allow for a much more immersive gameplay experience.")
		}
	},
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	releaseDate = {
		year = 1995,
		month = 7
	},
	gameQuality = {
		graphics = 15
	}
})
taskTypes:registerNew({
	computerLevelRequirement = 3,
	workField = "software",
	noIssues = true,
	workAmount = 100,
	category = "visual_features",
	id = "multi_monitor",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 20,
	display = _T("NATIVE_MULTI_MONITOR_SUPPORT", "Native multi-monitor support"),
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	releaseDate = {
		year = 2000,
		month = 3
	},
	gameQuality = {
		graphics = 10
	}
})
taskTypes:registerNew({
	workField = "software",
	id = "single_channel_audio",
	noIssues = true,
	optionCategory = "audio_channels",
	workAmount = 50,
	category = "audio",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 10,
	display = _T("SINGLE_CHANNEL_AUDIO", "Single-channel audio"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	statAffector = {
		id = "easeOfUse",
		amount = -1
	},
	gameQuality = {
		sound = 10
	}
})
taskTypes:registerNew({
	workField = "software",
	workAmount = 100,
	id = "double_channel_audio",
	noIssues = true,
	optionCategory = "audio_channels",
	requiresResearch = true,
	licensingAttractiveness = 2,
	category = "audio",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 20,
	display = _T("DUAL_CHANNEL_AUDIO", "Dual-channel audio"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	releaseDate = {
		year = 1988,
		month = 4
	},
	gameQuality = {
		sound = 20
	}
})
taskTypes:registerNew({
	workField = "software",
	workAmount = 150,
	id = "multi_channel_audio",
	noIssues = true,
	optionCategory = "audio_channels",
	requiresResearch = true,
	licensingAttractiveness = 3,
	category = "audio",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 30,
	display = _T("MULTI_CHANNEL_AUDIO", "Multi-channel audio"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	statAffector = {
		id = "easeOfUse",
		amount = -3
	},
	releaseDate = {
		year = 1992,
		month = 7
	},
	gameQuality = {
		sound = 30
	}
})
taskTypes:registerNew({
	workField = "software",
	workAmount = 100,
	id = "hdr_audio",
	noIssues = true,
	requiresResearch = true,
	licensingAttractiveness = 1.5,
	category = "audio",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 20,
	display = _T("HDR_AUDIO", "HDR audio"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	description = {
		{
			font = "pix20",
			text = _T("HDR_AUDIO_1", "A system which simulates sound loudness.")
		}
	},
	releaseDate = {
		year = 1996,
		month = 3
	},
	gameQuality = {
		sound = 15
	}
})
taskTypes:registerNew({
	workField = "software",
	workAmount = 100,
	id = "dynamic_music_system",
	noIssues = true,
	licensingAttractiveness = 1.5,
	category = "audio",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 20,
	display = _T("DYNAMIC_MUSIC_SYSTEM", "Dynamic music system"),
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	description = {
		{
			font = "pix20",
			text = _T("DYNAMIC_MUSIC_SYSTEM_DESC_1", "A system which allows for playback of specific music tracks in specific situations.")
		}
	},
	gameQuality = {
		sound = 5
	}
})
taskTypes:registerNew({
	workField = "software",
	id = "gamepad",
	licensingAttractiveness = 1.5,
	requiresResearch = true,
	workAmount = 50,
	noIssues = true,
	category = "input",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 10,
	display = _T("GAMEPAD_SUPPORT", "Gamepad support"),
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	releaseDate = {
		year = 1991,
		month = 5
	},
	description = {
		{
			font = "pix20",
			text = _T("GAMEPAD_SUPPORT_DESC_1", "Gamepad support is a necessity for any multi-platform engine.")
		},
		{
			font = "pix20",
			text = _T("GAMEPAD_SUPPORT_DESC_2", "Additionally, will slightly boost sales on the PC market.")
		}
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	noIssues = true,
	licensingAttractiveness = 1.5,
	penalty = 0.025,
	workAmount = 50,
	taskID = "engine_task",
	neverOutdated = true,
	penaltyYear = 2001,
	workField = "software",
	fact = "joystick_importance_revealed_for",
	category = "input",
	id = "joystick",
	minimumLevel = 10,
	display = _T("JOYSTICK_SUPPORT", "Joystick support"),
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	releaseDate = {
		year = 1997,
		month = 5
	},
	gameQuality = {
		gameplay = 10
	},
	applicableGenrePenalty = {
		simulation = {
			military = true
		}
	},
	penaltyText = {
		simulation = {
			military = _T("MILSIM_NO_JOYSTICK_REMARK", "having joystick support for a military simulation game seems like a no-brainer... unfortunately this game does not have it")
		}
	},
	shouldApplyPenalty = function(self, projectObject)
		if timeline:getYear(projectObject:getReleaseDate()) < self.penaltyYear then
			return false
		end
		
		local genre, theme = projectObject:getGenre(), projectObject:getTheme()
		
		return self.applicableGenrePenalty[genre] and self.applicableGenrePenalty[genre][theme]
	end,
	absenseCheck = function(self, projectObject, reviewObject)
		return self:shouldApplyPenalty(projectObject)
	end,
	absenseScoreAdjust = function(self, projectObject, curScore)
		if self:shouldApplyPenalty(projectObject) then
			curScore = curScore - self.penalty
		end
		
		return curScore
	end,
	getAbsenseText = function(self, gameProj)
		local revealedGenres = studio:getFact(self.fact) or {}
		local genre, theme = gameProj:getGenre(), gameProj:getTheme()
		
		revealedGenres[genre] = revealedGenres[genre] or {}
		revealedGenres[genre][theme] = true
		
		studio:setFact(self.fact, revealedGenres)
		
		return self.penaltyText[genre][theme]
	end,
	setupDescbox = function(self, descbox, wrapWidth, projectObj)
		if studio:isFeatureRevealed(self.id) then
			descbox:addSpaceToNextText(4)
			
			local revealedGenres = studio:getFact(self.fact)
			
			descbox:addText(_T("JOYSTICK_PENALTY_NOTICE", "Must-have for:"), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
			
			for genre, list in pairs(revealedGenres) do
				local genreName = genres.registeredByID[genre].display
				
				for theme, subList in pairs(list) do
					descbox:addText(_format(_T("THEME_GENRE_GAMES_WITH_TAB", "\tTHEME GENRE games"), "THEME", themes.registeredByID[theme].display, "GENRE", genreName), "bh20", nil, 0, wrapWidth)
				end
			end
			
			descbox:addSpaceToNextText(5)
		end
	end
})
taskTypes:registerNew({
	workAmount = 50,
	noIssues = true,
	licensingAttractiveness = 1.5,
	taskID = "engine_task",
	neverOutdated = true,
	requiresResearch = true,
	workField = "software",
	fact = "revealed_importance_for_racing_wheel",
	category = "input",
	id = "racing_wheel",
	minimumLevel = 10,
	statAffector = {
		id = "easeOfUse",
		amount = -2
	},
	display = _T("RACING_WHEEL_SUPPORT", "Racing wheel support"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	releaseDate = {
		year = 1990,
		month = 4
	},
	description = {
		{
			font = "pix20",
			text = _T("RACING_WHEEL_SUPPORT_DESC", "Supporting racing wheels will increase sales on all markets when making racing games.")
		}
	},
	gameQuality = {
		gameplay = 10
	},
	gameQuality = {
		gameplay = 10
	},
	applicableGenrePenalty = {
		simulation = {
			military = true
		}
	},
	penaltyText = {
		simulation = {
			military = _T("MILSIM_NO_RACINGWHEEL_PENALTY_TEXT", "while racing wheel support is not needed in a military simulation game, it would have been nice to have it"),
			racing = _T("RACINGSIM_NO_RACINGWHEEL_PENALTY_TEXT", "a racing simulation game with no racing wheel support is like a military simulation game with no guns")
		}
	},
	penaltySize = {
		simulation = {
			racing = 0.075,
			military = 0.01
		}
	},
	penaltyYear = {
		simulation = {
			racing = 1994,
			military = 2003
		}
	},
	shouldApplyPenalty = function(self, projectObject)
		local genre, theme = projectObject:getGenre(), projectObject:getTheme()
		
		if not self.penaltyYear[genre] or not self.penaltyYear[genre][theme] or timeline:getYear() < self.penaltyYear[genre][theme] then
			return false
		end
		
		return self.applicableGenrePenalty[genre][theme]
	end,
	absenseScoreAdjust = function(self, projectObject, curScore)
		if self:shouldApplyPenalty(projectObject) then
			curScore = curScore - self.penaltySize[projectObject:getGenre()][projectObject:getTheme()]
		end
		
		return curScore
	end
}, nil, "joystick")
taskTypes:registerNew({
	workField = "software",
	id = "sdk",
	licensingAttractiveness = 1.5,
	noIssues = true,
	devSpeedMultiplier = 0.15,
	workAmount = 150,
	category = "development",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 20,
	display = _T("SOFTWARE_DEVELOPMENT_KIT", "Software development kit"),
	statAffector = {
		id = "integrity",
		amount = -2
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	releaseDate = {
		year = 1993,
		month = 3
	},
	description = {
		{
			font = "pix20",
			text = _T("SDK_DESCRIPTION_1", "Increases game development speed by 15%")
		}
	}
})
taskTypes:registerNew({
	workField = "software",
	id = "cross_platform_support",
	licensingAttractiveness = 2,
	noIssues = true,
	workAmount = 200,
	category = "development",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 25,
	display = _T("CROSS_PLATFORM_SUPPORT", "Cross-platform support"),
	statAffector = {
		id = "integrity",
		amount = -5
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	releaseDate = {
		year = 1991,
		month = 2
	},
	description = {
		{
			font = "pix20",
			text = _T("CROSS_PLATFORM_SUPPORT_DESC", "Allows for development of a single game on more than 2 platforms.")
		}
	}
})
