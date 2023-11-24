local hairAnim = avatar.ANIM_INTERACT_F .. "_hair"
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
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_INTERACT_F .. "_head"
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
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_INTERACT_F .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_1"),
		originOffset = {
			0,
			-4.5
		}
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_2"),
		originOffset = {
			0,
			-3
		}
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_3"),
		originOffset = {
			0.5,
			-1
		}
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_4"),
		originOffset = {
			0.5,
			0
		}
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_5"),
		originOffset = {
			0.5,
			0.5
		}
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_6"),
		originOffset = {
			0,
			-3
		}
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_use_torso_7"),
		originOffset = {
			0,
			-4.5
		}
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_INTERACT_F .. "_legs"
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
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_INTERACT_F .. "_shoes"
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
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_INTERACT_F .. "_hands"
local handOffset = {
	0,
	5
}
local handOne, handTwo, handThree, handFour, handFive, handSix = register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_1"),
		originOffset = {
			0.5,
			1.5
		}
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_2"),
		originOffset = {
			1.5,
			5
		}
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_3"),
		originOffset = {
			2.5,
			7.5
		}
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_4"),
		originOffset = {
			2.5,
			8
		}
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_5"),
		originOffset = {
			2.5,
			7.5
		}
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_6"),
		originOffset = {
			1.5,
			5
		}
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_use_hands_7"),
		originOffset = {
			0.5,
			1.5
		}
	},
	halfOriginOffset = true
})

avatar.registerLayerCollection({
	id = avatar.ANIM_INTERACT_F,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim
	}
})
