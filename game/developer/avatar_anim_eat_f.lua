local hairAnim = avatar.ANIM_EAT_F .. "_hair"
local hair = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_f_hair"),
	originOffset = {
		0,
		-10.5
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

local headAnim = avatar.ANIM_EAT_F .. "_head"
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

local torsoAnim = avatar.ANIM_EAT_F .. "_torso"
local torsoOne, torsoTwo, torsoThree, torsoFour, torsoFive, torsoSix = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_eat_torso_1"),
	originOffset = {
		0,
		-5.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_eat_torso_2"),
	originOffset = {
		0,
		-5.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_eat_torso_3"),
	originOffset = {
		0,
		-4
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_eat_torso_4"),
	originOffset = {
		0.5,
		-3.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_eat_torso_5"),
	originOffset = {
		0.5,
		-4
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_f_eat_torso_6"),
	originOffset = {
		0.5,
		-4.5
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

local legsAnim = avatar.ANIM_EAT_F .. "_legs"
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

local shoesAnim = avatar.ANIM_EAT_F .. "_shoes"
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

local handsAnim = avatar.ANIM_EAT_F .. "_hands"
local handOffset = {
	6,
	3
}
local handOne, handTwo, handThree, handFour, handFive, handSix = {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_eat_hands_1"),
	originOffset = {
		0,
		-1
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_eat_hands_2"),
	originOffset = {
		0.5,
		0.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_eat_hands_3"),
	originOffset = {
		2,
		2
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_eat_hands_4"),
	originOffset = {
		5,
		2.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_eat_hands_5"),
	originOffset = {
		5.5,
		0.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_f_eat_hands_6"),
	originOffset = {
		6,
		0.5
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

local candyAnim = avatar.ANIM_EAT_F .. "_candy"
local candyOne, candyTwo, candyThree, candyFour, candyFive, candySix = {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_1"),
	originOffset = {
		-11.5,
		1.5
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_2"),
	originOffset = {
		-11.5,
		4
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_3"),
	originOffset = {
		-6.5,
		5.5
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_4"),
	originOffset = {
		-2,
		7
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_5"),
	originOffset = {
		0.5,
		2
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_6"),
	originOffset = {
		0,
		2
	}
}

register.newAnimation(candyAnim, {
	candyOne,
	candyTwo,
	candyThree,
	candyFour,
	candyFive,
	candySix,
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_eat_candy_7"),
		originOffset = {
			0,
			2
		}
	},
	candyFour,
	candyThree,
	candyTwo,
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_EAT_F,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim,
		candyAnim
	}
})
