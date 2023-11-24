characterDesigner = {}
characterDesigner.ASSIGNABLE_TRAITS = math.min(2, traits.MAX_PER_DEVELOPER)
characterDesigner.ASSIGNABLE_INTERESTS = math.min(2, interests.MAX_INTERESTS)
characterDesigner.EVENTS = {
	TRAIT_ADDED = events:new(),
	TRAIT_REMOVED = events:new(),
	GENDER_CHANGED = events:new()
}

function characterDesigner:init()
end

function characterDesigner:begin(inGame, initialSkillLevel, initialSkillLevels)
	initialSkillLevel = initialSkillLevel or game.PLAYER_CHARACTER_STARTING_SKILL_LEVELS
	self.employee = developer.new()
	
	self.employee:setLevel(game.PLAYER_CHARACTER_STARTING_LEVEL)
	self.employee:setAge(game.PLAYER_CHARACTER_STARTING_AGE)
	self.employee:setRole(game.PLAYER_CHARACTER_ROLE)
	
	if math.random(1, 100) <= 50 then
		self.employee:setIsFemale(true)
	else
		self.employee:setIsFemale(false)
	end
	
	self.employee:createPortrait()
	
	self.availableAttributePoints = attributes.profiler:getAttributeAmount(self.employee)
	
	self.employee:setAttributePoints(self.availableAttributePoints)
	self.employee:setIsPlayerCharacter(true)
	
	for key, skillData in ipairs(skills.registered) do
		local skillLevel = initialSkillLevel
		
		skillLevel = initialSkillLevels and initialSkillLevels[skillData.id] or skillLevel
		
		self.employee:setSkillLevel(skillData.id, skillLevel)
	end
	
	self:createPopup(inGame)
end

function characterDesigner:reset()
	self.employee = nil
	self.availableAttributePoints = 0
end

function characterDesigner:setFemale(state)
	self.employee:setIsFemale(state)
	events:fire(characterDesigner.EVENTS.GENDER_CHANGED, self.employee)
end

function characterDesigner:addTrait(traitID)
	self.employee:addTrait(traitID)
	events:fire(characterDesigner.EVENTS.TRAIT_ADDED, traitID)
end

function characterDesigner:hasTrait(traitID)
	return self.employee:hasTrait(traitID)
end

function characterDesigner:removeTrait(traitID)
	self.employee:removeTrait(traitID)
	events:fire(characterDesigner.EVENTS.TRAIT_REMOVED, traitID)
end

function characterDesigner:changeAttribute(id, amount)
	if amount > 0 and self.availableAttributePoints <= 0 then
		return 
	end
	
	local curLevel = self.employee:getAttributes()[id]
	
	if curLevel <= 0 and amount < 0 or curLevel >= attributes:getMaxLevel(id) and amount > 0 then
		return 
	end
	
	self.availableAttributePoints = self.availableAttributePoints - amount
	
	self.employee:changeAttribute(id, amount)
	self.employee:setAttributePoints(self.availableAttributePoints)
end

function characterDesigner:getAvailableAttributePoints()
	return self.availableAttributePoints
end

function characterDesigner:getEmployee()
	return self.employee
end

function characterDesigner:finish()
	local employee = self.employee
	
	employee:setRetirementAge(math.random(developer.RETIREMENT_AGE_MIN, developer.RETIREMENT_AGE_MAX))
	employee:setEmployer(studio)
	employee:setIsPlayerCharacter(true)
	employee:assignUniqueID()
	employee:updateSkinColors()
	knowledge:assignFromInterests(employee)
	skills:updateSkillDevSpeedAffectors(employee)
	studio:hireEmployee(employee)
	game.curGametype:setPlayerCharacter(employee)
	self:reset()
	frameController:pop()
end

characterDesigner.POPUP_WIDTH = 510
characterDesigner.POPUP_HEIGHT = 520
characterDesigner.POPUP_BOTTOM_BUTTON_SPACING = 36
characterDesigner.LIST_HORIZONTAL_SPACING = 5
characterDesigner.LIST_WIDTH = 236

function characterDesigner:createPopup(inGame)
	local totalHeight = characterDesigner.POPUP_HEIGHT
	local scaledPopupHeight = _S(characterDesigner.POPUP_HEIGHT)
	local frame = gui.create("Frame")
	
	frame:setSize(characterDesigner.POPUP_WIDTH, totalHeight)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("CREATE_YOUR_CHARACTER_TITLE", "Create Your Character"))
	frame:hideCloseButton()
	
	local scaledHorSpacing = _S(characterDesigner.LIST_HORIZONTAL_SPACING)
	local traitSelectionList = gui.create("List", frame)
	
	traitSelectionList:setPanelColor(developer.employeeMenuListColor)
	
	local traitCategory = gui.create("Category", traitSelectionList)
	
	traitCategory:setFont(fonts.get("pix24"))
	traitCategory:setText(_T("TRAITS", "Traits"))
	
	for i = 1, characterDesigner.ASSIGNABLE_TRAITS do
		local traitSelectionOption = gui.create("TraitSelectionGradientIconPanel", traitSelectionList)
		
		traitSelectionOption:setEmployee(self.employee)
		traitSelectionOption:setTraitIndex(i)
		traitSelectionOption:setIconOffset(0, 0)
	end
	
	traitSelectionList:updateLayout(characterDesigner.LIST_WIDTH)
	
	local interestSelectionList = gui.create("List", frame)
	
	interestSelectionList:setPanelColor(developer.employeeMenuListColor)
	
	local interestCategory = gui.create("Category", interestSelectionList)
	
	interestCategory:setFont(fonts.get("pix24"))
	interestCategory:setText(_T("INTERESTS", "Interests"))
	
	for i = 1, characterDesigner.ASSIGNABLE_INTERESTS do
		local interestSelectionOption = gui.create("InterestSelectionGradientIconPanel", interestSelectionList)
		
		interestSelectionOption:setEmployee(self.employee)
		interestSelectionOption:setSelectedInterest(nil)
	end
	
	interestSelectionList:updateLayout(characterDesigner.LIST_WIDTH)
	interestSelectionList:setPos(_S(characterDesigner.POPUP_WIDTH) - (interestSelectionList.w + scaledHorSpacing), scaledPopupHeight - _S(10) - interestSelectionList.h)
	traitSelectionList:setPos(_S(characterDesigner.POPUP_WIDTH) - (traitSelectionList.w + scaledHorSpacing), interestSelectionList.y - _S(5) - traitSelectionList.h)
	frame:setSize(characterDesigner.POPUP_WIDTH, characterDesigner.POPUP_HEIGHT + characterDesigner.POPUP_BOTTOM_BUTTON_SPACING)
	
	local attributeList = gui.create("List", frame)
	
	attributeList:setPanelColor(developer.employeeMenuListColor)
	
	local attributeCategory = gui.create("AttributeAssignmentCategory", attributeList)
	
	attributeCategory:setFont(fonts.get("pix24"))
	attributeCategory:setText(_T("ATTRIBUTES", "Attributes"))
	attributeCategory:updateText()
	
	for key, data in ipairs(attributes.registered) do
		local attributeAssignment = gui.create("AttributeAssignmentGradientIconPanel", attributeList)
		
		attributeAssignment:setEmployee(self.employee)
		attributeAssignment:setAttributeID(data.id)
	end
	
	attributeList:updateLayout(characterDesigner.LIST_WIDTH)
	attributeList:setPos(scaledHorSpacing, _S(characterDesigner.POPUP_HEIGHT) - attributeList.h - _S(10))
	
	local appearanceDisplay = gui.create("CharacterAppearanceDisplay", frame)
	
	appearanceDisplay:setSize(200, 270)
	appearanceDisplay:setPos(frame.w - appearanceDisplay.w - _S(23), _S(45))
	appearanceDisplay:setEmployee(self.employee)
	
	local appearanceOptionList = gui.create("List", frame)
	
	appearanceOptionList:setPanelColor(developer.employeeMenuListColor)
	appearanceOptionList:setPos(scaledHorSpacing, _S(40))
	
	local appearanceCategory = gui.create("Category", appearanceOptionList)
	
	appearanceCategory:setFont(fonts.get("pix24"))
	appearanceCategory:setText(_T("APPEARANCE", "Appearance"))
	
	local faceAdjust = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	faceAdjust:setEmployee(self.employee)
	faceAdjust:initializeAdjustmentButtons("FaceAdjustmentButton")
	faceAdjust:setHeight(28)
	faceAdjust:setText(_T("FACE_TYPE", "Face type"))
	faceAdjust:verifyValidity()
	
	local hairAdjustment = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	hairAdjustment:setEmployee(self.employee)
	hairAdjustment:initializeAdjustmentButtons("HairAdjustmentButton")
	hairAdjustment:initializeColorAdjustmentButton("HairColorAdjustmentButton")
	hairAdjustment:setHeight(28)
	hairAdjustment:setPartType(portrait.APPEARANCE_PARTS.HAIRCUT)
	hairAdjustment:setText(_T("HAIR_STYLE", "Hair style"))
	hairAdjustment:verifyValidity()
	
	local facialHairAdjustment = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	facialHairAdjustment:setEmployee(self.employee)
	facialHairAdjustment:initializeAdjustmentButtons("FacialHairAdjustmentButton")
	facialHairAdjustment:setHeight(28)
	facialHairAdjustment:setText(_T("FACIAL_HAIR", "Facial hair"))
	facialHairAdjustment:setPartType(portrait.APPEARANCE_PARTS.BEARD)
	facialHairAdjustment:verifyValidity()
	
	local glassesAdjustment = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	glassesAdjustment:setEmployee(self.employee)
	glassesAdjustment:initializeAdjustmentButtons("GlassesAdjustmentButton")
	glassesAdjustment:setHeight(28)
	glassesAdjustment:setText(_T("GLASSES", "Glasses"))
	glassesAdjustment:setPartType(portrait.APPEARANCE_PARTS.GLASSES)
	glassesAdjustment:verifyValidity()
	
	local eyebrowsAdjust = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	eyebrowsAdjust:setEmployee(self.employee)
	eyebrowsAdjust:initializeAdjustmentButtons("EyebrowAdjustmentButton")
	eyebrowsAdjust:setHeight(28)
	eyebrowsAdjust:setText(_T("EYEBROWS", "Eyebrows"))
	eyebrowsAdjust:verifyValidity()
	
	local eyeAdjust = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	eyeAdjust:setEmployee(self.employee)
	eyeAdjust:initializeAdjustmentButtons("EyeAdjustmentButton")
	eyeAdjust:initializeColorAdjustmentButton("EyeColorAdjustmentButton")
	eyeAdjust:setHeight(28)
	eyeAdjust:setText(_T("EYES", "Eyes"))
	eyeAdjust:verifyValidity()
	
	local skinColorAdjustment = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	skinColorAdjustment:setEmployee(self.employee)
	skinColorAdjustment:initializeAdjustmentButtons("SkinColorAdjustmentButton")
	skinColorAdjustment:setHeight(28)
	skinColorAdjustment:setText(_T("SKIN_COLOR", "Skin color"))
	skinColorAdjustment:verifyValidity()
	
	local shirtAdjustment = gui.create("AppearanceAdjustment", appearanceOptionList)
	
	shirtAdjustment:setEmployee(self.employee)
	shirtAdjustment:initializeAdjustmentButtons("ShirtAdjustmentButton")
	shirtAdjustment:setHeight(28)
	shirtAdjustment:setText(_T("SHIRT", "Shirt"))
	shirtAdjustment:verifyValidity()
	
	local randomizeAppearance = gui.create("RandomizeAppearanceButton", appearanceOptionList)
	
	randomizeAppearance:setHeight(28)
	
	if not inGame then
		local cancelButton = gui.create("CancelGameButton", frame)
		
		cancelButton:setSize(100, 28)
		cancelButton:setPos(scaledHorSpacing, frame.h - cancelButton.h - _S(8))
		
		local confirmBegin = gui.create("ConfirmBeginGameButton", frame)
		
		confirmBegin:setSize(200, 28)
		confirmBegin:setPos(cancelButton.x + cancelButton.w + _S(5), frame.h - confirmBegin.h - _S(8))
	else
		local confirmFinish = gui.create("ConfirmNewPlayerCharacterButton", frame)
		
		confirmFinish:setSize(200, 28)
		confirmFinish:setPos(scaledHorSpacing, frame.h - confirmFinish.h - _S(8))
	end
	
	appearanceOptionList:updateLayout(characterDesigner.LIST_WIDTH)
	
	local x, y = appearanceOptionList:getPos(true)
	local maleG = gui.create("SexButton", frame)
	
	maleG:setEmployee(self.employee)
	maleG:setSize(32, 32)
	maleG:setPos(x + attributeList.w + _S(5), y)
	
	local femaleG = gui.create("SexButton", frame)
	
	femaleG:setEmployee(self.employee)
	femaleG:setFemale(true)
	femaleG:setSize(32, 32)
	femaleG:setPos(x + attributeList.w + _S(5), y + maleG.h + _S(5))
	frame:center()
	
	local skillList = self.employee:createSkillList(frame.x - _S(10), frame.y, gui.SIDES.LEFT)
	
	skillList:tieVisibilityTo(frame)
	frameController:push(frame)
	
	self.frame = frame
end
