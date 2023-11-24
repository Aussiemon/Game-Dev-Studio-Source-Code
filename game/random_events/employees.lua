local parentDeath = {}

parentDeath.id = "parent_death"
parentDeath.eventRequirement = timeline.EVENTS.NEW_DAY
parentDeath.rollMin = 1
parentDeath.rollMax = 10000
parentDeath.occurChance = 1
parentDeath.awayDuration = 2
parentDeath.validEmployees = {}
parentDeath.fact_baselineAge = 20
parentDeath.fact_deathChance = 20
parentDeath.fact_chancePerYear = 1.75
parentDeath.formatTable = {}
parentDeath.popupText = _T("RELATIVE_DEATH_DESC", "A relative of NAME SURNAME has died. They have taken leave for TIMETEXT.")
parentDeath.popupTitle = _T("RELATIVE_DEATH", "Death of relative")

function parentDeath:occur()
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:isAvailable() and not employee:getFact(self.id) and not employee:isPlayerCharacter() then
			table.insert(self.validEmployees, employee)
		end
	end
	
	if #self.validEmployees > 0 then
		local randomIndex = math.random(1, #self.validEmployees)
		local randomEmployee = self.validEmployees[randomIndex]
		
		randomEmployee:setFact(self.id, true)
		randomEmployee:setAwayUntil(timeline.curTime + self.awayDuration)
		
		self.formatTable.NAME = randomEmployee:getName()
		self.formatTable.SURNAME = randomEmployee:getSurname()
		self.formatTable.TIMETEXT = timeline:getTimePeriodText(self.awayDuration)
		
		local popup = gui.create("Popup")
		
		popup:setWidth(400)
		popup:centerX()
		popup:setTextFont(fonts.get("pix20"))
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(self.popupTitle)
		popup:setText(string.formatbykeys(self.popupText, self.formatTable))
		popup:setDepth(105)
		popup:addButton(fonts.get("pix20"), "OK")
		popup:performLayout()
		popup:centerY()
		frameController:push(popup)
	end
	
	table.clear(self.validEmployees)
end

function parentDeath:validateFact(employee)
	local yearAffector = math.max(employee:getAge() - self.fact_baselineAge, 0) * self.fact_chancePerYear
	local factChance = self.fact_deathChance + yearAffector
	
	if factChance >= math.random(1, 100) then
		employee:setFact(self.id, true)
	end
end

randomEvents:registerNew(parentDeath)

local ownGoals = {}

ownGoals.id = "pursue_own_goals"
ownGoals.prerequiredFact = "can_leave_to_pursue_goals"
ownGoals.eventRequirement = timeline.EVENTS.NEW_MONTH
ownGoals.unemployableTime = {
	timeline.DAYS_IN_YEAR,
	timeline.DAYS_IN_YEAR * 5
}
ownGoals.validEmployees = {}
ownGoals.baseRequiredMoney = 40000
ownGoals.rollMin = 1
ownGoals.rollMax = 1500
ownGoals.occurChance = 1
ownGoals.leaveMaxRoll = 30000
ownGoals.leaveBaseChance = 1
ownGoals.extraChancePerExtraMoney = 20000
ownGoals.baseLeaveChance = 10
ownGoals.popupText = _T("LEFT_TO_PURSUE_OWN_GOALS_DESC", "NAME has left the studio to develop their own games.")
ownGoals.popupTitle = _T("LEFT_TO_PURSUE_OWN_GOALS_TITLE", "Leaving the studio")
ownGoals.leaveReason = _T("LEAVE_REASON_LEFT_TO_PURSUE_OWN_GOALS", "They said that they're leaving to work on their own projects full-time.")

function ownGoals:isValidEmployee(employee)
	if employee:isAvailable() and math.random(1, self.leaveMaxRoll) <= self:getOccurChance(employee) and not employee:getFact(self.prerequiredFact) and not employee:getFact(self.id) and not employee:isPlayerCharacter() then
		return true
	end
	
	return false
end

function ownGoals:getOccurChance(employee)
	local funds = employee:getFunds()
	
	if funds < self.baseRequiredMoney then
		return 0
	end
	
	return self.leaveBaseChance + funds / self.extraChancePerExtraMoney
end

function ownGoals:occur()
	for key, employee in ipairs(studio:getEmployees()) do
		if self:isValidEmployee(employee) then
			table.insert(self.validEmployees, employee)
		end
	end
	
	if #self.validEmployees > 0 then
		local randomIndex = math.random(1, #self.validEmployees)
		local randomEmployee = self.validEmployees[randomIndex]
		
		randomEmployee:setFact(self.id, true)
		dialogueHandler:addDialogue("employee_leaves_to_work_on_own_projects", nil, randomEmployee)
	end
	
	table.clearArray(self.validEmployees)
end

function ownGoals:validateFact(employee)
	if math.random(1, 100) <= ownGoals.baseLeaveChance then
		employee:setFact(ownGoals.prerequiredFact, true)
	end
	
	employee:setFact(ownGoals.prerequiredFact, false)
end

randomEvents:registerNew(ownGoals)
require("game/dialogue/developer/leave_to_work_on_own_projects")

local fallIll = {}

fallIll.id = "fall_ill"
fallIll.eventRequirement = timeline.EVENTS.NEW_DAY
fallIll.rollMin = 1
fallIll.rollMax = 1000
fallIll.occurChance = 1
fallIll.awayDuration = {
	5,
	10
}
fallIll.validEmployees = {}
fallIll.immunityFact = "immune_to_illness"
fallIll.immunityChance = 50
fallIll.immunityDuration = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH
fallIll.popupTitle = _T("EMPLOYEE_FELL_ILL_TITLE", "Illness")
fallIll.content = _T("EMPLOYEE_FELL_ILL", "EMPLOYEE has fallen ill.\nHe has taken sick leave and will be back in office in TIME_TEXT.")

function fallIll:occur()
	local curTime = timeline.curTime
	
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:isAvailable() and not employee:getFact(self.id) and not employee:isPlayerCharacter() then
			local immunity = employee:getFact(self.immunityFact)
			
			if not immunity or immunity < curTime then
				table.insert(self.validEmployees, employee)
			end
		end
	end
	
	if #self.validEmployees > 0 then
		local randomIndex = math.random(1, #self.validEmployees)
		local randomEmployee = self.validEmployees[randomIndex]
		local awayDuration = math.random(self.awayDuration[1], self.awayDuration[2])
		
		randomEmployee:setAwayUntil(timeline.curTime + awayDuration)
		
		local text = string.easyformatbykeys(self.content, "EMPLOYEE", randomEmployee:getFullName(true), "TIME_TEXT", timeline:getTimePeriodText(awayDuration))
		local popup = gui.create("Popup")
		
		popup:setWidth(400)
		popup:centerX()
		popup:setTextFont(fonts.get("pix20"))
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(self.popupTitle)
		popup:setText(text)
		popup:setDepth(105)
		popup:addOKButton("pix20")
		popup:performLayout()
		popup:centerY()
		randomEmployee:setFact(self.id, true)
		
		if math.random(1, 100) <= self.immunityChance then
			randomEmployee:setFact(self.immunityFact, timeline.curTime + self.immunityDuration + awayDuration)
		end
		
		frameController:push(popup)
	end
	
	table.clearArray(self.validEmployees)
end

randomEvents:registerNew(fallIll)

local employeeDeath = {}

employeeDeath.id = "employee_death"
employeeDeath.eventRequirement = timeline.EVENTS.NEW_WEEK
employeeDeath.validDeathReasons = {}
employeeDeath.rollMin = 1
employeeDeath.rollMax = 1
employeeDeath.occurChance = 1
employeeDeath.causes = {
	{
		hospitalisedChance = 80,
		occurChance = 22222,
		hospitalisationDuration = timeline.DAYS_IN_MONTH,
		occurTitleHospitalised = _T("EMPLOYEE_HOSPITALISED_TITLE", "Employee Hospitalised"),
		occurTitleDeath = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurText = {
			death = {
				_T("EMPLOYEE_BEATEN_UP_DEATH_1", "NAME has been found killed. It seems they were beaten to death."),
				_T("EMPLOYEE_BEATEN_UP_DEATH_2", "NAME has died. They fell victim to a robbery."),
				_T("EMPLOYEE_BEATEN_UP_DEATH_3", "NAME was found dead. The exact reason for their death is unknown.")
			},
			hospitalised = {
				_T("EMPLOYEE_BEATEN_UP_HOSPITALISED_1", "NAME has been found brutally beaten. They will have to spend a month in the hospital under intensive care.")
			}
		},
		occurFunc = function(self, target)
			local text = self.occurText
			
			if math.random(1, 100) <= self.hospitalisedChance then
				target:setAwayUntil(timeline.curTime + self.hospitalisationDuration)
				
				text = text.hospitalised
				
				frameController:push(game.createPopup(500, self.occurTitleHospitalised, string.easyformatbykeys(text[math.random(1, #text)], "NAME", target:getFullName(true)), fonts.get("pix24"), fonts.get("pix20")))
			else
				text = text.death
				
				target:die(self.occurTitleDeath, text[math.random(1, #text)], self)
			end
		end
	},
	{
		deathChance = 80,
		increasedLearnSpeedChance = 90,
		occurChance = 142857,
		increasedLearnSpeedRange = {
			2,
			3.5
		},
		hospitalisationDuration = timeline.DAYS_IN_WEEK,
		occurTitleHospitalised = _T("EMPLOYEE_HOSPITALISED_TITLE", "Employee Hospitalised"),
		occurTitleDeath = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurText = {
			death = {
				_T("EMPLOYEE_STRUCK_BY_LIGHTNING_DEATH_1", "NAME has been struck by lightning and has, unfortunately, passed away."),
				_T("EMPLOYEE_STRUCK_BY_LIGHTNING_DEATH_2", "NAME has died after being struck by lightning.")
			},
			hospitalised = {
				_T("EMPLOYEE_STRUCK_BY_LIGHTNING_HOSPITALISED_1", "NAME has been struck by lightning, but has survived. They will have to spend a week in the hospital.")
			}
		},
		occurFunc = function(self, target)
			local text = self.occurText
			
			if math.random(1, 100) <= self.deathChance then
				text = text.death
				
				target:die(self.occurTitleDeath, text[math.random(1, #text)], self)
			else
				target:setAwayUntil(timeline.curTime + self.hospitalisationDuration)
				
				text = text.hospitalised
				
				frameController:push(game.createPopup(500, self.occurTitleHospitalised, string.easyformatbykeys(text[math.random(1, #text)], "NAME", target:getFullName(true)), fonts.get("pix24"), fonts.get("pix20")))
				
				if math.random(1, 100) <= self.increasedLearnSpeedChance then
					target:setSkillProgressionModifier(math.randomf(self.increasedLearnSpeedRange[1], self.increasedLearnSpeedRange[2]))
				end
			end
		end
	},
	{
		hospitalChance = 40,
		deathChance = 30,
		occurChance = 28423,
		hospitalisationDuration = timeline.DAYS_IN_WEEK,
		occurTitleHospitalised = _T("EMPLOYEE_HOSPITALISED_TITLE", "Employee Hospitalised"),
		occurTitleDeath = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurTitle = _T("EMPLOYEE_CAUGHT_IN_HOUSEFIRE", "Employee caught in housefire"),
		occurText = {
			death = {
				_T("EMPLOYEE_HOUSEFIRE_DEATH_1", "In an unfortunate turn of events, NAME got caught up in a housefire and has died.")
			},
			hospitalised = {
				_T("EMPLOYEE_HOUSEFIRE_HOSPITALISED_1", "NAME got caught up in a housefire, but managed to get out in time. They will have to spend a week in a hospital under medical care.")
			},
			survived = {
				_T("EMPLOYEE_HOUSEFIRE_SURVIVED_1", "NAME got caught up in a housefire, but managed to get out unscathed.")
			}
		},
		occurFunc = function(self, target)
			local text = self.occurText
			
			if math.random(1, 100) <= self.deathChance then
				text = text.death
				
				target:die(self.occurTitleDeath, text[math.random(1, #text)], self)
			elseif math.random(1, 100) <= self.hospitalChance then
				target:setAwayUntil(timeline.curTime + self.hospitalisationDuration)
				
				text = text.hospitalised
				
				frameController:push(game.createPopup(500, self.occurTitleHospitalised, string.easyformatbykeys(text[math.random(1, #text)], "NAME", target:getFullName(true)), fonts.get("pix24"), fonts.get("pix20")))
			else
				text = text.survived
				
				frameController:push(game.createPopup(500, self.occurTitle, string.easyformatbykeys(text[math.random(1, #text)], "NAME", target:getFullName(true)), fonts.get("pix24"), fonts.get("pix20")))
			end
		end
	},
	{
		hospitalisedChance = 80,
		occurChance = 15000,
		hospitalisationDuration = timeline.DAYS_IN_MONTH,
		occurTitleHospitalised = _T("EMPLOYEE_HOSPITALISED_TITLE", "Employee Hospitalised"),
		occurTitleDeath = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurText = {
			death = {
				_T("EMPLOYEE_HIT_BY_CAR_DEATH_1", "NAME was hit by a car and, unfortunately, has passed away.")
			},
			hospitalised = {
				_T("EMPLOYEE_HIT_BY_CAR_HOSPITALISED_1", "NAME was hit by a car, and will have to spend a month in the hospital.")
			}
		},
		occurFunc = function(self, target)
			local text = self.occurText
			
			if math.random(1, 100) <= self.hospitalisedChance then
				target:setAwayUntil(timeline.curTime + self.hospitalisationDuration)
				
				text = text.hospitalised
				
				frameController:push(game.createPopup(500, self.occurTitleHospitalised, string.easyformatbykeys(text[math.random(1, #text)], "NAME", target:getFullName(true)), fonts.get("pix24"), fonts.get("pix20")))
			else
				text = text.death
				
				target:die(self.occurTitleDeath, text[math.random(1, #text)], self)
			end
		end
	},
	{
		factRequirement = "predetermined_for_suicide",
		maxChanceDrop = 1000,
		factChance = 4000,
		hospitalisedChance = 80,
		occurChance = 10000,
		hospitalisationDuration = timeline.DAYS_IN_MONTH,
		occurTitle = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurText = {
			_T("EMPLOYEE_SUICIDE_1", "NAME has been combating depression for a very long time, but unfortunately, has succumbed to it and took their own life.")
		},
		getOccurChance = function(self, target)
			local chanceMul = target:getNationality() == "finnish" and 1.5 or 1
			local delta = -(target:getDrive() - developer.MAX_DRIVE) / 100
			
			return self.occurChance - self.maxChanceDrop * delta * chanceMul
		end
	},
	{
		factRequirement = "predetermined_for_health_complications",
		occurChance = 40000,
		factChance = 1000,
		occurTitle = _T("EMPLOYEE_HAS_LEFT_STUDIO", "Employee has left studio"),
		occurText = {
			_T("HEALTH_COMPLICATIONS_DEATH_1", "NAME has had health complications as of late, and has decided to leave the studio to take care of their own health.")
		}
	},
	{
		occurChance = 42128,
		occurTitle = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurText = {
			_T("FELL_DOWN_STAIRS_1", "NAME has fallen down a flight of stairs and died.")
		}
	},
	{
		hospitalisedChance = 20,
		occurChance = 194856,
		hospitalisationDuration = timeline.DAYS_IN_MONTH,
		occurTitleHospitalised = _T("EMPLOYEE_HOSPITALISED_TITLE", "Employee Hospitalised"),
		occurTitleDeath = _T("EMPLOYEE_HAS_DIED", "Employee has died"),
		occurText = {
			death = {
				_T("TERROR_ATTACK_DEATH_1", "A terror attack was carried out nearby recently. NAME was unfortunate enough to be where it happened and has been one of the victims.")
			},
			hospitalised = {
				_T("TERROR_ATTACK_HOSPITALISED_1", "A terror attack was carried nearby recently. NAME was unfortunate enough to be where it happened and has been one of the victims, but has survived.")
			}
		},
		occurFunc = function(self, target)
			local text = self.occurText
			
			if math.random(1, 100) <= self.hospitalisedChance then
				target:setAwayUntil(timeline.curTime + self.hospitalisationDuration)
				
				text = text.hospitalised
				
				frameController:push(game.createPopup(500, self.occurTitleHospitalised, string.easyformatbykeys(text[math.random(1, #text)], "NAME", target:getFullName(true)), fonts.get("pix24"), fonts.get("pix20")))
			else
				text = text.death
				
				target:die(self.occurTitleDeath, text[math.random(1, #text)], self)
			end
		end
	}
}
employeeDeath.twoCausesChance = 30

function employeeDeath:validateFact(target)
	if target:canDie() then
		for key, deathCauseData in ipairs(employeeDeath.causes) do
			if deathCauseData.factRequirement and math.random(1, deathCauseData.factChance) == 1 then
				target:setFact(deathCauseData.factRequirement, true)
			end
		end
	end
end

function employeeDeath:isReasonValid(target, deathCause)
	if deathCause.factRequirement and not target:getFact(deathCause.factRequirement) then
		return false
	end
	
	if deathCause.canOccur and deathCause:canOccur(target) then
		return false
	end
	
	return true
end

function employeeDeath:findValidDeathReasons(target)
	if target:canDie() then
		for key, deathCauseData in ipairs(employeeDeath.causes) do
			if self:isReasonValid(target, deathCauseData) then
				employeeDeath.validDeathReasons[#employeeDeath.validDeathReasons + 1] = deathCauseData
			end
		end
	end
end

function employeeDeath:getOccurenceChance(deathCause, target)
	if deathCause.getOccurChance then
		return deathCause:getOccurChance(target)
	end
	
	return deathCause.occurChance
end

function employeeDeath:clearTables()
	table.clearArray(employeeDeath.validDeathReasons)
end

function employeeDeath:getOccuranceText(deathCause)
	if type(deathCause.occurText) == "table" then
		return deathCause.occurText[math.random(1, #deathCause.occurText)]
	end
	
	return deathCause.occurText
end

function employeeDeath:occur()
	local employees = studio:getEmployees()
	local randomEmployee = employees[math.random(1, #employees)]
	
	if not randomEmployee or randomEmployee:isPlayerCharacter() then
		self:clearTables()
		
		return true
	end
	
	self:findValidDeathReasons(randomEmployee)
	
	local deathCauseAmount = math.random(1, 100) <= employeeDeath.twoCausesChance and 2 or 1
	
	for i = 1, deathCauseAmount do
		if randomEmployee:isDead() then
			break
		else
			local randomIndex = math.random(1, #employeeDeath.validDeathReasons)
			local randomReason = employeeDeath.validDeathReasons[randomIndex]
			
			if not randomReason then
				self:clearTables()
				
				return 
			end
			
			if math.random(1, math.max(self:getOccurenceChance(randomReason, randomEmployee) * EMPLOYEE_DEATH_CHANCE_MULTIPLIER, 1)) == 1 then
				if randomReason.occurFunc then
					randomReason:occurFunc(randomEmployee)
				else
					randomEmployee:die(randomReason.occurTitle, self:getOccuranceText(randomReason), "NAME", randomEmployee:getFullName(true))
				end
			end
			
			table.remove(employeeDeath.validDeathReasons, randomIndex)
		end
	end
	
	self:clearTables()
end

randomEvents:registerNew(employeeDeath)

local workInOtherField = {}

workInOtherField.id = "work_in_other_field"
workInOtherField.eventRequirement = timeline.EVENTS.NEW_WEEK
workInOtherField.rollMin = 1
workInOtherField.rollMax = 1000
workInOtherField.occurChance = 1
workInOtherField.validEmployees = {}
workInOtherField.affectedRoles = {
	software_engineer = true
}
workInOtherField.dialogueID = "employee_leaves_work_elsewhere"

function workInOtherField:occur()
	for key, employee in ipairs(studio:getEmployees()) do
		if self.affectedRoles[employee:getRole()] and not employee:isPlayerCharacter() then
			table.insert(self.validEmployees, employee)
		end
	end
	
	if #self.validEmployees > 0 then
		local randomIndex = math.random(1, #self.validEmployees)
		local randomEmployee = self.validEmployees[randomIndex]
		
		dialogueHandler:addDialogue(self.dialogueID, nil, randomEmployee, nil)
	end
	
	table.clearArray(self.validEmployees)
end

randomEvents:registerNew(workInOtherField)
