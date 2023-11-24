local gameInfoDisplay = {}

gameInfoDisplay.CATCHABLE_EVENTS = {
	gameProject.EVENTS.CHANGED_GENRE,
	gameProject.EVENTS.CHANGED_THEME,
	project.EVENTS.DESIRED_TEAM_SET,
	gameProject.EVENTS.SCALE_CHANGED,
	complexProject.EVENTS.ADDED_DESIRED_FEATURE,
	gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED,
	gameProject.EVENTS.CATEGORY_PRIORITY_CHANGED,
	gameProject.EVENTS.PLATFORM_STATE_CHANGED,
	gameProject.EVENTS.SUBGENRE_CHANGED,
	gameProject.EVENTS.INHERITED_PROJECT_SETUP
}

function gameInfoDisplay:canShow()
	return true
end

function gameInfoDisplay:updateDisplay(projectObject)
	self:removeAllText()
	
	projectObject = projectObject or self.project
	
	local totalWork, workByWorkField, polishWorkAmounts, contributingKnowledge, mmoComplex, mmoContent = self:getWorkInfo(projectObject)
	
	self:addText(self:getTopText(), "bh24", self.categoryColor, 5, 320)
	self:addText(_format(_T("TOTAL_PROJECT_WORK", "Total work amount: WORK points"), "WORK", string.comma(math.round(totalWork))), "pix20", nil, 4, 320, "wrench", 24, 24)
	self:addText(_format(_T("TOTAL_PROJECT_EXPENSES", "Total expenses: EXPENSES"), "EXPENSES", string.roundtobigcashnumber(projectObject:getDesiredFeaturesCost())), "pix20", nil, 0, 320, "wad_of_cash", 24, 24)
	
	if mmoComplex > 0 then
		self:addText(_format(_T("PROJECT_SERVER_COMPLEXITY", "Server complexity: COMPLEX pts."), "COMPLEX", mmoComplex), "pix20", nil, 4, 320, "projects_finished", 24, 24)
	end
	
	if mmoContent > 0 then
		self:addText(_format(_T("PROJECT_MMO_CONTENT", "MMO Content: CONTENT pts."), "CONTENT", mmoContent), "pix20", nil, 4, 320, "content", 24, 24)
	end
	
	self:addSpaceToNextText(12)
	self:addText(_T("PROJECT_WORK_BY_TYPE", "Work amount by skill"), "bh24", self.categoryColor, 4, 320)
	
	for key, skillData in ipairs(skills.registered) do
		local amount = workByWorkField[skillData.id]
		
		if amount then
			local polishAmount = polishWorkAmounts[skillData.id]
			
			if polishAmount then
				self:addText(_format(_T("PROJECT_WORK_AND_POLISH_BY_TYPE_SPECIFIC", "BASE + POLISH SKILL points"), "BASE", string.comma(math.round(amount)), "POLISH", string.comma(math.round(polishAmount)), "SKILL", skillData.display), "pix20", nil, 2, 320, {
					{
						height = 22,
						icon = "profession_backdrop",
						width = 22
					},
					{
						width = 20,
						height = 20,
						y = 1,
						x = 1,
						icon = skillData.icon
					}
				})
			else
				self:addText(_format(_T("PROJECT_WORK_BY_TYPE_SPECIFIC", "BASE SKILL points"), "BASE", string.comma(math.round(amount)), "SKILL", skillData.display), "pix20", nil, 2, 320, {
					{
						height = 22,
						icon = "profession_backdrop",
						width = 22
					},
					{
						width = 20,
						height = 20,
						y = 1,
						x = 1,
						icon = skillData.icon
					}
				})
			end
		end
	end
	
	local teamObj = projectObject:getDesiredTeam()
	
	if teamObj and #contributingKnowledge > 0 then
		self:addSpaceToNextText(12)
		self:addText(_T("CONTRIBUTING_KNOWLEDGE", "Contributing knowledge"), "bh24", self.categoryColor, 4, 320)
		
		local memberCount = teamObj:getMemberCount()
		local knowledgeHeaderBold, knowledgeHeaderThin, knowledgeBold
		
		if #contributingKnowledge < 5 then
			knowledgeHeaderBold, knowledgeHeaderThin, knowledgeBold = "bh20", "pix20", "bh18"
		else
			knowledgeHeaderBold, knowledgeHeaderThin, knowledgeBold = "bh18", "pix18", "bh16"
		end
		
		for key, knowledgeID in ipairs(contributingKnowledge) do
			local knowledgeData = knowledge.registeredByID[knowledgeID]
			local knowledgeAmount = 0
			
			if teamObj then
				knowledgeAmount = math.round(teamObj:getKnowledge(knowledgeID) or 0)
			end
			
			local textFont, textColor
			
			if knowledgeAmount > 0 then
				textFont = knowledgeHeaderBold
			else
				textFont = knowledgeHeaderThin
				textColor = game.UI_COLORS.GREY
			end
			
			self:addText(knowledgeData.display, textFont, textColor, 0, 320)
			
			if knowledgeAmount > 0 then
				self:addText(_format(_T("TEAM_AVERAGE_KNOWLEDGE", "\tTeam knowledge: POINTS/MAX pts."), "POINTS", knowledgeAmount, "MAX", knowledge.MAXIMUM_KNOWLEDGE), knowledgeBold, game.UI_COLORS.LIGHT_BLUE, 0, 320)
			end
		end
	end
	
	return true
end

gui.register("GameInfoDisplay", gameInfoDisplay, "ProjectInfoDisplay")
