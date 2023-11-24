local freeplay = {}

freeplay.id = "freeplay"
freeplay.display = _T("FREEPLAY", "Freeplay")
freeplay.description = _T("FREEPLAY_DESCRIPTION", "Start out in the same circumstances on the selected map, but without any objective.\n\nWhen your player character retires you will be shown a recap of what you've achieved in those YEARS game-time years, with the ability to keep playing after that point.\n\nEnjoy freeplay with no hand-holding, supervision and set objective!")
freeplay.playerCharacterStartAge = 20
freeplay.playerCharacterFinishAge = 60
freeplay.playerCharacterLearnSpeedMultiplier = 3
freeplay.usersPerYear = 200000
freeplay.startingGenres = {
	"action",
	"adventure",
	"strategy"
}
freeplay.startingThemes = {
	"scifi",
	"fantasy"
}
freeplay.orderWeight = 200
freeplay.map = "story_mode"
freeplay.rivals = {
	"rival_company_1",
	"rival_company_2",
	"rival_company_3"
}
freeplay.unlockTechAtStartTime = true
freeplay.startingGeneratedEngines = 2
freeplay.extraEnginesPerYear = 0.2
freeplay.maxEngines = 10
freeplay.rivalBuildings = {
	rival_company_1 = "office_medium_6",
	rival_company_3 = "office_medium_8",
	rival_company_2 = "office_medium_7"
}
freeplay.mapConfigs = {
	{
		startMoney = 400000,
		file = "story_mode",
		name = _T("STORY_MODE_MAP", "Introduction"),
		rivals = {
			"rival_company_1",
			"rival_company_2",
			"rival_company_3"
		},
		rivalBuildings = {
			rival_company_1 = "office_medium_6",
			rival_company_3 = "office_medium_8",
			rival_company_2 = "office_medium_7"
		}
	},
	{
		startMoney = 400000,
		file = "back_in_the_game",
		name = _T("BACK_IN_THE_GAME_MAP", "Back in the Game"),
		rivals = {
			"back_in_the_game_1",
			"back_in_the_game_2",
			"back_in_the_game_3"
		},
		rivalBuildings = {
			back_in_the_game_2 = "back_in_the_game_office_2",
			back_in_the_game_3 = "back_in_the_game_office_4",
			back_in_the_game_1 = {
				"back_in_the_game_office_3",
				"office_medium_7"
			}
		},
		startingEmployees = {
			{
				role = "software_engineer",
				repeatFor = 2,
				level = {
					3,
					5
				}
			},
			{
				role = "software_engineer",
				level = 6
			},
			{
				role = "designer",
				level = 4
			},
			{
				role = "manager",
				level = 4
			},
			{
				role = "sound_engineer",
				level = 5
			},
			{
				role = "artist",
				level = 4
			}
		}
	},
	{
		startMoney = 500000,
		file = "pay_denbts",
		name = _T("PAY_DENBTS_MAP", "Pay Debts"),
		rivals = {
			"pay_denbts_1",
			"pay_denbts_2",
			"pay_denbts_3"
		},
		rivalBuildings = {
			pay_denbts_3 = "pay_denbts_office_4",
			pay_denbts_2 = "pay_denbts_office_3",
			pay_denbts_1 = {
				"pay_denbts_office_2",
				"pay_denbts_office_5"
			}
		},
		startingEmployees = {
			{
				role = "software_engineer",
				repeatFor = 2,
				level = {
					3,
					5
				}
			},
			{
				role = "software_engineer",
				level = 6
			},
			{
				role = "designer",
				level = 4
			},
			{
				role = "manager",
				level = 4
			},
			{
				role = "sound_engineer",
				level = 5
			},
			{
				role = "artist",
				level = 4
			}
		}
	},
	{
		startMoney = 200000,
		file = "ravioli_and_pepperoni",
		name = _T("RAVIOLI_AND_PEPPERONI_MAP", "Ravioli and Pepperoni"),
		rivals = {
			"ravioli_and_pepperoni_1"
		},
		rivalBuildings = {
			ravioli_and_pepperoni_1 = {
				"ravioli_and_pepperoni_1",
				"ravioli_and_pepperoni_2"
			}
		}
	},
	{
		startMoney = 1000000,
		file = "console_domination",
		name = _T("SCENARIO_4_NAME", "Console Domination"),
		rivals = {
			"console_domination_1",
			"console_domination_2",
			"console_domination_3"
		},
		startingEmployees = {
			{
				role = "software_engineer",
				level = 6
			},
			{
				role = "designer",
				level = 4
			},
			{
				role = "manager",
				level = 4
			},
			{
				role = "sound_engineer",
				level = 5
			},
			{
				role = "artist",
				level = 4
			}
		}
	}
}
freeplay.EVENTS = {
	SELECTED_MAP = events:new()
}
freeplay.startingYears = {
	timeline.baseYear,
	1995,
	2000,
	2005,
	2010
}
freeplay.startFundMultipliers = {
	0.25,
	0.5,
	0.75,
	1,
	1.1,
	1.2
}
freeplay.defaultFundsIndex = 4
freeplay.headerText = _T("RECOMMENDED_AFTER_ALL_SCENARIOS", "Recommended after all scenarios!")

function freeplay:formatDescription()
	return string.easyformatbykeys(self.description, "YEARS", self.playerCharacterFinishAge - self.playerCharacterStartAge)
end

function freeplay:handleEvent(event)
	if event == timeline.EVENTS.NEW_MONTH and self.playerCharacter:getAge() >= self.playerCharacterFinishAge then
	end
end

function freeplay:canStartGame()
	return self.selectedMap ~= nil and self.desiredYear ~= nil
end

function freeplay:setupInvalidityDescbox(descbox)
	if not self.selectedMap then
		descbox:addText(_T("FREEPLAY_NO_MAP_SELECTED", "You have not selected a map to play on."), "bh18", nil, 0, 300, "question_mark", 22, 22)
	end
	
	if not self.desiredYear then
		descbox:addText(_T("FREEPLAY_NO_STARTING_YEAR_SELECTED", "You have not selected the starting year."), "bh18", nil, 0, 300, "question_mark", 22, 22)
	end
end

function freeplay:getStartingTime()
	return {
		month = 1,
		year = self.startingYears[self.desiredYear]
	}
end

function freeplay:begin()
	self:setupStartingTime()
	characterDesigner:begin()
end

function freeplay:postStart()
	freeplay.baseClass.postStart(self)
	game.setCanRetire(self.canRetire)
end

function freeplay:postStartCallback()
	engineLicensing:generateEngines(self.startingGeneratedEngines + math.min(self.maxEngines, math.floor((timeline:getYear() - timeline.baseYear) * self.extraEnginesPerYear)))
end

function freeplay:setSelectedMap(mapID)
	self.selectedMap = mapID
	
	events:fire(freeplay.EVENTS.SELECTED_MAP, self)
end

function freeplay:getSelectedMap()
	return self.selectedMap
end

function freeplay:getMapConfigs()
	return self.mapConfigs
end

function freeplay:getFundMultipliers()
	return self.startFundMultipliers
end

function freeplay:setStartingYear(yearID)
	self.desiredYear = yearID
end

function freeplay:getStartingYear()
	return self.desiredYear
end

function freeplay:onDeselected()
	for key, button in ipairs(self.buttons) do
		button:kill()
		
		self.buttons[key] = nil
	end
end

function freeplay:setStartWithEmployees(state)
	self.startingEmployees = state
end

function freeplay:getStartWithEmployees()
	return self.startingEmployees
end

function freeplay:onSelected(descbox)
	self.selectedMap = nil
	self.desiredYear = nil
	self.startingEmployees = true
	self.canRetire = true
	self.startingFundsIndex = self.defaultFundsIndex
	self.buttons = {}
	
	local buttonWidth = _US(descbox.rawW / 2 - 5)
	local parent = descbox:getParent()
	local mapButton = gui.create("MapSelectionButton", parent)
	
	mapButton:setPos(descbox.localX, descbox.localY + descbox.h + _S(5))
	mapButton:setSize(buttonWidth, 25)
	mapButton:setFont("pix22")
	mapButton:setGametypeData(self)
	mapButton:setMapConfig(self.mapConfigs)
	mapButton:updateText()
	
	self.buttons[#self.buttons + 1] = mapButton
	
	local yearButton = gui.create("StartingYearSelectButton", parent)
	
	yearButton:setPos(mapButton.localX, mapButton.localY + mapButton.h + _S(5))
	yearButton:setSize(buttonWidth, 25)
	yearButton:setFont("pix22")
	yearButton:setGametypeData(self)
	yearButton:setYearList(self.startingYears)
	yearButton:updateText()
	
	self.buttons[#self.buttons + 1] = yearButton
	
	local startButton = gui.create("StartingFundsButton", parent)
	
	startButton:setPos(mapButton.localX, yearButton.localY + yearButton.h + _S(5))
	startButton:setSize(buttonWidth, 25)
	startButton:setFont("bh20")
	startButton:setGametypeData(self)
	startButton:setMultiplierList(self:getFundMultipliers())
	startButton:updateText()
	
	self.buttons[#self.buttons + 1] = startButton
	
	local employeesCheckbox = gui.create("StartWithEmployeesCheckbox", parent)
	
	employeesCheckbox:setPos(mapButton.localX + startButton.w + _S(5), mapButton.localY)
	employeesCheckbox:setFont("bh20")
	employeesCheckbox:setGametypeData(self)
	employeesCheckbox:setText(_T("START_WITH_EMPLOYEES", "Start with employees"))
	employeesCheckbox:setSize(25, 25)
	
	self.buttons[#self.buttons + 1] = employeesCheckbox
	
	local retireCheckbox = gui.create("EmployeeRetirementCheckbox", parent)
	
	retireCheckbox:setPos(employeesCheckbox.localX, employeesCheckbox.localY + employeesCheckbox.h + _S(5))
	retireCheckbox:setFont("bh20")
	retireCheckbox:setGametypeData(self)
	retireCheckbox:setText(_T("EMPLOYEES_RETIRE", "Employees retire"))
	retireCheckbox:setSize(25, 25)
	
	self.buttons[#self.buttons + 1] = retireCheckbox
end

function freeplay:setStartingFunds(index)
	self.startingFundsIndex = index
end

function freeplay:getStartingFunds()
	return self.startingFundsIndex
end

function freeplay:setRetirement(state)
	self.canRetire = state
end

function freeplay:getRetirement()
	return self.canRetire
end

function freeplay:getMap()
	return self.mapConfigs[self.selectedMap].file
end

function freeplay:getRivals(mapID)
	if mapID then
		for key, data in ipairs(self.mapConfigs) do
			if data.file == mapID then
				return data.rivals
			end
		end
	end
	
	return self.mapConfigs[self.selectedMap].rivals
end

function freeplay:getRivalBuildings()
	return self.mapConfigs[self.selectedMap].rivalBuildings
end

function freeplay:getStartingEmployees()
	if not self.startingEmployees then
		return nil
	end
	
	return self.mapConfigs[self.selectedMap].startingEmployees
end

function freeplay:fillOptionsMenu(generalPanel)
	local retireCheckbox = gui.create("EmployeeRetirementCheckbox", generalPanel)
	
	retireCheckbox:setFont("bh20")
	retireCheckbox:setGametypeData(self)
	retireCheckbox:setText("")
	retireCheckbox:setSize(25, 25)
	mainMenu:addOptionCombo(_T("EMPLOYEES_RETIRE", "Employees retire"), retireCheckbox)
end

function freeplay:getStartingMoney()
	return self.mapConfigs[self.selectedMap].startMoney * self.startFundMultipliers[self.startingFundsIndex]
end

function freeplay:startCallback()
	self:unlockStartingTech()
	
	local employee = characterDesigner:getEmployee()
	
	employee:setOverallSkillProgressionMultiplier(self.playerCharacterLearnSpeedMultiplier)
	characterDesigner:finish()
	self:giveStartingThemesGenres()
	self:setupStartingRivals()
	
	self.playerCharacter = employee
	
	studio:setFunds(self:getStartingMoney())
	self:giveStartingEmployees()
	game.logStartedCampaign(self.id)
end

function freeplay:save(saved)
	saved.canRetire = game.getCanRetire()
	
	return saved
end

function freeplay:load(data)
	if data.canRetire == nil then
		game.setCanRetire(true)
	else
		game.setCanRetire(data.canRetire)
	end
	
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:isPlayerCharacter() then
			self.playerCharacter = employee
			
			break
		end
	end
end

game.registerGameType(freeplay)
