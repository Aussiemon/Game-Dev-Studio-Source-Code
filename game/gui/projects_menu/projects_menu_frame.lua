local projectsFrame = {}

projectsFrame.canPropagateKeyPress = true

function projectsFrame:getCanBlockCamera()
	return true
end

gui.register("ProjectsMenuFrame", projectsFrame, "InvisibleFrame")
