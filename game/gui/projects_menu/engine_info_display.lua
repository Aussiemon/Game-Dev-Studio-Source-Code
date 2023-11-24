local engineInfoDisplay = {}

function engineInfoDisplay:updateDisplay(projectObject)
	if engineInfoDisplay.baseClass.updateDisplay(self, projectObject) then
		self:addSpaceToNextText(8)
		self:addText(_T("ENGINE_STATS", "Engine stats"), "pix24", self.categoryColor, 4, 320)
		
		projectObject = projectObject or self.project
		
		engineStats:fillDescbox(projectObject, self, "pix20", 320, 22)
		
		return true
	end
	
	return false
end

gui.register("EngineInfoDisplay", engineInfoDisplay, "ProjectInfoDisplay")
