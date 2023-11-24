local hairAnim = avatar.ANIM_SHIT_F .. "_hair"

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_f_hair"),
		originOffset = {
			0,
			-12
		}
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_SHIT_F .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_f_face"),
		originOffset = {
			0,
			-8.5
		}
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_SHIT_F .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_toilet_torso"),
		originOffset = {
			0,
			-6
		}
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_SHIT_F .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_f_toilet_legs"),
		originOffset = {
			0,
			1.5
		}
	},
	halfOriginOffset = true
})

local trousersAnim = avatar.ANIM_SHIT_F .. "_trousers"

register.newAnimation(trousersAnim, {
	{
		frame = "worker_trousers",
		quad = quadLoader:load("employee_f_toilet_trousers"),
		originOffset = {
			0,
			-0.5
		}
	},
	halfOriginOffset = true
})

local newspaperAnim = avatar.ANIM_SHIT_F .. "_newspaper"

register.newAnimation(newspaperAnim, {
	{
		frame = "worker_decor",
		quad = quadLoader:load("employee_f_toilet_newspaper"),
		originOffset = {
			0.5,
			9.5
		}
	},
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_SHIT_F .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_f_toilet_shoes"),
		originOffset = {
			0,
			0
		}
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_SHIT_F .. "_hands"

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_toilet_hands"),
		originOffset = {
			0,
			5
		}
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_SHIT_F,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		trousersAnim,
		shoesAnim,
		newspaperAnim
	},
	colorMap = {
		"skinColor",
		"hairColor",
		"torsoColor",
		"skinColor",
		"skinColor",
		"legColor",
		"shoesAnim"
	}
})
