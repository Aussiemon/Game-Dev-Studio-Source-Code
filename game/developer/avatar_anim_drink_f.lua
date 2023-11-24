local hairAnim = avatar.ANIM_DRINK_F .. "_hair"
local hair = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_f_hair"),
	originOffset = {
		0,
		-5.5
	}
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	hair,
	hair,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			-0.5,
			-5.5
		}
	},
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			-0.5,
			-5.5
		}
	},
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			-0.5,
			-5
		}
	},
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			-0.5,
			-5
		}
	},
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			-0.5,
			-5.5
		}
	},
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			-0.5,
			-5.5
		}
	},
	hair,
	hair,
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_DRINK_F .. "_head"
local head = {
	frame = "worker_head",
	quad = quadLoader:load("employee_f_face"),
	originOffset = {
		0,
		-3
	}
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	head,
	head,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			-0.5,
			-3
		}
	},
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			-0.5,
			-3
		}
	},
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			-0.5,
			-2.5
		}
	},
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			-0.5,
			-2.5
		}
	},
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			-0.5,
			-3
		}
	},
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			-0.5,
			-3
		}
	},
	head,
	head,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_DRINK_F .. "_torso"
local torsoOne, torsoTwo, torsoThree, torsoFour, torsoFive, torsoSix = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_drink_torso_1"),
	originOffset = {
		0,
		0
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_drink_torso_2"),
	originOffset = {
		0,
		0
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_drink_torso_3"),
	originOffset = {
		0,
		0
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_drink_torso_4"),
	originOffset = {
		0,
		0
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_drink_torso_5"),
	originOffset = {
		0,
		0
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_drink_torso_6"),
	originOffset = {
		0,
		0
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

local legsAnim = avatar.ANIM_DRINK_F .. "_legs"
local legConfig = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_f_walk_legs_5"),
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

local shoesAnim = avatar.ANIM_DRINK_F .. "_shoes"
local shoesConfig = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_f_walk_shoes_5"),
	originOffset = {
		0,
		0
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

local handsAnim = avatar.ANIM_DRINK_F .. "_hands"
local handOffset = {
	6,
	3
}
local handOne, handTwo, handThree, handFour, handFive, handSix = {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_drink_hands_1"),
	originOffset = {
		1,
		6.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_drink_hands_2"),
	originOffset = {
		3,
		6.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_drink_hands_3"),
	originOffset = {
		4.5,
		6
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_drink_hands_4"),
	originOffset = {
		4.5,
		5.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_drink_hands_5"),
	originOffset = {
		5,
		4.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_drink_hands_6"),
	originOffset = {
		5.5,
		5
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

local cupAnim = avatar.ANIM_DRINK_F .. "_water_cup"

register.newAnimation(cupAnim, {
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_1"),
		originOffset = {
			-8.5,
			10
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_1"),
		originOffset = {
			-4.5,
			10
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_2"),
		originOffset = {
			-2,
			9.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_2"),
		originOffset = {
			-0.5,
			7
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_3"),
		originOffset = {
			-0.5,
			7
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_4"),
		originOffset = {
			-0.5,
			5.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_5"),
		originOffset = {
			-1.5,
			7
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_6"),
		originOffset = {
			-2.5,
			7
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_7"),
		originOffset = {
			-2,
			9.5
		}
	},
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_drink_cup_7"),
		originOffset = {
			-4.5,
			10
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_DRINK_F,
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
