local hairAnim = avatar.ANIM_DRINK_COFFEE .. "_hair"
local hairOne = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_drink_hair_1"),
	originOffset = {
		0,
		-8
	}
}
local hairTwo = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_drink_hair_2"),
	originOffset = {
		0,
		-8
	}
}
local hairThree = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_drink_hair_3"),
	originOffset = {
		0,
		-9
	}
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	hairOne,
	hairOne,
	hairOne,
	hairTwo,
	hairTwo,
	hairThree,
	hairThree,
	hairTwo,
	hairOne,
	hairOne,
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_DRINK_COFFEE .. "_head"
local headOne = {
	frame = "worker_head",
	quad = quadLoader:load("employee_drink_head_1"),
	originOffset = {
		0,
		-7
	}
}
local headTwo = {
	frame = "worker_head",
	quad = quadLoader:load("employee_drink_head_2"),
	originOffset = {
		0,
		-6.5
	}
}
local headThree = {
	frame = "worker_head",
	quad = quadLoader:load("employee_drink_head_3"),
	originOffset = {
		0,
		-7.5
	}
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	headOne,
	headOne,
	headOne,
	headTwo,
	headTwo,
	headThree,
	headThree,
	headTwo,
	headOne,
	headOne,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_DRINK_COFFEE .. "_torso"
local torsoOne, torsoTwo, torsoThree, torsoFour, torsoFive, torsoSix = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_sit_drink_torso_1"),
	originOffset = {
		-0.5,
		-5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_sit_drink_torso_2"),
	originOffset = {
		0,
		-5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_sit_drink_torso_3"),
	originOffset = {
		0,
		-4
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_sit_drink_torso_4"),
	originOffset = {
		0,
		-4.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_sit_drink_torso_5"),
	originOffset = {
		0,
		-5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_sit_drink_torso_5"),
	originOffset = {
		0,
		-5
	}
}

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	torsoOne,
	torsoTwo,
	torsoThree,
	torsoFour,
	torsoFive,
	torsoSix,
	torsoFive,
	torsoFour,
	torsoThree,
	torsoTwo,
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_DRINK_COFFEE .. "_legs"
local legConfig = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_drink_legs"),
	originOffset = {
		0,
		0
	}
}

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	legConfig,
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_DRINK_COFFEE .. "_shoes"
local shoesConfig = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_drink_shoes"),
	originOffset = {
		0,
		3
	}
}

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_DRINK_COFFEE .. "_hands"
local handOffset = {
	6,
	3
}
local handOne, handTwo, handThree, handFour, handFive, handSix = {
	frame = "worker_hands",
	quad = quadLoader:load("employee_sit_drink_hands_1"),
	originOffset = {
		-2,
		4.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_sit_drink_hands_2"),
	originOffset = {
		0.5,
		6.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_sit_drink_hands_3"),
	originOffset = {
		3,
		7
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_sit_drink_hands_4"),
	originOffset = {
		2,
		6.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_sit_drink_hands_5"),
	originOffset = {
		2.5,
		5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_sit_drink_hands_6"),
	originOffset = {
		2.5,
		4.5
	}
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	handOne,
	handTwo,
	handThree,
	handFour,
	handFive,
	handSix,
	handFive,
	handFour,
	handThree,
	handTwo,
	halfOriginOffset = true
})

local cupAnim = avatar.ANIM_DRINK_COFFEE .. "_water_cup"

register.newAnimation(cupAnim, {
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_1"),
		originOffset = {
			-8,
			3.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_1"),
		originOffset = {
			-4,
			5.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_2"),
		originOffset = {
			0,
			5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_2"),
		originOffset = {
			0,
			4.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_3"),
		originOffset = {
			0.5,
			3
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_4"),
		originOffset = {
			0.5,
			2
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_4"),
		originOffset = {
			0.5,
			2
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_6"),
		originOffset = {
			0,
			4.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_7"),
		originOffset = {
			0,
			5.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_7"),
		originOffset = {
			-4,
			5.5
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_DRINK_COFFEE,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim,
		cupAnim
	}
})
