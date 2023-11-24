avatar.ANIM_INTERACT_F = "interact_f"
avatar.ANIM_SHIT_F = "shit_f"
avatar.ANIM_STAND_F = "stand_f"
avatar.ANIM_WORK_F = "work_f"
avatar.ANIM_WALK_F = "walk_f"
avatar.ANIM_SIT_IDLE_F = "sit_idle_f"
avatar.ANIM_DRINK_F = "drink_f"
avatar.ANIM_EAT_F = "eat_f"
avatar.ANIM_DRINK_COFFEE_F = "drink_coffee_f"
avatar.ANIM_WALK_CARRY_F = "walk_carry_f"

local hairAnim = avatar.ANIM_STAND_F .. "_hair"
local hairOffset = {
	0,
	-3.5
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = hairOffset
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_STAND_F .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face")
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_STAND_F .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_walk_torso_5")
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_STAND_F .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_f_walk_legs_5")
	},
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_STAND_F .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_f_walk_shoes_5")
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_STAND_F .. "_hands"
local handOffset = {
	0,
	5
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_walk_hands_5"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_STAND_F,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim
	}
})

local hairAnim = avatar.ANIM_SIT_IDLE_F .. "_hair"
local hairOffset = {
	0,
	-6.5
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = hairOffset
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_SIT_IDLE_F .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			0,
			-3
		}
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_SIT_IDLE_F .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_sit_torso"),
		originOffset = {
			0,
			-1
		}
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_SIT_IDLE_F .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_f_sit_legs"),
		originOffset = {
			0,
			-4
		}
	},
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_SIT_IDLE_F .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_f_sit_shoes"),
		originOffset = {
			0,
			-4
		}
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_SIT_IDLE_F .. "_hands"

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_sit_hands"),
		originOffset = {
			0,
			10
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_SIT_IDLE_F,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim
	}
})
require("game/developer/avatar_anim_f_walk")
require("game/developer/avatar_anim_drink_f")
require("game/developer/avatar_anim_eat_f")
require("game/developer/avatar_anim_interact_f")
require("game/developer/avatar_anim_work_f")
require("game/developer/avatar_anim_toilet_f")
require("game/developer/avatar_anim_sit_drink_f")
