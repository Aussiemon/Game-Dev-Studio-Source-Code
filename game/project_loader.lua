projectLoader = {}
projectLoader.PROJECT_TYPE_TO_CLASS_INDEX = {}
projectLoader.PROJECT_TYPE_TO_STUDIO_METHOD = {}
projectLoader.POST_LOAD_CALLBACKS = {}

function projectLoader:registerNewProjectClass(projectType, classID)
	self.PROJECT_TYPE_TO_CLASS_INDEX[projectType] = classID
end

function projectLoader:addPostLoadProjectCallback(projectType, callback)
	projectLoader.POST_LOAD_CALLBACKS[projectType] = callback
end

function projectLoader:load(data, owner)
	local projType = data.PROJECT_TYPE
	local classID = self.PROJECT_TYPE_TO_CLASS_INDEX[projType]
	
	if not classID then
		error("attempt to load unregistered project type of '" .. projType .. "', some kind of mod bug?")
		
		return 
	end
	
	local projClass = _G[classID]
	local newProject = projClass.new(owner)
	
	newProject:load(data)
	
	if projectLoader.POST_LOAD_CALLBACKS[projectType] then
		projectLoader.POST_LOAD_CALLBACKS[projectType](newProject)
	end
	
	return newProject
end

projectLoader:registerNewProjectClass("game", "gameProject")
projectLoader:registerNewProjectClass("engine", "engine")
projectLoader:registerNewProjectClass("gamePatch", "patchProject")
