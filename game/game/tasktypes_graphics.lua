taskTypes:registerCategoryTitle("game_graphics", _T("GRAPHICS", "Graphics"), nil, nil, nil, nil, "category_graphics")

local realisticGraphics = {}

realisticGraphics.id = "realistic_graphics"
realisticGraphics.optionCategory = "graphics_type"
realisticGraphics.mmoContent = 2
realisticGraphics.category = "game_graphics"
realisticGraphics.multipleEmployees = true
realisticGraphics.platformWorkAffector = 0.1
realisticGraphics.taskID = "game_task"
realisticGraphics.display = _T("REALISTIC_GRAPHICS", "Realistic graphics")
realisticGraphics.workAmount = 100
realisticGraphics.gameQuality = {
	graphics = 50
}
realisticGraphics.workField = "graphics"
realisticGraphics.qualityContribution = "graphics"
realisticGraphics.issues = {
	"p2"
}
realisticGraphics.stage = 2
realisticGraphics.optionalForStandard = false
realisticGraphics.specBoost = {
	id = "organic_art",
	boost = 1.15
}
realisticGraphics.directKnowledgeContribution = {
	multiplier = 0.0005,
	knowledge = "photography"
}

taskTypes:registerNew(realisticGraphics)

local stylizedGraphics = {}

stylizedGraphics.id = "stylized_graphics"
stylizedGraphics.mmoContent = 2
stylizedGraphics.optionCategory = "graphics_type"
stylizedGraphics.category = "game_graphics"
stylizedGraphics.multipleEmployees = true
stylizedGraphics.platformWorkAffector = 0.1
stylizedGraphics.taskID = "game_task"
stylizedGraphics.display = _T("STYLIZED_GRAPHICS", "Stylized graphics")
stylizedGraphics.workAmount = 100
stylizedGraphics.gameQuality = {
	graphics = 50
}
stylizedGraphics.workField = "graphics"
stylizedGraphics.qualityContribution = "graphics"
stylizedGraphics.issues = {
	"p2"
}
stylizedGraphics.stage = 2
stylizedGraphics.optionalForStandard = false
stylizedGraphics.specBoost = {
	id = "stylized_art",
	boost = 1.15
}
stylizedGraphics.directKnowledgeContribution = {
	multiplier = 0.0005,
	knowledge = "stylizing"
}

taskTypes:registerNew(stylizedGraphics)

local globalIllum = {}

globalIllum.id = "game_global_illumination"
globalIllum.mmoContent = 2
globalIllum.category = "game_graphics"
globalIllum.platformWorkAffector = 0.15
globalIllum.multipleEmployees = true
globalIllum.workAmount = 60
globalIllum.requiresImplementation = true
globalIllum.workField = "software"
globalIllum.minimumLevel = 50
globalIllum.noIssues = true
globalIllum.qualityContribution = "graphics"
globalIllum.taskID = "game_task"
globalIllum.stage = 2
globalIllum.gameQuality = {
	graphics = 30
}
globalIllum.realGameQuality = {}
globalIllum.directKnowledgeContribution = {
	multiplier = 0.001,
	knowledge = "photography"
}
globalIllum.maxScoreIncreaseDate = {
	year = 2018,
	month = 3
}

function globalIllum:getGameQualityPointIncrease(projectObject, time)
	local dateTime = timeline:getDateTime(self.maxScoreIncreaseDate.year, self.maxScoreIncreaseDate.month)
	
	time = time or timeline.curTime
	
	if dateTime <= time then
		self.realGameQuality.graphics = self.gameQuality.graphics
	else
		self.realGameQuality.graphics = 10
	end
	
	return self.realGameQuality
end

taskTypes:registerNew(globalIllum, "global_illumination")

local ambientOccl = {}

ambientOccl.id = "game_ambient_occlusion"
ambientOccl.mmoContent = 2
ambientOccl.category = "game_graphics"
ambientOccl.platformWorkAffector = 0.2
ambientOccl.multipleEmployees = true
ambientOccl.workAmount = 50
ambientOccl.requiresImplementation = true
ambientOccl.workField = "software"
ambientOccl.minimumLevel = 30
ambientOccl.noIssues = true
ambientOccl.qualityContribution = "graphics"
ambientOccl.taskID = "game_task"
ambientOccl.stage = 2
ambientOccl.gameQuality = {
	graphics = 25
}
ambientOccl.directKnowledgeContribution = {
	multiplier = 0.001,
	knowledge = "photography"
}

taskTypes:registerNew(ambientOccl, "ambient_occlusion")

local particleEffects = {}

particleEffects.id = "game_particle_effects"
particleEffects.mmoContent = 2
particleEffects.platformWorkAffector = 0.15
particleEffects.display = _T("PARTICLE_EFFECTS", "Particle effects")
particleEffects.description = {
	{
		font = "pix20",
		text = _T("PARTICLE_EFFECTS_DESC1", "Develop and add various advanced particle effects.")
	},
	{
		font = "pix20",
		text = _T("PARTICLE_EFFECTS_DESC2", "Implementing this feature will increase graphics score.")
	}
}
particleEffects.category = "game_graphics"
particleEffects.workAmount = 50
particleEffects.requiresImplementation = true
particleEffects.workField = "software"
particleEffects.minimumLevel = 20
particleEffects.noIssues = true
particleEffects.qualityContribution = "graphics"
particleEffects.taskID = "game_task"
particleEffects.stage = 2
particleEffects.gameQuality = {
	graphics = 25
}
particleEffects.directKnowledgeContribution = {
	multiplier = 0.001,
	knowledge = "photography"
}

taskTypes:registerNew(particleEffects)

local mocap = {
	taskID = "game_task",
	multipleEmployees = true,
	mmoContent = 2,
	workAmount = 60,
	noIssues = true,
	stage = 2,
	requiresResearch = true,
	cost = 5000,
	workField = "software",
	optionCategory = "mocap_type",
	qualityContribution = "graphics",
	category = "game_graphics",
	id = "mocap",
	minimumLevel = 30,
	display = _T("MOTION_CAPTURED_ANIMATIONS", "Motion-capture animations"),
	description = {
		{
			font = "pix20",
			text = _T("MOTION_CAPTURED_ANIMATIONS_DESC1", "Capture animations with the help of actors for use in gameplay and during cutscenes.")
		}
	},
	releaseDate = {
		year = 1995,
		month = 3
	},
	gameQuality = {
		graphics = 30
	},
	knowledgeContribution = {
		action = {
			military = {
				{
					id = "firearms",
					amount = 0.0015
				},
				{
					id = "fighting",
					amount = 0.0005
				}
			},
			undercover = {
				{
					id = "fighting",
					amount = 0.001
				}
			},
			government = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			scifi = {
				{
					id = "firearms",
					amount = 0.002
				}
			}
		},
		fighting = {
			military = {
				{
					id = "fighting",
					amount = 0.002
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			undercover = {
				{
					id = "stealth",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			government = {
				{
					id = "fighting",
					amount = 0.002
				}
			},
			scifi = {
				{
					id = "fighting",
					amount = 0.002
				}
			},
			bizarre = {
				{
					id = "fighting",
					amount = 0.002
				}
			}
		},
		adventure = {
			undercover = {
				{
					id = "stealth",
					amount = 0.002
				}
			}
		},
		simulation = {
			military = {
				{
					id = "firearms",
					amount = 0.0015
				},
				{
					id = "fighting",
					amount = 0.0005
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			}
		},
		strategy = {
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			}
		},
		rpg = {
			military = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			}
		}
	}
}

mocap.maxScaleBeforePenalty = 10
mocap.maxPenaltyAtScale = 16
mocap.maxPenalty = 0.1
mocap.skipPenalty = {
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true
}

function mocap:getCost(cost, projectObj)
	return mocap.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

function mocap:shouldApplyPenalty(projectObject)
	return not self.skipPenalty[projectObject:getGameType()] and projectObject:getScale() > self.maxScaleBeforePenalty
end

function mocap:absenseCheck(projectObject, reviewObject)
	return self:shouldApplyPenalty(projectObject)
end

function mocap:getPenalty(scale)
	return math.lerp(0, self.maxPenalty, math.min(1, (scale - self.maxScaleBeforePenalty) / (scale - self.maxScaleBeforePenalty)))
end

function mocap:absenseScoreAdjust(projectObject, curScore)
	if self:shouldApplyPenalty(projectObject) then
		local scale = projectObject:getScale()
		
		curScore = curScore - self:getPenalty(scale)
	end
	
	return curScore
end

function mocap:getAbsenseText(gameProj)
	local penalty = self:getPenalty(gameProj:getScale())
	
	if penalty == self.maxPenalty then
		return _T("MOCAP_ABSENT_REMARK_MAX", "it doesn't matter how good your animators are, some animations are better off motion-captured, which this game does not have")
	elseif penalty >= self.maxPenalty * 0.6 then
		return _T("MOCAP_ABSENT_REMARK_HIGH", "some animations really broke immersion, and we think the absense of motion-capture animations is to blame")
	end
	
	return _T("MOCAP_ABSENT_REMARK_LOW", "some of the animations were a bit clunky, we think motion-capture would have been a welcome addition")
end

function mocap:setupDescbox(descbox, wrapWidth, projectObj)
	if studio:isFeatureRevealed(self.id) then
		descbox:addSpaceToNextText(4)
		descbox:addText(_format(_T("MOCAP_PENALTY_NOTICE", "Must-have for projects with a project scale of xSCALE"), "SCALE", self.maxScaleBeforePenalty), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	end
end

taskTypes:registerNew(mocap)
