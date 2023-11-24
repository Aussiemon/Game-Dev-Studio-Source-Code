local hairAnim = avatar.ANIM_WORK_F .. "_hair"
local headCfg = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_f_hair"),
	originOffset = {
		0,
		-5.5
	}
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	headCfg,
	halfOriginOffset = true
})

local hairCfg = {
	frame = "worker_head",
	quad = quadLoader:load("employee_f_face"),
	originOffset = {
		0,
		-2
	}
}
local headAnim = avatar.ANIM_WORK_F .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	hairCfg,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_WORK_F .. "_torso"
local torsoOffset = {
	0,
	1.5
}

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso1"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso2"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso3"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso4"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso5"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso6"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso7"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso8"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso9"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso10"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso11"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso12"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso13"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso14"),
		originOffset = torsoOffset
	},
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_f_work_torso15"),
		originOffset = torsoOffset
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_WORK_F .. "_legs"
local legCfg = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_f_sit_legs"),
	originOffset = {
		0,
		-4
	}
}

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	legCfg,
	halfOriginOffset = true
})

local shoeCfg = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_f_sit_shoes"),
	originOffset = {
		0,
		-4
	}
}
local shoesAnim = avatar.ANIM_WORK_F .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	shoeCfg,
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_WORK_F .. "_hands"
local handOffset = {
	0,
	16
}
local handCfg = register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_1"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_2"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_3"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_4"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_5"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_6"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_7"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_8"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_9"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_10"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_11"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_12"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_13"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_14"),
		originOffset = handOffset
	},
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_f_work_hands_15"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})

avatar.registerLayerCollection({
	id = avatar.ANIM_WORK_F,
	layers = {
		handsAnim,
		hairAnim,
		headAnim,
		torsoAnim,
		legsAnim,
		shoesAnim
	},
	colorMap = {
		"skinColor",
		"hairColor",
		"skinColor",
		"torsoColor",
		"legColor",
		"shoeColor"
	}
})

local frames = tdas.getAnimData(handsAnim)

local function playKeyboard(animObj, animObjOwner)
	animObjOwner:playKeyboardClicks()
end

local workAnimEvents = {}

for i = 1, #frames do
	workAnimEvents[i] = playKeyboard
end

register.animationEvents(handsAnim, workAnimEvents)
