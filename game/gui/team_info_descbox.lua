local teamInfoDescbox = {}

teamInfoDescbox.teamSkillList = nil

function teamInfoDescbox.sortByLevel(a, b)
	return teamInfoDescbox.teamSkillList[a] > teamInfoDescbox.teamSkillList[b]
end

local sortedByLevel = {}

function teamInfoDescbox:setShowPenaltyDescription(show)
	self.showPenaltyDescription = show
end

function teamInfoDescbox:bringUp()
	self:addDepth(10000)
end

function teamInfoDescbox:canShow()
	return self.team ~= nil
end

function teamInfoDescbox:hideDisplay()
	self.team = nil
	
	self:removeAllText()
	self:hide()
end

function teamInfoDescbox:showDisplay(teamObj)
	self:setTeam(teamObj)
	self:show()
end

local data = gui.getClassTable("TeamButton")

function teamInfoDescbox:setTeam(teamObj)
	self.team = teamObj
	
	self:removeAllText()
	
	local curProj = teamObj:getProject()
	local wrapW = 320
	
	if curProj then
		self:addText(_format(_T("TEAM_BUSY_WITH_PROJECT", "This team is currently working on 'PROJECT'"), "PROJECT", curProj:getName()), "bh18", game.UI_COLORS.IMPORTANT_1, 10, wrapW, "exclamation_point_yellow", 22, 22)
	end
	
	local members = self.team:getMembers()
	
	if #members == 1 then
		self:addText(_T("QUICK_TEAM_INFO_SINGLE_MEMBER", "1 member"), "pix24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapW)
	else
		local text = self.team:getMemberCountText(#members)
		
		self:addText(text, "pix24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapW)
	end
	
	self:addText(_format(_T("TEAM_OVERALL_EFFICIENCY", "Overall efficiency: EFFICIENCY%"), "EFFICIENCY", math.round(self.team:getOverallEfficiency() * 100, 1)), "bh20", nil, 0, wrapW, "percentage", 22, 22)
	
	local managementBoost = self.team:getManagementBoost()
	
	if managementBoost ~= 1 then
		self:addText(_format(_T("TEAM_MANAGEMENT_BOOST", "Management boost: BOOST%"), "BOOST", math.round(managementBoost * 100 - 100, 1)), "bh20", nil, 0, wrapW, "project_stuff", 22, 22)
	else
		self:addText(_T("TEAM_NO_MANAGEMENT_BOOST", "No management boost"), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "question_mark", 22, 22)
	end
	
	local interOfficePenalty = self.team:getInterOfficeMultiplier()
	
	if interOfficePenalty == 1 then
		self:addText(_format(_T("TEAM_NO_INTER_OFFICE_PENALTY", "No inter-office penalty")), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "exclamation_point", 22, 22)
	else
		self:addText(_format(_T("TEAM_INTER_OFFICE_PENALTY", "Inter-office penalty: PENALTY%"), "PENALTY", math.round((1 - interOfficePenalty) * 100, 1)), "bh20", game.UI_COLORS.RED, 0, wrapW, "percentage_red", 22, 22)
		
		if self.showPenaltyDescription then
			self:addText(_T("TEAM_INTER_OFFICE_PENALTY_HELP_1", "This penalty occurs when team members are within multiple offices."), "bh20", nil, 4, wrapW, "question_mark", 22, 22)
			self:addText(_T("TEAM_INTER_OFFICE_PENALTY_HELP_2", "Add more managers to the team, or reduce the amount of buildings the team members are scattered throughout to decrease the penalty."), "bh18", nil, 0, wrapW)
		end
	end
	
	self:addSpaceToNextText(10)
	self:addText(_T("QUICK_TEAM_INFO_TOTAL_SKILLS", "Sum of skills (highest skill level):"), "pix20", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapW)
	
	local totalSkills = self.team:getTotalSkills()
	local highestSkills = self.team:getHighestSkillLevels()
	
	for skillID, level in pairs(highestSkills) do
		sortedByLevel[#sortedByLevel + 1] = skillID
	end
	
	teamInfoDescbox.teamSkillList = highestSkills
	
	table.sort(sortedByLevel, teamInfoDescbox.sortByLevel)
	
	for key, skillID in ipairs(sortedByLevel) do
		local skillData = skills.registeredByID[skillID]
		
		self:addText(_format(_T("QUICK_TEAM_INFO_TOTAL_SKILL", "SKILLNAME Lv. LEVEL (HIGHEST)"), "SKILLNAME", skillData.display, "LEVEL", string.comma(totalSkills[skillData.id]), "HIGHEST", highestSkills[skillData.id]), "pix16", nil, 2, wrapW, {
			{
				height = 18,
				icon = "profession_backdrop",
				width = 18
			},
			{
				width = 16,
				height = 16,
				y = 1,
				x = 1,
				icon = skillData.icon
			}
		})
	end
	
	table.clearArray(sortedByLevel)
	
	local memberCount = teamObj:getMemberCount()
	
	if memberCount > 0 then
		self:addSpaceToNextText(5)
		self:addText(_T("TEAM_KNOWLEDGE", "Knowledge"), "pix24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 4, wrapW)
		
		local knowledgeLevels = self.team:getCollectiveKnowledge()
		
		for key, data in ipairs(knowledge.registered) do
			local amount = math.round(knowledgeLevels[data.id] or 0)
			
			if amount > 0 then
				self:addText(_format(_T("TEAM_KNOWLEDGE_INFO", "KNOWLEDGE - POINTS pts."), "KNOWLEDGE", data.display, "POINTS", amount), "bh16", nil, 0, wrapW)
			end
		end
	end
end

gui.register("TeamInfoDescbox", teamInfoDescbox, "GenericDescbox")
