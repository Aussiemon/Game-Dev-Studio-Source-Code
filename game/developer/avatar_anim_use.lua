local hairAnim = avatar.ANIM_INTERACT .. "_hair"
local hairOne = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_use_hair_1"),
	originOffset = {
		0,
		-8
	}
}
local hairTwo = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_use_hair_2"),
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
	hairOne,
	hairTwo,
	hairTwo,
	hairOne,
	hairOne,
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_INTERACT .. "_head"
local headOne = {
	frame = "worker_head",
	quad = quadLoader:load("employee_use_head_1"),
	originOffset = {
		0,
		-7
	}
}
local headTwo = {
	frame = "worker_head",
	quad = quadLoader:load("employee_use_head_2"),
	originOffset = {
		0,
		-7
	}
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	headOne,
	headOne,
	headOne,
	headTwo,
	headTwo,
	headOne,
	headTwo,
	headTwo,
	headOne,
	headOne,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_INTERACT .. "_torso"
local torsoOne, torsoTwo, torsoThree, torsoFour, torsoFive, torsoSix = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_use_torso_1"),
	originOffset = {
		0,
		-6
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_use_torso_2"),
	originOffset = {
		0,
		-5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_use_torso_3"),
	originOffset = {
		0,
		-3
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_use_torso_4"),
	originOffset = {
		0,
		-2
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_use_torso_5"),
	originOffset = {
		0,
		-1.5
	}
}, {
	frame = "worker_torso",
	quad = quadLoader:load("employee_use_torso_6"),
	originOffset = {
		0,
		-1
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

local legsAnim = avatar.ANIM_INTERACT .. "_legs"
local legConfig = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_use_legs"),
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

local shoesAnim = avatar.ANIM_INTERACT .. "_shoes"
local shoesConfig = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_use_shoes"),
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

local handsAnim = avatar.ANIM_INTERACT .. "_hands"
local handOffset = {
	0,
	5
}
local handOne, handTwo, handThree, handFour, handFive, handSix = {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_1"),
	originOffset = {
		0,
		1
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_2"),
	originOffset = {
		0,
		2
	}
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_3"),
	originOffset = handOffset
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_4"),
	originOffset = handOffset
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_5"),
	originOffset = handOffset
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_6"),
	originOffset = handOffset
}, {
	frame = "worker_hands",
	quad = quadLoader:load("employee_use_hands_5"),
	originOffset = handOffset
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
avatar.registerLayerCollection({
	id = avatar.ANIM_INTERACT,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim
	}
})
