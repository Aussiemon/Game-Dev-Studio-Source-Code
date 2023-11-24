local projectInfoBarDisplay = {}

function projectInfoBarDisplay:setData(proj)
	self.project = project
end

function projectInfoBarDisplay:saveData(saved)
	saved.project = self.project
	
	return saved
end

function projectInfoBarDisplay:loadData(data)
	self:setData(data.project)
end

gui.register("ProjectInfoBarDisplayFrame", projectInfoBarDisplay, "BarDisplayFrame")
