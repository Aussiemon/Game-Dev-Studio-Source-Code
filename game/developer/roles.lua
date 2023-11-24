attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR = color(0, 0, 0, 50)
attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR = game.UI_COLORS.YELLOW

local softwareEngineer = attributes.profiler:registerRole({
	roleIcon = "role_software_engineer",
	mainSkill = "software",
	flatIcon = "new_role_software_engineer",
	id = "software_engineer",
	femaleChance = 10,
	display = _T("SOFTWARE_ENGINEER", "Software engineer"),
	displayPlural = _T("SOFTWARE_ENGINEER_PLURAL", "Software engineers"),
	personDisplay = _T("SOFTWARE_ENGINEER_PERSON", "a software engineer"),
	specDescription = _T("SOFTWARE_ENGINEER_SPEC_DESCRIPTION", "Having spent days upon days writing code, refactoring and fixing it, it's time for EMPLOYEE to choose which aspect of Software to specialize in."),
	inquiry = _T("SOFTWARE_ENGINEER_INQUIRY", "I'm a software engineer, so I take care of everything related to programming - that means engine and game programming. Most game and engine tech that comes out is software-related, so people like myself will be in charge of researching and implementing it."),
	description = _T("SOFTWARE_ENGINEER_DESCRIPTION", "This person's passion is programming. Software engineers get a grip on all software-related things faster than others.\n\nSince they're the only people that grasp a ton of programming concepts they will be your primary research workforce, whenever new tech is available."),
	startingAttribute = {
		{
			"intelligence",
			6
		}
	},
	skillAdvanceModifier = {
		graphics = 0.5,
		concept = 0.25,
		software = 1.5,
		sound = 0.5,
		writing = 0.25,
		management = 0.25
	}
})

softwareEngineer:addSpecialization({
	id = "algorithms",
	display = _T("SPECIALIZATION_ALGORITHMS", "Algorithms"),
	displayLong = _T("SPECIALIZATION_ALGORITHMS_LONG", "Algorithm specialist"),
	description = _T("SPECIALIZATION_ALGORITHMS_DESCRIPTION", "This person specializes in general purpose algorithms, and is therefore more efficient when working on tasks that don't involve the graphical side of things."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_ALGORITHMS_BOOST", "Higher efficiency when working on non-graphics Software tasks."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth, nil, nil, nil, nil)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})
softwareEngineer:addSpecialization({
	id = "rendering",
	display = _T("SPECIALIZATION_RENDERING", "Rendering"),
	displayLong = _T("SPECIALIZATION_RENDERING_LONG", "Rendering specialist"),
	description = _T("SPECIALIZATION_RENDERING_DESCRIPTION", "This person specializes in rendering techniques and effects, and is therefore more efficient when working on tasks that are related to graphics."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_RENDERING_BOOST", "Higher efficiency when working on graphics Software tasks."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth, nil, nil, nil, nil)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})
require("game/developer/roles_software_engineer_dialogues")

local soundEngineer = attributes.profiler:registerRole({
	description = "This person's passion is creating sounds. Sound engineers gain experience in audio asset creation quicker.",
	roleIcon = "role_sound_engineer",
	mainSkill = "sound",
	flatIcon = "new_role_sound_engineer",
	id = "sound_engineer",
	femaleChance = 20,
	display = _T("SOUND_ENGINEER", "Sound engineer"),
	displayPlural = _T("SOUND_ENGINEER_PLURAL", "Sound engineers"),
	personDisplay = _T("SOUND_ENGINEER_PERSON", "a sound engineer"),
	specDescription = _T("SOUND_ENGINEER_SPEC_DESCRIPTION", "Editing sounds, sampling sounds, composing music - just a regular day in the life of a sound engineer. But now it's time to choose which side of sound engineering EMPLOYEE should specialize in."),
	inquiry = _T("SOUND_ENGINEER_INQUIRY", "I'm a sound engineer, so everything related to creation of sound and music is my line of work."),
	startingAttribute = {
		{
			"vision",
			6
		}
	},
	skillAdvanceModifier = {
		graphics = 0.5,
		concept = 0.25,
		software = 0.5,
		sound = 1.5,
		writing = 0.25,
		testing = 0.5,
		management = 0.25
	}
})

soundEngineer:addSpecialization({
	id = "composition",
	display = _T("SPECIALIZATION_COMPOSER", "Composition"),
	displayLong = _T("SPECIALIZATION_COMPOSER_LONG", "Composition specialist"),
	description = _T("SPECIALIZATION_COMPOSER_DESCRIPTION", "This person specializes in writing music, and is therefore more efficient when working on tasks involving it."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_COMPOSER_BOOST", "Higher efficiency when working on music-related Sound tasks."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth, nil, nil, nil, nil)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})
soundEngineer:addSpecialization({
	id = "editing",
	display = _T("SPECIALIZATION_EDITING", "Editing"),
	displayLong = _T("SPECIALIZATION_EDITING_LONG", "Editing specialist"),
	description = _T("SPECIALIZATION_EDITING_DESCRIPTION", "This person specializes in editing sounds, and is therefore more efficient when working on tasks involving creation of sounds."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_EDITING_BOOST", "Higher efficiency when working on audio-related Sound tasks."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth, nil, nil, nil, nil)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})

local artist = attributes.profiler:registerRole({
	description = "This person's passion is everything graphics-related. Artists get better at developing graphical assets quickly.",
	roleIcon = "role_artist",
	mainSkill = "graphics",
	flatIcon = "new_role_artist",
	id = "artist",
	femaleChance = 40,
	display = _T("ARTIST", "Artist"),
	displayPlural = _T("ARTIST_PLURAL", "Artists"),
	personDisplay = _T("ARTIST_PERSON", "an artist"),
	specDescription = _T("ARTIST_SPEC_DESCRIPTION", "All that time spent drawing, making 3D models and textures surely helped EMPLOYEE get good at his job, but it's time to pick which aspect he should specialize in."),
	inquiry = _T("ARTIST_INQUIRY", "I'm an artist, so I take care of art style creation. I also create visual assets for game projects."),
	startingAttribute = {
		{
			"vision",
			6
		}
	},
	skillAdvanceModifier = {
		graphics = 1.5,
		concept = 0.5,
		software = 0.25,
		sound = 0.25,
		writing = 0.25,
		testing = 0.5,
		management = 0.25
	}
})

artist:addSpecialization({
	id = "organic_art",
	display = _T("SPECIALIZATION_ORGANIC_ART", "Organic art"),
	displayLong = _T("SPECIALIZATION_ORGANIC_ART_LONG", "Organic art specialist"),
	description = _T("SPECIALIZATION_ORGANIC_ART_DESCRIPTION", "This person specializes in organic art, and is therefore more efficient when working on tasks that involve it."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_ORGANIC_ART_BOOST", "Higher efficiency when working on organic visual asset creation tasks."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth, nil, nil, nil, nil)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})
artist:addSpecialization({
	id = "stylized_art",
	display = _T("SPECIALIZATION_STYLIZED_ART", "Stylized art"),
	displayLong = _T("SPECIALIZATION_STYLIZED_ART_LONG", "Stylized art specialist"),
	description = _T("SPECIALIZATION_STYLIZED_ART_DESCRIPTION", "This person specializes in stylized art, and is therefore more efficient when working on tasks that involve it."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_STYLIZED_ART_BOOST", "Higher efficiency when working on stylized visual asset creation tasks."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth, nil, nil, nil, nil)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})

local function createDesignTask(employee, designType, researchID, progressTime, workAmount)
	local taskObject = task.new("design_task")
	
	taskObject:setRequiredWork(workAmount or taskObject.DEFAULT_REQUIRED_WORK_AMOUNT)
	taskObject:setDesignType(designType)
	taskObject:setResearchID(researchID)
	taskObject:setWorkField("concept")
	taskObject:setAssignee(employee)
	
	local timeMult = 1
	local roleData = attributes.profiler:getRoleData(employee:getRole())
	
	if not roleData:hasCooldownPassed(employee) then
		timeMult = roleData:getBurnedOutTimePenalty(employee)
	end
	
	taskObject:setTimeToProgress((progressTime or taskObject.DEFAULT_TIME_TO_PROGRESS) * timeMult)
	
	return taskObject
end

local function attemptNotifyDelay(employee, designType)
	local roleData = attributes.profiler:getRoleData(employee:getRole())
	local questionID
	
	if timeline.curTime < roleData:getCooldownExpirationTime(employee) then
		local taskData = task:getData("design_task")
		
		if designType == taskData.TYPES.THEME then
			questionID = roleData.themeDesignCooldownQuestion
		else
			questionID = roleData.genreDesignCooldownQuestion
		end
	end
	
	if questionID then
		dialogueHandler:addDialogue(questionID, nil, employee)
		
		return true
	end
	
	return false
end

local function beginThemeResearch(self)
	if not self.employee:getWorkplace() then
		dialogueHandler:addDialogue("cant_design_themes_genres_no_workplace", nil, self.employee)
		
		return 
	end
	
	local taskData = task:getData("design_task")
	
	if attemptNotifyDelay(self.employee, taskData.TYPES.THEME) then
		return 
	end
	
	local roleData = attributes.profiler:getRoleData(self.employee:getRole())
	
	roleData:beginThemeDesign(self.employee)
end

local function beginGenreResearch(self)
	if not self.employee:getWorkplace() then
		dialogueHandler:addDialogue("cant_design_themes_genres_no_workplace", nil, self.employee)
		
		return 
	end
	
	local taskData = task:getData("design_task")
	
	if attemptNotifyDelay(self.employee, taskData.TYPES.GENRE) then
		return 
	end
	
	local roleData = attributes.profiler:getRoleData(self.employee:getRole())
	
	roleData:beginGenreDesign(self.employee)
end

attributes.profiler:registerRole({
	themeDesignCooldownQuestion = "theme_cooldown_start",
	burnedOutTimePenalty = 4.5,
	mainSkill = "concept",
	genreDesignCooldownQuestion = "genre_cooldown_start",
	flatIcon = "new_role_designer",
	roleIcon = "role_designer",
	id = "designer",
	femaleChance = 25,
	display = _T("DESIGNER", "Designer"),
	displayPlural = _T("DESIGNER_PLURAL", "Designers"),
	personDisplay = _T("DESIGNER_PERSON", "a designer"),
	inquiry = _T("DESIGNER_INQUIRY", "I take care of gameplay design and general concept when it comes to game projects. I can also design genres and come up with new themes for game projects."),
	description = _T("DESIGNER_DESCRIPTION", "This person's passion is designing gameplay. Designers learn how to design gameplay features at an accelerated rate.\n\nDesigners are necessary for designing game Themes and Genres."),
	startingAttribute = {
		{
			"vision",
			6
		}
	},
	designCooldown = timeline.DAYS_IN_MONTH * 6,
	init = function(self, employee)
		employee.researchedThemes = {}
		employee.researchedGenres = {}
	end,
	applyDesignCooldown = function(self, employee)
		employee.designCooldown = timeline.curTime
	end,
	getBurnedOutTimePenalty = function(self, employee)
		return self.burnedOutTimePenalty
	end,
	save = function(self, employee)
		return {
			researchedThemes = employee.researchedThemes,
			researchedGenres = employee.researchedGenres,
			designCooldown = employee.designCooldown
		}
	end,
	load = function(self, employee, data)
		employee.researchedThemes = data.researchedThemes or employee.researchedThemes
		employee.researchedGenres = data.researchedGenres or employee.researchedGenres
		employee.designCooldown = data.designCooldown or employee.designCooldown
		employee.designCooldownNotified = data.designCooldownNotified or employee.designCooldownNotified
	end,
	getCooldownExpirationTime = function(self, employee)
		if employee.designCooldown then
			return employee.designCooldown + self.designCooldown
		end
		
		return -self.designCooldown
	end,
	hasCooldownPassed = function(self, employee)
		return timeline.curTime >= self:getCooldownExpirationTime(employee)
	end,
	beginThemeDesign = function(self, employee)
		local themes = themes:getValidResearchThemes()
		local randomTheme = themes[math.random(1, #themes)]
		
		table.clear(themes)
		
		local taskData = task:getData("design_task")
		local taskObject = createDesignTask(employee, taskData.TYPES.THEME, randomTheme.id)
		
		employee:setTask(taskObject)
	end,
	beginGenreDesign = function(self, employee)
		local genres = genres:getValidResearchGenres()
		local randomGenre = genres[math.random(1, #genres)]
		
		table.clear(genres)
		
		local taskData = task:getData("design_task")
		local taskObject = createDesignTask(employee, taskData.TYPES.GENRE, randomGenre.id)
		
		employee:setTask(taskObject)
	end,
	fillInteractionComboBox = function(self, employee, comboBox)
		local task = employee:getTask()
		
		if not task or task:isDone() then
			if #themes:getValidResearchThemes() > 0 then
				local option = comboBox:addOption(0, 0, 0, 24, _T("DESIGN_NEW_THEME", "Design new theme"), fonts.get("pix20"), beginThemeResearch)
				
				option.employee = employee
			end
			
			if #genres:getValidResearchGenres() > 0 then
				local option = comboBox:addOption(0, 0, 0, 24, _T("DESIGN_NEW_GENRE", "Design new genre"), fonts.get("pix20"), beginGenreResearch)
				
				option.employee = employee
			end
		end
	end,
	skillAdvanceModifier = {
		graphics = 0.25,
		concept = 1.5,
		software = 0.25,
		sound = 0.25,
		writing = 0.5,
		management = 0.25
	}
})
require("game/developer/roles_designer_dialogues")

local function manageTeams(self)
	self.roleData:createManagementMenu(self.employee)
end

eventBoxText:registerNew({
	id = "auto_assigned_manager",
	getText = function(self, data)
		return _format(_T("AUTO_ASSIGNED_MANAGER_TO_TEAM", "Auto-assigned MANAGER to manage team 'TEAM'"), "MANAGER", names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4]), "TEAM", data.team)
	end
})
eventBoxText:registerNew({
	id = "manager_overloaded",
	getText = function(self, data)
		return _format(_T("MANAGER_OVERLOADED", "NAME is managing too many people and is unable to do it properly."), "NAME", names:getFullName(data[1], data[2], data[3], data[4]))
	end
})

local manager = attributes.profiler:registerRole({
	mainSkill = "management",
	involvementBonusPerDay = 2,
	interOfficePenaltyDecreaseMultiplier = 0.6,
	notEnoughInvolvementPenalty = 5,
	experiencePerPersonManaged = 6,
	experiencePerPersonExponent = 1.1,
	managementInterviewAffector = 0.2,
	mainAttribute = "charisma",
	baseManageExp = 10,
	id = "manager",
	minimumInvolvementTime = 14,
	charismaInterviewAffector = 2.5,
	aloneManagementBoostMaxPeople = 2,
	flatIcon = "new_role_manager",
	roleIcon = "role_manager",
	managementBoostWhenAlone = 0.5,
	femaleChance = 40,
	display = _T("MANAGER", "Manager"),
	displayPlural = _T("MANAGER_PLURAL", "Managers"),
	personDisplay = _T("MANAGER_PERSON", "a manager"),
	inquiry = _T("MANAGER_INQUIRY", "I manage teams, so that people that are part of them are more efficient at doing their jobs. I also keep track of how motivated people are, so if you ever want to find out how one of the teams I'm managing is doing - all you need to do is ask."),
	description = _T("MANAGER_DESCRIPTION", "This person prefers managing work. Managers are capable of getting the hang of project management much faster than others.\n\nManagers' main role is to be assigned to teams, which will provide a development speed boost as long as they are not overloaded with managing that team."),
	specDescription = _T("MANAGER_SPEC_DESCRIPTION", "Having managed people and their workflow for so long to the point where it almost comes naturally, the time has come for EMPLOYEE to choose a specialization."),
	startingAttribute = {
		{
			"charisma",
			6
		}
	},
	skillAdvanceModifier = {
		graphics = 0.25,
		concept = 0.25,
		software = 0.25,
		sound = 0.25,
		writing = 0.25,
		management = 1.5
	},
	onAway = function(self, employee)
		local teamObj = employee:getTeam()
		
		if teamObj and teamObj:getProject() then
			for key, member in ipairs(teamObj) do
				teamObj:updateTaskProgressAmount()
			end
		end
	end,
	init = function(self, employee)
		employee.managedTeams = {}
		employee.daysManaged = 0
		employee.managementBoosts = {}
		employee.managementBoostValues = {}
		employee.managementBoost = 1
		employee.managementLowPeopleCountBoost = 1
	end,
	setManagementBoost = function(self, employee, id, boost)
		if boost then
			if not employee.managementBoostValues[id] then
				employee.managementBoosts[#employee.managementBoosts + 1] = id
			end
			
			employee.managementBoostValues[id] = boost
		else
			table.removeObject(employee.managementBoosts, id)
			
			employee.managementBoostValues[id] = nil
		end
		
		employee.managementBoost = 1
		
		for key, id in ipairs(employee.managementBoosts) do
			employee.managementBoost = employee.managementBoost + employee.managementBoostValues[id]
		end
	end,
	onHired = function(self, employee)
		local employer = employee:getEmployer()
		
		if employer:isPlayer() then
			local manageablePeople = skills.registeredByID[employee:getMainSkill()]:getManageablePeopleAmount(employee)
			local bestTeam, memberDelta = nil, -math.huge
			
			for key, teamObj in ipairs(studio:getTeams()) do
				if not teamObj:getManager() then
					local memberCount = #teamObj:getMembers()
					
					if memberCount > 0 then
						local delta = manageablePeople - memberCount
						
						if delta > 0 and memberDelta < delta then
							bestTeam = teamObj
							memberDelta = delta
						end
					end
				end
			end
			
			if bestTeam then
				bestTeam:setManager(employee)
				game.addToEventBox("auto_assigned_manager", {
					name = {
						employee:getNameConfig()
					},
					team = bestTeam:getName()
				}, 1)
			end
		end
	end,
	onLeftStudio = function(self, employee)
		for key, managedTeam in ipairs(employee:getManagedTeams()) do
			employee:removeManagedTeam(managedTeam)
			managedTeam:setManager(nil)
		end
	end,
	setRoom = function(self, employee)
		self:verifyManagementBoost(employee, employee:getWorkplace())
	end,
	fillSuggestionList = function(self, employee, list, dialogueObject)
		if employee:getWorkplace() and not employee.managementBoostValues.lowPeopleCount then
			table.insert(list, "manager_lots_of_people_in_room")
		end
	end,
	fillConversationOptions = function(self, employee, list, dialogueObject)
		if #employee:getManagedTeams() > 0 then
			table.insert(list, "manager_ask_about_team_drive")
		end
		
		table.insert(list, "manager_ask_about_game_pricing")
	end,
	setWorkplace = function(self, employee, workplaceObject)
		self:verifyManagementBoost(employee, workplaceObject)
	end,
	verifyManagementBoost = function(self, employee, workplaceObject)
		if workplaceObject then
			local room = workplaceObject:getRoom()
			
			if room then
				if #room:getAssignedEmployees() - 1 <= self.aloneManagementBoostMaxPeople then
					self:setManagementBoost(employee, "lowPeopleCount", self.managementBoostWhenAlone)
				else
					self:setManagementBoost(employee, "lowPeopleCount", nil)
				end
			end
		end
	end,
	beginPricingResearch = function(self, employee, gameObj)
		local taskObject = task.new("price_research_task")
		
		taskObject:setRequiredWork(taskObject.DEFAULT_REQUIRED_WORK_AMOUNT)
		taskObject:setProject(gameObj)
		taskObject:setWorkField("management")
		taskObject:setAssignee(employee)
		taskObject:setTimeToProgress(taskObject.DEFAULT_TIME_TO_PROGRESS)
		employee:setTask(taskObject)
	end,
	save = function(self, employee)
		local saved = {}
		
		saved.managedTeams = {}
		saved.daysManaged = employee.daysManaged
		
		for key, teamObj in ipairs(employee.managedTeams) do
			saved.managedTeams[#saved.managedTeams + 1] = teamObj:getUniqueID()
		end
		
		return saved
	end,
	load = function(self, employee, data)
		employee.daysManaged = data.daysManaged
		employee.managedTeams = {}
		
		for key, teamID in ipairs(data.managedTeams) do
			employee.managedTeams[#employee.managedTeams + 1] = studio:getTeamByUniqueID(teamID)
		end
	end,
	onEvent = function(self, employee, event, ...)
		if event == timeline.EVENTS.NEW_DAY then
			local managedPeople = employee:getManagedMemberCount()
			
			if managedPeople > 0 then
				local expGained = self.baseManageExp + managedPeople * self.experiencePerPersonManaged^self.experiencePerPersonExponent
				
				skills:progressSkill(employee, self.mainSkill, expGained)
				self:increaseDaysManaged(employee)
			end
		elseif event == timeline.EVENTS.NEW_WEEK then
			self:checkManagingOverload(employee)
		elseif event == team.EVENTS.MANAGER_ASSIGNED then
			self:resetDaysManaged(employee)
		elseif event == developer.EVENTS.WORKPLACE_SET and select(1, ...) ~= employee then
			self:verifyManagementBoost(employee, employee:getWorkplace())
		end
	end,
	getInterviewEfficiency = function(self, interviewObj, manager)
		local targetProject = interviewObj:getTargetProject()
		
		manager = manager or interviewObj:getAssignedManager()
		
		local finalScore = 0
		
		finalScore = finalScore + manager:getAttribute(self.mainAttribute) * self.charismaInterviewAffector
		finalScore = finalScore + manager:getSkillLevel(self.mainSkill) * self.managementInterviewAffector
		
		local daysInvolved = manager:getProjectInvolvement(targetProject)
		local indevTime = targetProject:getDaysSinceStartOfWork()
		local delta = indevTime - daysInvolved
		
		if daysInvolved < self.minimumInvolvementTime then
			finalScore = finalScore - (self.minimumInvolvementTime - daysInvolved) * self.notEnoughInvolvementPenalty
		else
			local involvementEfficiencyMultiplier = math.min(math.min(0.5 * daysInvolved, 0.5) + daysInvolved / delta * (1 + daysInvolved / indevTime), 1)
			
			finalScore = finalScore + daysInvolved * self.involvementBonusPerDay * involvementEfficiencyMultiplier
		end
		
		for key, traitID in ipairs(manager.traits) do
			local traitData = traits.registeredByID[traitID]
			
			if traitData.interviewScoreAffector then
				finalScore = traitData:interviewScoreAffector(manager, finalScore)
			end
		end
		
		finalScore = math.max(interview.MINIMUM_REPUTATION_FROM_INTERVIEW, math.min(finalScore, interviewObj:getHighestPossibleScore()))
		
		return finalScore
	end,
	getInterOfficePenaltyDecrease = function(self, employee)
		return skills:getData(self.mainSkill):getManageablePeopleAmount(employee) * self.interOfficePenaltyDecreaseMultiplier
	end,
	resetDaysManaged = function(self, employee)
		employee.daysManaged = 0
	end,
	getDaysManaged = function(self, employee)
		return employee.daysManaged
	end,
	increaseDaysManaged = function(self, employee)
		employee.daysManaged = employee.daysManaged + 1
	end,
	checkManagingOverload = function(self, employee)
		if employee.daysManaged > developer.MANAGING_OVERLOAD_TIME_PERIOD then
			if skills:getData(self.mainSkill):isOverloaded(employee) then
				game.addToEventBox("manager_overloaded", {
					employee:getNameConfig()
				}, 3)
			end
			
			employee.daysManaged = 0
		end
	end,
	createManagementMenu = function(self, employee)
		game.openManagerAssignmentMenu(employee)
	end,
	fillInteractionComboBox = function(self, employee, comboBox)
		local text = _T("MANAGE_TEAMS", "Manage teams")
		local option = comboBox:addOption(0, 0, 0, 24, text, fonts.get("pix20"), manageTeams)
		
		option.roleData = self
		option.employee = employee
	end
})

manager:addSpecialization({
	id = "marketing",
	display = _T("SPECIALIZATION_MARKETING", "Marketing"),
	displayLong = _T("SPECIALIZATION_MARKETING_LONG", "Marketing specialist"),
	description = _T("SPECIALIZATION_MARKETING_DESCRIPTION", "Being an expert in marketing this person can add a 20% boost to Mass advertisement efficiency, so long as his project familiarity is at least 80%."),
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_MARKETING_BOOST", "20% higher Mass advertisement efficiency when within the assigned team and project familiarity is at least 80%."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})
manager:addSpecialization({
	id = "teamwork",
	managementBoost = 0.4,
	display = _T("SPECIALIZATION_TEAMWORK", "Teamwork"),
	displayLong = _T("SPECIALIZATION_TEAMWORK_LONG", "Teamwork specialist"),
	description = _T("SPECIALIZATION_TEAMWORK_DESCRIPTION", "An expert in management. Can manage 40% more people before getting overloaded."),
	applyToDeveloper = function(self, dev)
		manager:setManagementBoost(dev, "teamwork", self.managementBoost)
	end,
	setupDescbox = function(self, descBox, wrapWidth, scaledWrapWidth)
		descBox:addTextLine(scaledWrapWidth, attributes.profiler.SPECIALIZATION_BOOST_BACK_COLOR, nil)
		descBox:addText(_T("SPECIALIZATION_TEAMWORK_BOOST", "Can manage 40% more people."), "bh20", attributes.profiler.SPECIALIZATION_BOOST_TEXT_COLOR, 0, wrapWidth)
		self.baseClass.setupDescbox(self, descBox, wrapWidth, scaledWrapWidth)
	end
})
attributes.profiler:registerRole({
	roleIcon = "role_writer",
	mainSkill = "writing",
	flatIcon = "new_role_writer",
	id = "writer",
	femaleChance = 40,
	display = _T("WRITER", "Writer"),
	displayPlural = _T("WRITER_PLURAL", "Writers"),
	personDisplay = _T("WRITER_PERSON", "a writer"),
	inquiry = _T("WRITER_INQUIRY", "I'm a writer. Writing convincing game stories is my job."),
	description = _T("WRITER_DESCRIPTION", "Pen and paper is where this persons' heart is at. Writers are able to write engaging plots and storylines for games faster than others."),
	startingAttribute = {
		{
			"vision",
			6
		}
	},
	skillAdvanceModifier = {
		graphics = 0.25,
		concept = 0.25,
		software = 0.25,
		sound = 0.25,
		writing = 1.6,
		management = 0.25
	}
})
attributes.profiler:registerRole({
	roleIcon = "role_jackofalltrades",
	flatIcon = "new_role_joat",
	skillAdvanceOverallModifier = 2,
	id = "jackofalltrades",
	femaleChance = 10,
	display = _T("JACK_OF_ALL_TRADES", "Jack of all Trades"),
	displayPlural = _T("JACK_OF_ALL_TRADES_PLURAL", "Jacks of all Trades"),
	inquiry = _T("JACK_OF_ALL_TRADES_INQUIRY", "I take interest in every single facet of game development. So if someone goes on vacation, or is generally away from office, then in most cases I'll be able to take their task over, because I have experience in a lot of things."),
	personDisplay = _T("JACK_OF_ALL_TRADES_PERSON", "a jack of all trades"),
	description = _T("JACK_OF_ALL_TRADES_DESCRIPTION", "And master of none. This person takes interest in everything game development related and is equally good at learning every aspect of any field of work.\n\nBeing interested in everything, he can not focus on one skill and therefore will never reach master levels of experience in any field."),
	startingAttribute = {
		{
			"intelligence",
			3
		},
		{
			"vision",
			3
		}
	},
	skillAdvanceModifier = {
		graphics = 0.75,
		concept = 0.75,
		software = 0.75,
		sound = 0.75,
		writing = 0.75,
		management = 0.75
	},
	maxSkillLevels = {
		DEFAULT_TO = 80
	},
	init = function(self, employee)
		employee:setMaxSkillLevels(self.maxSkillLevels)
	end
})
attributes.profiler:registerRole({
	showSkillInfo = false,
	showEmployeeCount = false,
	invisible = true,
	flatIcon = "new_role_ceo",
	roleIcon = "role_ceo",
	id = "ceo",
	display = _T("CEO", "CEO"),
	inquiry = _T("CEO_INQUIRY", "lolol"),
	personDisplay = _T("CEO_PERSON", "the CEO"),
	description = _T("CEO_DESCRIPTION", "That's you! The CEO of this company!"),
	startingAttribute = {
		{
			"charisma",
			6
		}
	},
	skillAdvanceModifier = {
		graphics = 1,
		concept = 1,
		software = 1,
		sound = 1,
		writing = 1,
		management = 1
	}
})
