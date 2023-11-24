local projectInfoDisplay = {}

projectInfoDisplay.extraInfoColor = color(140, 180, 206, 255)
projectInfoDisplay.saleInfoColor = color(184, 206, 171, 255)
projectInfoDisplay.categoryColor = color(201, 206, 171, 255)

function projectInfoDisplay:bringUp()
	self:addDepth(5000)
end

function projectInfoDisplay:setProject(projObject)
	self.project = projObject
end

function projectInfoDisplay:getTopText()
	return _T("PROJECT_SETUP", "Project setup")
end

projectInfoDisplay.CATCHABLE_EVENTS = {
	complexProject.EVENTS.ADDED_DESIRED_FEATURE,
	project.EVENTS.DESIRED_TEAM_SET
}

function projectInfoDisplay:handleEvent(event, projectObject)
	if projectObject == self.project then
		self:showDisplay(projectObject)
	end
end

function projectInfoDisplay:canShow()
	return self.textPresent
end

function projectInfoDisplay:onShow()
	self:updateDisplay()
end

function projectInfoDisplay:showDisplay(projectObject)
	if self:getVisible() then
		self:updateDisplay(projectObject)
		
		return 
	end
	
	if self:updateDisplay(projectObject) then
		self:show()
	end
end

function projectInfoDisplay:getWorkInfo(projectObject)
	return projectObject:getThoroughWorkInfo()
end

function projectInfoDisplay:updateDisplay(projectObject)
	projectObject = projectObject or self.project
	self.textPresent = false
	
	if not projectObject then
		return false
	end
	
	self.textPresent = true
	
	self:removeAllText()
	
	local totalWork, workByWorkField = self:getWorkInfo(projectObject)
	
	self:addText(self:getTopText(), "bh24", self.categoryColor, 5, 320)
	self:addText(_format(_T("TOTAL_PROJECT_WORK", "Total work amount: WORK points"), "WORK", string.comma(math.round(totalWork))), "pix20", nil, 4, 320, "wrench", 24, 24)
	self:addSpaceToNextText(8)
	self:addText(_T("PROJECT_WORK_BY_SKILL", "Work by skill"), "bh24", self.categoryColor, 4, 320)
	
	for key, skillData in ipairs(skills.registered) do
		local amount = workByWorkField[skillData.id]
		
		if amount then
			self:addText(_format(_T("PROJECT_WORK_BY_TYPE_SPECIFIC", "BASE SKILL points"), "BASE", string.comma(math.round(amount)), "SKILL", skillData.display), "pix20", nil, 0, 320, {
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
	
	return true
end

function projectInfoDisplay:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("ProjectInfoDisplay", projectInfoDisplay, "GenericDescbox")
require("game/gui/projects_menu/game_info_display")
require("game/gui/projects_menu/engine_revamp_info_display")
