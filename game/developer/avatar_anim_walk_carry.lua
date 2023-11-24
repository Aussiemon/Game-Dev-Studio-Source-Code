local function playFootstep(animObj, animObjOwner)
	animObjOwner:playFootstep()
end

local walkAnimEvents = {
	[2] = playFootstep,
	[7] = playFootstep
}
local hairAnim = avatar.ANIM_WALK_CARRY .. "_hair"
local hairOffset = {
	0,
	-1
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_walk_hair_1"),
		originOffset = {
			1,
			-1
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_2"),
		originOffset = {
			2,
			-2
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_3"),
		originOffset = {
			1.5,
			-1.5
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_4"),
		originOffset = {
			0.5,
			-1
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_5"),
		originOffset = {
			0.5,
			-1
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_6"),
		originOffset = {
			0.5,
			-1
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_7"),
		originOffset = {
			1,
			-0.5
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_8"),
		originOffset = {
			1.5,
			-1
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_9"),
		originOffset = {
			1,
			-0.5
		}
	},
	{
		quad = quadLoader:load("employee_walk_hair_10"),
		originOffset = {
			0.5,
			-1
		}
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_WALK_CARRY .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_walk_head_1"),
		originOffset = {
			1,
			0
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_2"),
		originOffset = {
			2,
			-1
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_3"),
		originOffset = {
			1.5,
			-0.5
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_4"),
		originOffset = {
			0.5,
			0
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_5"),
		originOffset = {
			0.5,
			0
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_6"),
		originOffset = {
			0.5,
			0
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_7"),
		originOffset = {
			1,
			0.5
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_8"),
		originOffset = {
			1.5,
			0
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_9"),
		originOffset = {
			1,
			0.5
		}
	},
	{
		quad = quadLoader:load("employee_walk_head_10"),
		originOffset = {
			0.5,
			0
		}
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_WALK_CARRY .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_walk_carry_torso_6")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_2")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_3")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_4")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_5")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_1")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_7")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_8")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_9")
	},
	{
		quad = quadLoader:load("employee_walk_carry_torso_10")
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_WALK_CARRY .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_walk_legs_1")
	},
	{
		quad = quadLoader:load("employee_walk_legs_2")
	},
	{
		quad = quadLoader:load("employee_walk_legs_3")
	},
	{
		quad = quadLoader:load("employee_walk_legs_4")
	},
	{
		quad = quadLoader:load("employee_walk_legs_5")
	},
	{
		quad = quadLoader:load("employee_walk_legs_6")
	},
	{
		quad = quadLoader:load("employee_walk_legs_7")
	},
	{
		quad = quadLoader:load("employee_walk_legs_8")
	},
	{
		quad = quadLoader:load("employee_walk_legs_9")
	},
	{
		quad = quadLoader:load("employee_walk_legs_10")
	},
	halfOriginOffset = true
}, walkAnimEvents)

local shoesAnim = avatar.ANIM_WALK_CARRY .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_walk_shoes_1")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_2")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_3")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_4")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_5")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_6")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_7")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_8")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_9")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_10")
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_WALK_CARRY .. "_hands"
local handQuad = quadLoader:load("employee_walk_carry_hand_1")

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = handQuad,
		originOffset = {
			14,
			7
		}
	},
	{
		quad = handQuad,
		originOffset = {
			12,
			9
		}
	},
	{
		quad = handQuad,
		originOffset = {
			11.5,
			8.5
		}
	},
	{
		quad = handQuad,
		originOffset = {
			13.5,
			7
		}
	},
	{
		quad = handQuad,
		originOffset = {
			15.5,
			4
		}
	},
	{
		quad = handQuad,
		originOffset = {
			15.5,
			4
		}
	},
	{
		quad = handQuad,
		originOffset = {
			15,
			2.5
		}
	},
	{
		quad = handQuad,
		originOffset = {
			14.5,
			1
		}
	},
	{
		quad = handQuad,
		originOffset = {
			15,
			1.5
		}
	},
	{
		quad = handQuad,
		originOffset = {
			15.5,
			2
		}
	},
	halfOriginOffset = true
})

local handAnim = avatar.ANIM_WALK_CARRY .. "_hand"
local handQuad = quadLoader:load("employee_walk_carry_cuphand")

register.newAnimation(handAnim, {
	{
		frame = "worker_hands_2",
		quad = handQuad,
		originOffset = {
			-12.5,
			10
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-11.5,
			9
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-12,
			9.5
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-13,
			10
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-13,
			10
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-13,
			10
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-12.5,
			10.5
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-12,
			10
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-12.5,
			10.5
		}
	},
	{
		quad = handQuad,
		originOffset = {
			-13,
			10
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_WALK_CARRY,
	layers = {
		legsAnim,
		hairAnim,
		headAnim,
		torsoAnim,
		handsAnim,
		handAnim,
		shoesAnim
	},
	colorMap = {
		"legColor",
		"hairColor",
		"skinColor",
		"torsoColor",
		"skinColor",
		"skinColor",
		"shoeColor"
	}
})
