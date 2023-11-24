local engineRevampInfoDisplay = {}

function engineRevampInfoDisplay:getWorkInfo(projectObject)
	return projectObject:getRevampWorkInfo()
end

gui.register("EngineRevampInfoDisplay", engineRevampInfoDisplay, "ProjectInfoDisplay")
