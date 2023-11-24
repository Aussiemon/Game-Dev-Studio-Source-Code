local hairAnim = avatar.ANIM_EAT .. "_hair"
local hairOne = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_eat_hair_1"),
	originOffset = {
		0,
		-8
	}
}
local hairTwo = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_eat_hair_2"),
	originOffset = {
		0,
		-8
	}
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	hairOne,
	hairOne,
	hairOne,
	hairTwo,
	hairTwo,
	hairTwo,
	hairOne,
	hairOne,
	hairOne,
	hairOne,
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_EAT .. "_head"
local headOne = {
	frame = "worker_head",
	quad = quadLoader:load("employee_eat_head_1"),
	originOffset = {
		0,
		-7
	}
}
local headTwo = {
	frame = "worker_head",
	quad = quadLoader:load("employee_eat_head_2"),
	originOffset = {
		0,
		-6.5
	}
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	headOne,
	headOne,
	headOne,
	headTwo,
	headTwo,
	headTwo,
	headOne,
	headOne,
	headOne,
	headOne,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_EAT .. "_torso"
local torsoOne, torsoTwo, torsoThree, torsoFour, torsoFive, torsoSix = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_eat_torso_1"),
	originOffset = {
		0,
		-6
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_eat_torso_2"),
	originOffset = {
		1,
		-5.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_eat_torso_3"),
	originOffset = {
		1.5,
		-3.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_eat_torso_4"),
	originOffset = {
		1.5,
		-3
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_eat_torso_5"),
	originOffset = {
		1.5,
		-3
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_eat_torso_6"),
	originOffset = {
		1.5,
		-3.5
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

local legsAnim = avatar.ANIM_EAT .. "_legs"
local legConfig = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_eat_legs"),
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

local shoesAnim = avatar.ANIM_EAT .. "_shoes"
local shoesConfig = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_eat_shoes"),
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

local handsAnim = avatar.ANIM_EAT .. "_hands"
local handOffset = {
	6,
	3
}
local handOne, handTwo, handThree, handFour, handFive, handSix = {
	frame = "worker_hands",
	quad = quadLoader:load("employee_eat_hands_1"),
	originOffset = {
		0,
		-1
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_eat_hands_2"),
	originOffset = {
		2.5,
		0.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_eat_hands_3"),
	originOffset = {
		4.5,
		2.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_eat_hands_4"),
	originOffset = {
		5.5,
		1.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_eat_hands_5"),
	originOffset = {
		6.5,
		1.5
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_eat_hands_6"),
	originOffset = {
		5.5,
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

local candyAnim = avatar.ANIM_EAT .. "_candy"
local candyOne, candyTwo, candyThree, candyFour, candyFive, candySix = {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_1"),
	originOffset = {
		-15,
		1.5
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_2"),
	originOffset = {
		-10,
		4.5
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_3"),
	originOffset = {
		-4,
		7
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_4"),
	originOffset = {
		-1.5,
		7
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_5"),
	originOffset = {
		0.5,
		5
	}
}, {
	frame = "worker_decor",
	quad = quadLoader:load("employee_eat_candy_6"),
	originOffset = {
		-0.5,
		2.5
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
			-0.5,
			3.5
		}
	},
	candyFour,
	candyThree,
	candyTwo,
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_EAT,
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
