local practice = {}

practice.id = "practice_skill"
practice.practiceInterval = {
	max = 2,
	min = 1
}
practice.practiceSkill = nil
practice.practiceSessions = nil
practice.minIncrease = nil
practice.maxIncrease = nil
practice.skillIncreaseDivider = 1
practice.fillerColor = color(221, 171, 99, 255)
practice.MAX_SKILL_LEVEL_MULTIPLIER = 0.8

function practice:init()
	practice.baseClass.init(self)
	
	self.practiceSessions = 10
	self.skillLevelExpIncreaseMult = 1
	
	self:rollPracticeInterval()
end

function practice:setPracticeSkill(skillID)
	self.practiceSkill = skillID
	
	self:setText(self:getName())
end

function practice:getPracticeSkill()
	return self.practiceSkill
end

function practice:setExperienceIncrease(min, max)
	self.minIncrease = min
	self.maxIncrease = max
end

function practice:setPracticeInterval(min, max)
	self.practiceInterval = {
		min = min,
		max = max
	}
end

function practice:getTaskTypeText()
	return ""
end

function practice:getName()
	return string.easyformatbykeys(_T("PRACTICING_SKILL", "Practice SKILLNAME"), "SKILLNAME", skills:getName(self.practiceSkill))
end

function practice:setSkillIncreaseDivider(div)
	self.skillIncreaseDivider = div
end

function practice:setSkillLevelExperienceIncreaseMultiplier(mult)
	self.skillLevelExpIncreaseMult = mult
end

function practice:getExperienceIncrease()
	if not self.maxIncrease then
		return self.minIncrease
	end
	
	local level = self.assignee:getSkillLevel(self.practiceSkill)
	local final = (math.random(self.minIncrease, self.maxIncrease) + math.min(self.gainSkillLevel, level) * self.skillLevelExpIncreaseMult) / self.skillIncreaseDivider
	
	if level < self.maxSkillLevel then
		local office = self.assignee:getOffice()
		
		if office then
			final = final * self.assignee:adjustBookExperienceBoost(bookController:getSkillExperienceBoost(self.practiceSkill, office))
		end
	end
	
	return final
end

function practice:setSessions(sessions)
	self.initialSessions = sessions
	self.practiceSessions = sessions
end

function practice:getCompletion()
	return 1 - self.practiceSessions / self.initialSessions
end

function practice:rollPracticeInterval()
	self.timeToPractice = math.randomf(self.practiceInterval.min, self.practiceInterval.max)
end

function practice:setAssignee(assignee)
	self.assignee = assignee
	
	if assignee then
		self.maxSkillLevel = assignee:getRoleData().maxSkillLevels[self.practiceSkill]
		self.gainSkillLevel = self.maxSkillLevel * practice.MAX_SKILL_LEVEL_MULTIPLIER
	else
		self.maxSkillLevel = nil
		self.gainSkillLevel = nil
	end
	
	self:onSetAssignee()
end

function practice:progress(delta, progress, assignee)
	local infinite = self.practiceSessions < 0
	local residue = self.timeToPractice - progress
	
	self.timeToPractice = residue
	
	if infinite then
		while residue <= 0 do
			assignee:increaseSkill(self.practiceSkill, self:getExperienceIncrease())
			
			residue = residue + self.timeToPractice
			
			if residue > 0 then
				self.timeToPractice = residue
				
				break
			else
				self:rollPracticeInterval()
			end
		end
		
		return false
	else
		if self.practiceSessions == 0 then
			return true
		end
		
		while residue <= 0 do
			self.practiceSessions = self.practiceSessions - 1
			
			assignee:increaseSkill(self.practiceSkill, self:getExperienceIncrease())
			
			if self.practiceSessions == 0 then
				break
			else
				residue = residue + self.timeToPractice
				
				if residue > 0 then
					self.timeToPractice = residue
					
					break
				else
					self:rollPracticeInterval()
				end
			end
		end
		
		return self.practiceSessions == 0
	end
end

function practice:isDone()
	return self.practiceSessions <= 0
end

function practice:save()
	local data = practice.baseClass.save(self)
	
	data.practiceSkill = self.practiceSkill
	data.practiceSessions = self.practiceSessions
	data.minPractice = self.minPractice
	data.maxPractice = self.maxPractice
	data.practiceInterval = self.practiceInterval
	data.initialSessions = self.initialSessions
	data.minIncrease = self.minIncrease
	data.maxIncrease = self.maxIncrease
	data.skillIncreaseDivider = self.skillIncreaseDivider
	data.skillLevelExpIncreaseMult = self.skillLevelExpIncreaseMult
	
	return data
end

function practice:load(data)
	practice.baseClass.load(self, data)
	self:setPracticeSkill(data.practiceSkill)
	
	self.practiceSessions = data.practiceSessions
	self.inPractice = data.minPractice
	self.maxPractice = data.maxPractice
	self.practiceInterval = data.practiceInterval
	self.initialSessions = data.initialSessions
	self.minIncrease = data.minIncrease
	self.maxIncrease = data.maxIncrease
	self.skillIncreaseDivider = data.skillIncreaseDivider or self.skillIncreaseDivider
	self.skillLevelExpIncreaseMult = data.skillLevelExpIncreaseMult or 1
end

task:registerNew(practice, "progress_bar_task")
