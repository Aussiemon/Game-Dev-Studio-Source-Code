local hairAnim = avatar.ANIM_DRINK_COFFEE_F .. "_hair"
local hair = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_f_hair"),
	originOffset = {
		0,
		-10
	}
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	hair,
	hair,
	hair,
	hair,
	hair,
	hair,
	hair,
	hair,
	hair,
	hair,
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_DRINK_COFFEE_F .. "_head"
local head = {
	frame = "worker_head",
	quad = quadLoader:load("employee_f_face"),
	originOffset = {
		0,
		-7
	}
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	head,
	head,
	head,
	head,
	head,
	head,
	head,
	head,
	head,
	head,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_DRINK_COFFEE_F .. "_torso"
local torsoOne, torsoTwo, torsoThree, torsoFour, torsoFive, torsoSix = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_sit_drink_torso_1"),
	originOffset = {
		0,
		-2
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_sit_drink_torso_2"),
	originOffset = {
		0,
		-2
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_sit_drink_torso_3"),
	originOffset = {
		0,
		-1.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_sit_drink_torso_4"),
	originOffset = {
		0,
		-2
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_sit_drink_torso_5"),
	originOffset = {
		0,
		-2
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_sit_drink_torso_6"),
	originOffset = {
		0,
		-2
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

local legsAnim = avatar.ANIM_DRINK_COFFEE_F .. "_legs"
local legConfig = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_f_sit_legs"),
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

local shoesAnim = avatar.ANIM_DRINK_COFFEE_F .. "_shoes"
local shoesConfig = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_f_sit_shoes"),
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

local handsAnim = avatar.ANIM_DRINK_COFFEE_F .. "_hands"
local handOffset = {
	6,
	3
}
local handOne, handTwo, handThree, handFour, handFive, handSix = {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_sit_drink_hands_1"),
	originOffset = {
		-1,
		8
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_sit_drink_hands_2"),
	originOffset = {
		0,
		9
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_sit_drink_hands_3"),
	originOffset = {
		1.5,
		9
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_sit_drink_hands_4"),
	originOffset = {
		1.5,
		8.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_sit_drink_hands_5"),
	originOffset = {
		1.5,
		7.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_sit_drink_hands_6"),
	originOffset = {
		1.5,
		7.5
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

local cupAnim = avatar.ANIM_DRINK_COFFEE_F .. "_water_cup"

register.newAnimation(cupAnim, {
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_1"),
		originOffset = {
			-6.5,
			7.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_1"),
		originOffset = {
			-3.5,
			8.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_2"),
		originOffset = {
			-1.5,
			8
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_2"),
		originOffset = {
			-0.5,
			5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_sit_drink_cup_3"),
		originOffset = {
			0.5,
			4
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
			4
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_6"),
		originOffset = {
			-0.5,
			5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_7"),
		originOffset = {
			-0.5,
			7.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_7"),
		originOffset = {
			-3.5,
			8.5
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_DRINK_COFFEE_F,
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
