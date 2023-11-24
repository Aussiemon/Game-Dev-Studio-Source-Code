local contr = {
	devDifficulty = 0.1,
	devCostMult = 1,
	gameScale = 0,
	quad = "platform_controller_1",
	attractiveness = 5,
	devTime = 40,
	id = "controller_1",
	price = 15,
	partType = platformParts.TYPES.CONTROLLER,
	display = _T("PLATFORM_CONTROLLER_1", "Controller - versatile"),
	genreMatch = {
		fighting = 0.8,
		racing = 1.05,
		action = 1,
		sandbox = 0.8,
		strategy = 0.7,
		simulation = 0.8,
		horror = 1.15,
		adventure = 1.05,
		rpg = 1.05
	}
}

function contr:setupDescboxInfo(descbox, wrapWidth)
	contr.baseClass.setupDescboxInfo(self, descbox, wrapWidth)
	
	local matches = self.genreMatch
	
	descbox:addSpaceToNextText(5)
	descbox:addText(_T("PLATFORM_GENRE_MATCHING", "Genre-platform matching:"), "bh20", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth)
	descbox:addSpaceToNextText(5)
	
	for key, data in ipairs(genres.registered) do
		local signs, clr = game.getContributionSign(1, matches[data.id], 0.05, 3, nil, nil, nil)
		
		descbox:addText(signs .. " " .. data.display, "pix18", clr, 0, 700, genres:getGenreUIIconConfig(data, 20, 20, 18))
	end
end

function contr:apply(platformObj)
	platformObj:setGenreMatch(self.genreMatch)
end

platformParts:registerNew(contr)
platformParts:registerNew({
	devDifficulty = 0.1,
	devCostMult = 1,
	gameScale = 0,
	quad = "platform_controller_2",
	attractiveness = 5,
	devTime = 40,
	id = "controller_2",
	price = 15,
	partType = platformParts.TYPES.CONTROLLER,
	display = _T("PLATFORM_CONTROLLER_2", "Controller - precise"),
	genreMatch = {
		fighting = 1,
		racing = 1.05,
		action = 1.15,
		sandbox = 1.05,
		strategy = 1.15,
		simulation = 1.05,
		horror = 0.7,
		adventure = 0.8,
		rpg = 1
	}
}, "controller_1")
platformParts:registerNew({
	devDifficulty = 0.1,
	devCostMult = 1,
	gameScale = 0,
	quad = "platform_controller_3",
	attractiveness = 5,
	devTime = 40,
	id = "controller_3",
	price = 15,
	partType = platformParts.TYPES.CONTROLLER,
	display = _T("PLATFORM_CONTROLLER_3", "Controller - multitask"),
	genreMatch = {
		fighting = 0.7,
		racing = 1.05,
		action = 0.8,
		sandbox = 1.15,
		strategy = 1.05,
		simulation = 1.05,
		horror = 0.8,
		adventure = 1,
		rpg = 1.15
	}
}, "controller_1")
