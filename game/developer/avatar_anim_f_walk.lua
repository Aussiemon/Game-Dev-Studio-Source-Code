local function playFootstep(animObj, animObjOwner)
	animObjOwner:playFootstep()
end

local walkAnimEvents = {
	[2] = playFootstep,
	[7] = playFootstep
}
local hairAnim = avatar.ANIM_WALK_F .. "_hair"
local hairOffset = {
	0,
	-6.5
}
local hairOffsetTwo = {
	0,
	-5.5
}
local hairQuad = quadLoader:load("employee_f_hair")
local faceQuad = quadLoader:load("employee_f_face")

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_WALK_F .. "_head"
local headOffOne = {
	0,
	-3
}
local headOffTwo = {
	0,
	-2
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_WALK_F .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_walk_torso_1")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_2")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_3")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_4")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_5")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_6")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_7")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_8")
	},
	{
		quad = quadLoader:load("employee_f_walk_torso_9")
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_WALK_F .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_f_walk_legs_1")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_2")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_3")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_4")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_5")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_6")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_7")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_8")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_9")
	},
	halfOriginOffset = true
}, walkAnimEvents)

local shoesAnim = avatar.ANIM_WALK_F .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_f_walk_shoes_1")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_2")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_3")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_4")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_5")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_6")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_7")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_8")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_9")
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_WALK_F .. "_hands"
local handOffset = {
	0,
	5
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_walk_hands_1"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_2"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_3"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_4"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_5"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_6"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_7"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_8"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_f_walk_hands_9"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_WALK_F,
	layers = {
		legsAnim,
		hairAnim,
		headAnim,
		torsoAnim,
		handsAnim,
		shoesAnim
	},
	colorMap = {
		"legColor",
		"hairColor",
		"skinColor",
		"torsoColor",
		"skinColor",
		"shoeColor"
	}
})

local function playFootstep(animObj, animObjOwner)
	animObjOwner:playFootstep()
end

local walkAnimEvents = {
	[2] = playFootstep,
	[7] = playFootstep
}
local hairAnim = avatar.ANIM_WALK_CARRY_F .. "_hair"
local hairOffset = {
	0,
	-4.5
}
local hairOffsetTwo = {
	0,
	-3.5
}
local hairQuad = quadLoader:load("employee_f_hair")
local faceQuad = quadLoader:load("employee_f_face")

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffset
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	{
		quad = hairQuad,
		originOffset = hairOffsetTwo
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_WALK_CARRY_F .. "_head"
local headOffOne = {
	0,
	-1
}
local headOffTwo = {
	0,
	-0
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffOne
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	{
		quad = faceQuad,
		originOffset = headOffTwo
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_WALK_CARRY_F .. "_torso"
local torsoOffset = {
	0,
	4
}

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_carry_torso1"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso2"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso3"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso4"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso5"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso6"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso7"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso8"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso9"),
		originOffset = torsoOffset
	},
	{
		quad = quadLoader:load("employee_f_carry_torso5"),
		originOffset = torsoOffset
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_WALK_CARRY_F .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_f_walk_legs_1")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_2")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_3")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_4")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_5")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_6")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_7")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_8")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_9")
	},
	{
		quad = quadLoader:load("employee_f_walk_legs_5")
	},
	halfOriginOffset = true
}, walkAnimEvents)

local shoesAnim = avatar.ANIM_WALK_CARRY_F .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_f_walk_shoes_1")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_2")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_3")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_4")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_5")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_6")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_7")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_8")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_9")
	},
	{
		quad = quadLoader:load("employee_f_walk_shoes_5")
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_WALK_CARRY_F .. "_hands"
local handOffset = {
	0,
	10
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_carry_hands1"),
		originOffset = {
			1.5,
			9.5
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands2"),
		originOffset = {
			1,
			9.5
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands3"),
		originOffset = {
			1,
			9
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands4"),
		originOffset = {
			0.5,
			9.5
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands5"),
		originOffset = {
			1,
			10.5
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands6"),
		originOffset = {
			0,
			13
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands7"),
		originOffset = {
			-1,
			14.5
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands8"),
		originOffset = {
			-1,
			14
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands9"),
		originOffset = {
			0,
			11
		}
	},
	{
		quad = quadLoader:load("employee_f_carry_hands5"),
		originOffset = {
			1,
			10.5
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_WALK_CARRY_F,
	layers = {
		legsAnim,
		hairAnim,
		headAnim,
		torsoAnim,
		handsAnim,
		shoesAnim
	},
	colorMap = {
		"legColor",
		"hairColor",
		"skinColor",
		"torsoColor",
		"skinColor",
		"shoeColor"
	}
})
