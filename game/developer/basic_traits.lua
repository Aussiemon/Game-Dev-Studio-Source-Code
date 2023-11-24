local iconSpacing = 8

traits:registerNew({
	discoveryLevel = 4,
	quad = "trait_workaholic",
	salaryMultiplier = 1.1,
	driveLossMultiplier = 0.75,
	selectableForPlayer = false,
	id = "workaholic",
	interOfficePenaltyDivider = 0.2,
	display = _T("WORKAHOLIC", "Workaholic"),
	description = _T("WORKAHOLIC_DESCRIPTION", "Loses drive slowly, but asks for a higher pay.\nManagers with this trait will further decrease the inter-office development speed penalty."),
	assignTrait = function(self, target)
		target:setDriveLossSpeedMultiplier(self.id, self.driveLossMultiplier)
		target:setSalaryMultiplier(self.salaryMultiplier)
		target:setInterOfficePenaltyDivider(self.interOfficePenaltyDivider)
	end,
	conflictingTraits = {
		lazy = true,
		unmotivated = true,
		slacker = true,
		procrastinator = true
	},
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("WORKAHOLIC_AFFECTOR_1", "MULT% slower Drive decrease"), "MULT", math.round((1 - self.driveLossMultiplier) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		
		if employee:getRoleData().id == "manager" then
			descBox:addText(_format(_T("WORKAHOLIC_AFFECTOR_2", "REDUCT% reduced inter-office penalty"), "REDUCT", math.round(self.interOfficePenaltyDivider * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		end
		
		descBox:addText(_format(_T("WORKAHOLIC_AFFECTOR_3", "MULT% higher salary"), "MULT", math.round((self.salaryMultiplier - 1) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	issueGenerateChanceMultiplier = 1.1,
	quad = "trait_hyper",
	discoveryLevel = 3,
	id = "hyper",
	developSpeedMultiplier = 1.15,
	display = _T("HYPER", "Hyper"),
	description = _T("HYPER_DESCRIPTION", "Develops faster, however has a higher chance of generating issues."),
	conflictingTraits = {
		lazy = true,
		perfectionist = true,
		procrastinator = true,
		unmotivated = true,
		slacker = true,
		bug_magnet = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
		target:setIssueGenerateChanceMultiplier(self.id, self.issueGenerateChanceMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("HYPER_AFFECTOR_1", "MULT% faster development speed"), "MULT", math.round((self.developSpeedMultiplier - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("HYPER_AFFECTOR_2", "MULT% more issues generated"), "MULT", math.round((self.issueGenerateChanceMultiplier - 1) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	issueGenerateChanceMultiplier = 0.55,
	quad = "hud_objectives",
	discoveryLevel = 4,
	id = "perfectionist",
	developSpeedMultiplier = 0.85,
	display = _T("PERFECTIONIST", "Perfectionist"),
	description = _T("PERFECTIONIST_DESCRIPTION", "Has a much lower chance of generating issues when developing, at the expense of working slower."),
	conflictingTraits = {
		hyper = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
		target:setIssueGenerateChanceMultiplier(self.id, self.issueGenerateChanceMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("PERFECTIONIST_AFFECTOR_1", "MULT% less issues generated"), "MULT", math.round((1 - self.issueGenerateChanceMultiplier) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("PERFECTIONIST_AFFECTOR_2", "MULT% slower development speed"), "MULT", math.round((1 - self.developSpeedMultiplier) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	discoveryLevel = 6,
	quad = "trait_engine_designer",
	projectType = "engine",
	selectableForPlayer = false,
	id = "engine_designer",
	speedMultiplierAdd = 0.1,
	display = _T("ENGINE_DESIGNER", "Engine Designer"),
	description = _T("ENGINE_DESIGNER_DESCRIPTION", "Is efficient at developing game engines."),
	roleRequirement = {
		"software_engineer",
		"jackofalltrades"
	},
	getDevSpeedModifier = function(self, target, project)
		return project and project.PROJECT_TYPE == self.projectType and self.speedMultiplierAdd or 0
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("ENGINE_DESIGNER_AFFECTOR", "MULT% faster engine development speed"), "MULT", math.round(self.speedMultiplierAdd * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
	end
})
traits:registerNew({
	selectableForPlayer = false,
	quad = "trait_game_designer",
	projectType = "game",
	discoveryLevel = 6,
	id = "game_designer",
	speedMultiplierAdd = 0.05,
	display = _T("GAME_DESIGNER", "Game Designer"),
	description = _T("GAME_DESIGNER_DESCRIPTION", "Is efficient at developing games."),
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("GAME_DESIGNER_AFFECTOR", "MULT% faster game development speed"), "MULT", math.round(self.speedMultiplierAdd * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
	end
}, "engine_designer")
traits:registerNew({
	gameConventionScoreMultiplier = 1.15,
	quad = "trait_silver_tongue",
	damageControlEfficiencyMultiplier = 1.2,
	discoveryLevel = 4,
	id = "silver_tongue",
	motivationalSpeechScoreMultiplier = 1.3,
	display = _T("SILVER_TONGUE", "Silver Tongue"),
	description = _T("SILVER_TONGUE_DESCRIPTION", "Can handle anything PR-related, and perform damage control with greater ease than others."),
	assignTrait = function(self, target)
	end,
	adjustMotivationalSpeechScore = function(self, speaker, baseScore)
		return baseScore * self.motivationalSpeechScoreMultiplier
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("SILVER_TONGUE_AFFECTOR_1", "MULT% higher game convention boost"), "MULT", math.round((self.gameConventionScoreMultiplier - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("SILVER_TONGUE_AFFECTOR_2", "MULT% better damage control"), "MULT", math.round((self.damageControlEfficiencyMultiplier - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		
		if employee:isPlayerCharacter() then
			descBox:addText(_format(_T("SILVER_TONGUE_AFFECTOR_3", "MULT% more efficient motivational speeches"), "MULT", math.round((self.motivationalSpeechScoreMultiplier - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
			descBox:addSpaceToNextText(4)
			descBox:addText(_T("SILVER_TONGUE_AFFECTOR_4", "Improved interaction with employees in specific contexts"), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "exclamation_point", 24, 24)
		end
	end,
	adjustGameConventionScore = function(self, employee, baseScore)
		return baseScore + self.gameConventionScoreMultiplier - 1
	end
})
traits:registerNew({
	issueDiscoverChanceMultiplier = 1.2,
	issueGenerateChanceMultiplier = 0.8,
	quad = "trait_bug_magnet",
	discoveryLevel = 5,
	id = "bug_magnet",
	developSpeedMultiplier = 0.9,
	display = _T("BUG_MAGNET", "Bug Magnet"),
	description = _T("BUG_MAGNET_DESCRIPTION", "Discovers more and generates less issues during development, but works a tad slower than others."),
	conflictingTraits = {
		hyper = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
		target:setIssueGenerateChanceMultiplier(self.id, self.issueGenerateChanceMultiplier)
		target:setIssueDiscoverChanceMultiplier(self.id, self.issueDiscoverChanceMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("BUG_MAGNET_AFFECTOR_1", "MULT% less issues generated"), "MULT", math.round((1 - self.issueGenerateChanceMultiplier) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("BUG_MAGNET_AFFECTOR_2", "MULT% more issues discovered"), "MULT", math.round((self.issueDiscoverChanceMultiplier - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("BUG_MAGNET_AFFECTOR_3", "MULT% slower development speed"), "MULT", math.round((1 - self.developSpeedMultiplier) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	discoveryLevel = 4,
	selectableForPlayer = false,
	quad = "trait_autonomous",
	id = "autonomous",
	display = _T("AUTONOMOUS", "Autonomous"),
	description = _T("AUTONOMOUS_DESCRIPTION", "Lack of management in a team does not cause this employee to work much slower when low on drive."),
	assignTrait = function(self, target)
		target:setNoManagementDevSpeedAffector(self.id, 1)
	end
})
traits:registerNew({
	discoveryLevel = 6,
	quad = "trait_asocial",
	baseOverallEfficiency = 1.1,
	selectableForPlayer = false,
	id = "asocial",
	maxPeopleUntilEfficiencyDrop = 5,
	display = _T("ASOCIAL", "Asocial"),
	conflictingTraits = {
		extraverted = true
	},
	description = _T("ANTISOCIAL_DESCRIPTION", "Efficiency drops faster when a lot of other people are in the same room, but is more efficient than others when there are few people in the same room."),
	assignTrait = function(self, target)
		target.maxPeopleUntilEfficiencyDrop = self.maxPeopleUntilEfficiencyDrop
		target.baseOverallEfficiency = self.baseOverallEfficiency
		
		target:calculateOverallEfficiency()
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("ASOCIAL_AFFECTOR_1", "MULT% faster development speed"), "MULT", math.round((self.baseOverallEfficiency - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("ASOCIAL_AFFECTOR_2", "MAX people in room before efficiency drop"), "MAX", self.maxPeopleUntilEfficiencyDrop), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	discoveryLevel = 3,
	id = "extraverted",
	quad = "trait_extraverted",
	selectableForPlayer = false,
	expoDriveDropMultiplier = 0,
	maxPeopleUntilEfficiencyDrop = 40,
	display = _T("EXTRAVERTED", "Extraverted"),
	conflictingTraits = {
		asocial = true
	},
	description = _T("EXTRAVERTED_DESCRIPTION", "Efficiency drops slower when a lot of people are in the same room, game conventions do not tire out the employee."),
	assignTrait = function(self, target)
		target.maxPeopleUntilEfficiencyDrop = self.maxPeopleUntilEfficiencyDrop
		
		target:setExpoDriveDropMultiplier(self.expoDriveDropMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("EXTRAVERTED_AFFECTOR", "MAX people in room before efficiency drop"), "MAX", self.maxPeopleUntilEfficiencyDrop), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
	end
})
traits:registerNew({
	discoveryLevel = 4,
	selectableForPlayer = false,
	quad = "trait_bookworm",
	driveLossMultiplier = 1.1,
	experienceGainMultiplier = 1.1,
	id = "bookworm",
	display = _T("BOOKWORM", "Bookworm"),
	description = _T("BOOKWORM_DESCRIPTION", "Books provide a greater boost in experience gained, but loses drive faster than usual if placed in a room with no books or empty bookshelves."),
	onEvent = function(self, target, event)
		self:evaluateRoom(target, target:getRoom())
	end,
	fillSuggestionList = function(self, employee, list, dialogueObject)
		local mult = employee:getSpecificDriveLossSpeedMultiplier(self.id)
		
		if mult and mult ~= 1 then
			table.insert(list, "developer_no_bookshelves_suggestion")
		end
	end,
	evaluateRoom = function(self, target, roomObject)
		local driveLossSpeedModifier = 1
		
		if roomObject then
			local found = false
			local objects = roomObject:getObjectsOfType("bookshelf")
			
			if objects then
				for key, object in ipairs(objects) do
					if #object:getStoredBooks() > 0 then
						found = true
						
						break
					end
				end
			end
			
			if not found then
				driveLossSpeedModifier = self.driveLossMultiplier
			end
		end
		
		target:setDriveLossSpeedMultiplier(self.id, driveLossSpeedModifier)
		
		if driveLossSpeedModifier == 1 then
			target:getAvatar():removeStatusIcon("no_books")
		else
			target:getAvatar():addStatusIcon("no_books")
		end
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("BOOKWORM_AFFECTOR_1", "MULT% more experience from books"), "MULT", math.round((self.experienceGainMultiplier - 1) * 100, 1)), font, game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_format(_T("BOOKWORM_AFFECTOR_2", "MULT% faster Drive loss when in room with no books"), "MULT", math.round((self.driveLossMultiplier - 1) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end,
	onRoomChanged = function(self, target, roomObject)
		self:evaluateRoom(target, roomObject)
	end,
	assignTrait = function(self, target)
		target:setBookExperienceGainModifier(self.id, self.experienceGainMultiplier)
	end
})
dialogueHandler.registerQuestion({
	id = "developer_no_bookshelves_suggestion",
	text = _T("DEVELOPER_NO_BOOKSHELVES_SUGGESTION", "I love reading books, and not just the fantasy ones! So the lack of books in the office somewhat upsets me. If you could get a bookshelf in the office and fill it with some books - any books - that would be great."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
traits:registerNew({
	selectableForPlayer = false,
	chance = 50,
	quad = "trait_procrastinator",
	discoveryLevel = 8,
	id = "procrastinator",
	developSpeedMultiplier = 0.95,
	display = _T("PROCRASTINATOR", "Procrastinator"),
	description = _T("PROCRASTINATOR_DESCRIPTION", "Don't rush it, there's tons of time left."),
	conflictingTraits = {
		lazy = true,
		hyper = true,
		slacker = true,
		unmotivated = true,
		workaholic = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("SLACKER_AFFECTOR_1", "MULT% slower development speed"), "MULT", math.round((1 - self.developSpeedMultiplier) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	chance = 40,
	selectableForPlayer = false,
	quad = "trait_unmotivated",
	discoveryLevel = 7,
	id = "unmotivated",
	developSpeedMultiplier = 0.9,
	display = _T("UNMOTIVATED", "Unmotivated"),
	conflictingTraits = {
		lazy = true,
		hyper = true,
		workaholic = true,
		procrastinator = true,
		slacker = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addText(_format(_T("UNMOTIVATED_DESCRIPTION", "'I just wish I could go home already' - NAME, YEAR."), "NAME", employee:getFullName(true), "YEAR", timeline:getYear()), "pix20", nil, 0, wrapWidth)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("SLACKER_AFFECTOR_1", "MULT% slower development speed"), "MULT", math.round((1 - self.developSpeedMultiplier) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	id = "lazy",
	discoveryLevel = 6,
	quad = "trait_lazy",
	selectableForPlayer = false,
	chance = 30,
	developSpeedMultiplier = 0.85,
	display = _T("LAZY", "Lazy"),
	description = _T("LAZY_DESCRIPTION", "Why work when you can just take it easy and relax?"),
	conflictingTraits = {
		workaholic = true,
		hyper = true,
		procrastinator = true,
		unmotivated = true,
		slacker = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("SLACKER_AFFECTOR_1", "MULT% slower development speed"), "MULT", math.round((1 - self.developSpeedMultiplier) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
traits:registerNew({
	id = "slacker",
	discoveryLevel = 5,
	quad = "trait_slacker",
	selectableForPlayer = false,
	chance = 20,
	developSpeedMultiplier = 0.8,
	display = _T("SLACKER", "Slacker"),
	description = _T("SLACKER_DESCRIPTION", "Work smarter, not harder... And slower... And with less effort..."),
	conflictingTraits = {
		lazy = true,
		hyper = true,
		procrastinator = true,
		unmotivated = true,
		workaholic = true
	},
	assignTrait = function(self, target)
		target:setDevelopSpeedMultiplier(self.id, self.developSpeedMultiplier)
	end,
	formatDescriptionText = function(self, descBox, employee, wrapWidth, font)
		descBox:addSpaceToNextText(iconSpacing)
		descBox:addText(_format(_T("SLACKER_AFFECTOR_1", "MULT% slower development speed"), "MULT", math.round((1 - self.developSpeedMultiplier) * 100, 1)), font, game.UI_COLORS.RED, 0, wrapWidth, "decrease_red", 22, 22)
	end
})
