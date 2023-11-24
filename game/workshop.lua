workshop = {}
workshop.ELEMENT_IDS = {
	SUBSCRIBED_MODS = "workshop_subscribed_mods",
	CREATED_MODS = "workshop_created_mods"
}
workshop.MOD_QUERY_TYPES = {
	PUBLISHED = 0,
	SUBSCRIBED = 6
}
workshop.MAX_IMAGE_SIZE = 1048576
workshop.EVENTS = {
	PREVIEW_RECEIVED = events:new(),
	MOD_QUERY_FINISHED = events:new(),
	MOD_TAB_SWITCHED = events:new(),
	MOD_FOLDER_SELECTED = events:new(),
	MOD_QUERY_STARTED = events:new(),
	PREVIEW_FOLDER_SELECTED = events:new(),
	ITEM_CREATED = events:new(),
	ITEM_CREATION_FAILED = events:new(),
	ITEM_UPLOADED = events:new(),
	ITEM_UPLOAD_FAILED = events:new(),
	ITEM_UPLOAD_STARTED = events:new(),
	ITEM_CREATION_STARTED = events:new(),
	ITEM_UPDATE_STARTED = events:new(),
	FINAL_PAGE = events:new(),
	TAG_ADDED = events:new(),
	TAG_REMOVED = events:new(),
	MOD_DISABLED = events:new(),
	MOD_ENABLED = events:new()
}
workshop.MOD_STAGING_FOLDER = "mods_staging/"
workshop.ITEMS_PER_PAGE = 50
workshop.ACCEPTABLE_IMAGE_FILES = {
	".jpg",
	".png"
}
workshop.INVALID_PARAMS = {
	NO_IMAGE = 3,
	NO_MAIN_LUA = 2,
	NO_FILE_FOLDER = 1
}
workshop.MAX_DESC_LENGTH = 256
workshop.INVALID_PARAM_TEXT = {
	[workshop.INVALID_PARAMS.NO_FILE_FOLDER] = _T("WORKSHOP_INVALID_PARAMETER_NO_FILE_FOLDER", "No 'files' folder present within mod directory"),
	[workshop.INVALID_PARAMS.NO_MAIN_LUA] = _T("WORKSHOP_INVALID_PARAMETER_NO_MAIN_LUA", "No 'main.lua' file present within 'files' folder"),
	[workshop.INVALID_PARAMS.NO_IMAGE] = _T("WORKSHOP_INVALID_PARAMETER_NO_PREVIEW", "No preview images within mod directory")
}
workshop.MOD_PUBLISH_STATES = {
	CREATING = 1,
	UPLOADING = 2
}
workshop.MAX_TITLE_LENGTH = 40
workshop.ITEM_UPDATE_STATUS = {
	UPLOAD_CONTENT = 3,
	CONFIG = 1,
	INVALID = 0,
	PREPARE_CONTENT = 2,
	UPLOAD_PREVIEW = 4,
	COMMITTING = 5
}
workshop.ITEM_UPDATE_STATUS_TEXT = {
	[workshop.ITEM_UPDATE_STATUS.INVALID] = _T("WORKSHOP_UPLOAD_STATUS_INVALID", "Failure"),
	[workshop.ITEM_UPDATE_STATUS.CONFIG] = _T("WORKSHOP_UPLOAD_STATUS_CONFIG", "Processing config data"),
	[workshop.ITEM_UPDATE_STATUS.PREPARE_CONTENT] = _T("WORKSHOP_UPLOAD_STATUS_PREPARE_CONTENT", "Reading and processing files"),
	[workshop.ITEM_UPDATE_STATUS.UPLOAD_CONTENT] = _T("WORKSHOP_UPLOAD_STATUS_UPLOAD_FILES", "Uploading files"),
	[workshop.ITEM_UPDATE_STATUS.UPLOAD_PREVIEW] = _T("WORKSHOP_UPLOAD_STATUS_PREVIEW_IMAGE", "Uploading preview image"),
	[workshop.ITEM_UPDATE_STATUS.COMMITTING] = _T("WORKSHOP_UPLOAD_STATUS_COMMIT", "Committing all changes")
}
workshop.TAGS = {
	SCENARIO = "scenario",
	GAMEPLAY = "gameplay",
	OBJECTS = "objects",
	GRAPHICS = "graphics",
	MISC = "miscellaneous",
	AUDIO = "audio"
}
workshop.TAG_ORDER = {
	workshop.TAGS.GAMEPLAY,
	workshop.TAGS.GRAPHICS,
	workshop.TAGS.SCENARIO,
	workshop.TAGS.OBJECTS,
	workshop.TAGS.AUDIO,
	workshop.TAGS.MISC
}
workshop.TAG_TEXT = {
	[workshop.TAGS.GAMEPLAY] = _T("WORKSHOP_TAG_GAMEPLAY", "Gameplay"),
	[workshop.TAGS.GRAPHICS] = _T("WORKSHOP_TAG_GRAPHICS", "Graphics"),
	[workshop.TAGS.AUDIO] = _T("WORKSHOP_TAG_AUDIO", "Audio"),
	[workshop.TAGS.SCENARIO] = _T("WORKSHOP_TAG_SCENARIO", "Scenario"),
	[workshop.TAGS.OBJECTS] = _T("WORKSHOP_TAG_OBJECTS", "Objects"),
	[workshop.TAGS.MISC] = _T("WORKSHOP_TAG_MISCELLANEOUS", "Miscellaneous")
}

function workshop:init()
	self.createdMods = {}
	self.subscribedMods = {}
	self.modsByID = {}
	self.queryImages = {}
	self.activeModData = {}
	self.disabledMods = {}
	self.createdModsPage = 1
	self.subscribedModsPage = 1
	self.currentPage = 1
	
	for key, value in pairs(workshop.MOD_QUERY_TYPES) do
		self.queryImages[value] = {}
	end
	
	if steam then
		self:autoGrabSubscribedMods()
	end
end

function workshop:getItemUpdateStatusText(status)
	return workshop.ITEM_UPDATE_STATUS_TEXT[status]
end

function workshop:hasTag(tag)
	return table.find(self.modUploadData.tags, tag)
end

function workshop:addTag(tag)
	table.insert(self.modUploadData.tags, tag)
	workshop:verifyFinishClickability()
	events:fire(workshop.EVENTS.TAG_ADDED, tag)
end

function workshop:removeTag(tag)
	table.removeObject(self.modUploadData.tags, tag)
	workshop:verifyFinishClickability()
	events:fire(workshop.EVENTS.TAG_REMOVED, tag)
end

function workshop:initModUploadData()
	self.modUploadData = {
		title = _T("MY_MOD", "My Mod"),
		tags = {}
	}
end

workshop.MOD_FILES_FOLDER = "/files/"

function workshop:disableMod(id)
	local data = self.activeModMap[id]
	
	if data then
		self.disabledMods[id] = true
	end
	
	self:createFirstTimePopup()
	game.saveUserPreferences()
	events:fire(workshop.EVENTS.MOD_DISABLED, id)
end

function workshop:enableMod(id)
	self.disabledMods[id] = nil
	
	self:createFirstTimePopup()
	game.saveUserPreferences()
	events:fire(workshop.EVENTS.MOD_ENABLED, id)
end

function workshop:isModInstalled(id)
	return self.activeModMap[id]
end

function workshop:createFirstTimePopup()
	if not self.firstTimeModChangePopup then
		local popup = game.createPopup(600, _T("WORKSHOP_DISABLED_MOD_TITLE", "Disabled Mod"), _T("WORKSHOP_DISABLED_MOD_CONTENT", "You'll need to restart the game for your mod changes to come into effect."), "pix24", "pix20", false)
		
		frameController:push(popup)
		
		self.firstTimeModChangePopup = true
	end
end

function workshop:isModDisabled(id)
	return self.disabledMods[id]
end

function workshop:setDisabledModMap(map)
	self.disabledMods = map
end

function workshop:getDisabledModMap()
	return self.disabledMods
end

local oldErrHand = love.errhand

function workshop.errhand(msg)
	local data = workshop.curLoadMod
	local metadataFile = data.dir .. "\\" .. "metadata"
	local hdl = io.open(metadataFile, "r")
	
	if hdl then
		local read = hdl:read("*all")
		local decoded = json:decode(read)
		
		msg = _format(_T("MOD_FAILED_TO_LOAD_CRASHLOG", "Failed to load mod 'MOD', crashlog:\n\nCRASHLOG\n\nPlease report this to the mod developer!"), "MOD", decoded.title, "CRASHLOG", msg)
	end
	
	oldErrHand(msg)
end

function workshop:loadMods()
	for key, folderName in ipairs(love.filesystem.loadedModDirectories) do
		self:addActiveModData(folderName)
	end
	
	if not steam then
		return 
	end
	
	local modData = steam.GetInstalledModData()
	
	self.activeModMap = {}
	
	if not self.disabledMods then
		self.disabledMods = {}
	end
	
	if not modData then
		self.activeMods = {}
		
		return 
	end
	
	self.activeMods = modData
	
	local dirs = love.filesystem.getCurrentDirectory()
	
	for key, path in ipairs(dirs) do
		love.filesystem.clearCurrentDirectory(path)
	end
	
	local modMap = self.activeModMap
	local disabledMods = self.disabledMods
	
	love.errhand = workshop.errhand
	
	for key, data in ipairs(modData) do
		modMap[data.id] = data
		self.curLoadMod = data
		
		if not disabledMods[data.id] then
			steam.LoadMod(data.dir)
		end
	end
	
	love.errhand = oldErrHand
	self.curLoadMod = nil
	
	for id, state in pairs(disabledMods) do
		if not modMap[id] then
			disabledMods[id] = nil
		end
	end
	
	for key, path in ipairs(dirs) do
		love.filesystem.setCurrentDirectory(path)
	end
end

function workshop:getModDirectoryValidity(dir, targetList)
	if targetList then
		table.clearArray(targetList)
	end
	
	local params = targetList or {}
	local baseFolder = dir .. workshop.MOD_FILES_FOLDER
	
	if not love.filesystem.isDirectory(baseFolder) then
		params[#params + 1] = workshop.INVALID_PARAMS.NO_FILE_FOLDER
	else
		if not love.filesystem.exists(baseFolder .. "main.lua") then
			params[#params + 1] = workshop.INVALID_PARAMS.NO_MAIN_LUA
		end
		
		local valid = false
		
		for key, path in ipairs(love.filesystem.getDirectoryItems(dir)) do
			if not love.filesystem.isDirectory(dir .. "/" .. path) and workshop:isValidImageExtension(path) then
				valid = true
				
				break
			end
		end
		
		if not valid then
			params[#params + 1] = workshop.INVALID_PARAMS.NO_IMAGE
		end
	end
	
	if #params > 0 then
		return false, params
	end
	
	return true, nil
end

function workshop:isValidImageExtension(path)
	for key, extension in ipairs(workshop.ACCEPTABLE_IMAGE_FILES) do
		local lastPart = string.sub(path, #path - #extension + 1, #path)
		
		if lastPart == extension then
			return true
		end
	end
	
	return false
end

function workshop:getModUploadData()
	return self.modUploadData
end

function workshop:onModQueryFinished(data, queryType, queriedPage, lastPage)
	if queryType == workshop.MOD_QUERY_TYPES.PUBLISHED then
		self:fillModPage(self.createdMods, queriedPage, data, workshop.MOD_QUERY_TYPES.PUBLISHED)
	elseif queryType == workshop.MOD_QUERY_TYPES.SUBSCRIBED then
		self:fillModPage(self.subscribedMods, queriedPage, data, workshop.MOD_QUERY_TYPES.SUBSCRIBED)
	end
	
	self:requestImage()
	
	if self.nextModListPageButton then
		self.nextModListPageButton:setCanClick(true)
		self.nextModListPageButton:queueSpriteUpdate()
	end
	
	if self.subModGrabPage then
		if lastPage then
			self.subModGrabPage = nil
		else
			self.subModGrabPage = self.subModGrabPage + 1
			
			self:querySubscribedMods(self.subModGrabPage)
		end
	end
	
	self.modQueryInProgress = nil
	
	events:fire(workshop.EVENTS.MOD_QUERY_FINISHED, queriedPage, queryType, lastPage)
end

function workshop:onModQueryLastPage(queryType, queriedPage)
	self.subModGrabPage = nil
	
	events:fire(workshop.EVENTS.FINAL_PAGE, queriedPage, queryType)
end

function workshop:setCurrentPage(page)
	self.currentPage = page
	
	self:requestImage()
end

function workshop:setCurrentQueryType(type)
	self.currentQuery = type
end

function workshop:requestImage(force)
	if not self.menuOpen and not force or self.imageQuery then
		return 
	end
	
	local page = self.queryImages[self.currentQuery][self.currentPage]
	
	if page and #page > 0 then
		if self:_attemptRequestPreview(page) then
			self.imageQuery = true
		else
			self.imageQuery = false
		end
	else
		self.imageQuery = false
	end
end

function workshop:_attemptRequestPreview(list)
	while true do
		if #list == 0 then
			return false
		end
		
		local id = table.remove(list, 1)
		local modData = self.modsByID[id]
		
		if not modData.image then
			print("queried preview image for", id)
			steam.RequestModPreview(id)
			
			return true
		end
	end
end

function workshop:onPreviewImageReceived(id, data)
	local img = love.graphics.newImage(love.image.newImageData(love.filesystem.newFileData(data, id)))
	
	self.modsByID[id].image = img
	
	print("received for", id)
	
	self.imageQuery = false
	
	events:fire(workshop.EVENTS.PREVIEW_RECEIVED, id)
	self:requestImage()
end

function workshop:onPreviewImageDownloadFailed()
	print("PREVIEW IMAGE DOWNLOAD FAILED.")
	
	self.imageQuery = false
	
	self:requestImage()
end

function workshop:getActiveModData()
	return self.activeModData
end

function workshop:fillModPage(baseList, queriedPage, data, queryType)
	local page = baseList[queriedPage]
	local queryImages = self.queryImages[queryType]
	
	if not page then
		page = {}
		baseList[queriedPage] = page
		queryImages[queriedPage] = {}
	end
	
	local modsByID = self.modsByID
	local queryImagePage = queryImages[queriedPage]
	local noModTitle = _T("NO_MOD_TITLE", "No mod title")
	local maxLength = workshop.MAX_DESC_LENGTH
	local isSub = queryType == workshop.MOD_QUERY_TYPES.SUBSCRIBED
	local disabledMods = self.disabledMods
	
	for key, item in ipairs(data) do
		if not item.title then
			item.title = noModTitle
		end
		
		local tagList = string.explode(item.tags, ",")
		
		if #item.description == maxLength then
			item.description = item.description .. "..."
		end
		
		local id = item.id
		local modData = modsByID[id]
		
		if not modData then
			page[key] = item
			modData = item
			queryImagePage[#queryImagePage + 1] = id
			modData.preview = item.preview
			modData.tags = tagList
			modsByID[id] = item
		else
			if not modData.image then
				queryImagePage[#queryImagePage + 1] = id
			end
			
			modData.tags = tagList
			
			table.insert(page, modData)
		end
		
		if isSub and not disabledMods[id] then
			self:addActiveModData(modData.title, modData.id)
			print("active mod name!", modData.title, modData.id)
		end
	end
end

function workshop:addActiveModData(name, id)
	if id then
		table.insert(self.activeModData, {
			name,
			id
		})
	else
		table.insert(self.activeModData, {
			name
		})
	end
end

function workshop:findMissingMods(modList)
	local missingMods = {}
	local activeMods = self.activeModData
	
	for key, data in ipairs(modList) do
		local id = data[2]
		local found = false
		
		if id then
			for key, otherData in ipairs(activeMods) do
				if otherData[2] and otherData[2] == id then
					found = true
					
					break
				end
			end
		else
			local name = data[1]
			
			for key, otherData in ipairs(activeMods) do
				if otherData[1] == name then
					found = true
					
					break
				end
			end
		end
		
		if not found then
			table.insert(missingMods, data)
		end
	end
	
	return missingMods
end

function workshop:doesCreatedModPageExist(page)
	return self.createdMods[page] ~= nil
end

function workshop:doesSubscribedModPageExist(page)
	return self.subscribedMods[page] ~= nil
end

function workshop:getCreatedModList()
	return self.createdMods
end

function workshop:getSubscribedModList()
	return self.subscribedMods
end

function workshop:postKillModFrame()
	workshop:onCloseMenu()
end

function workshop:onCloseMenu()
	self.menuOpen = false
	self.createdModsScroll = nil
	self.subscribedModsScroll = nil
	self.nextModListPageButton = nil
end

function workshop:queryCreatedMods(page)
	print("woah", debug.traceback())
	
	if steam.QueryCreatedMods(page) then
		self.modQueryInProgress = workshop.MOD_QUERY_TYPES.SUBSCRIBED
		
		events:fire(workshop.EVENTS.MOD_QUERY_STARTED, page, workshop.MOD_QUERY_TYPES.SUBSCRIBED)
	end
end

function workshop:querySubscribedMods(page)
	if steam.QuerySubscribedMods(page) then
		self.modQueryInProgress = workshop.MOD_QUERY_TYPES.SUBSCRIBED
		
		events:fire(workshop.EVENTS.MOD_QUERY_STARTED, page, workshop.MOD_QUERY_TYPES.SUBSCRIBED)
	end
end

function workshop:getModQueryType()
	return self.modQueryInProgress
end

workshop.CREATED_MOD_ELEMENT = "WorkshopPublishedModDisplay"
workshop.SUBBED_MOD_ELEMENT = "WorkshopModDisplay"

function workshop:switchToCreatedModsTabCallback()
	workshop:setCurrentQueryType(workshop.MOD_QUERY_TYPES.PUBLISHED)
	
	if not workshop:doesCreatedModPageExist(1) then
		workshop:queryCreatedMods(1)
	else
		workshop:requestImage()
		events:fire(workshop.EVENTS.MOD_TAB_SWITCHED, workshop.MOD_QUERY_TYPES.PUBLISHED)
	end
	
	workshop:setCurrentPage(workshop.createdModsScroll:getPage())
end

function workshop:switchToSubscribedModsTabCallback()
	workshop:setCurrentQueryType(workshop.MOD_QUERY_TYPES.SUBSCRIBED)
	
	if not workshop:doesSubscribedModPageExist(1) then
		workshop:querySubscribedMods(1)
	else
		workshop:requestImage()
		events:fire(workshop.EVENTS.MOD_TAB_SWITCHED, workshop.MOD_QUERY_TYPES.SUBSCRIBED)
	end
	
	workshop:setCurrentPage(workshop.subbedModsScroll:getPage())
end

workshop.PUBLISH_NEW_HOVER_TEXT = {
	{
		font = "pix20",
		text = _T("WORKSHOP_PUBLISH_NEW_DESC", "Publish a new addon to the Steam Workshop")
	}
}

function workshop:createMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 500)
	frame:setFont("pix24")
	frame:setText(_T("WORKSHOP_MODS", "Mods"))
	
	frame.postKill = workshop.postKillModFrame
	
	local propSheet = gui.create("PropertySheet", frame)
	
	propSheet:setPos(_S(5), _S(35))
	propSheet:setSize(frame.rawW - 10, frame.rawH - 45)
	propSheet:setFont(fonts.get("pix24"))
	
	local createdModsPanel = gui.create("Panel")
	
	createdModsPanel:setSize(propSheet.rawW, propSheet.rawH - 30)
	
	createdModsPanel.shouldDraw = false
	
	local scrollbarPanel = gui.create("WorkshopScrollbarPanel", createdModsPanel)
	
	scrollbarPanel:setPos(0, _S(35))
	scrollbarPanel:setSize(createdModsPanel.rawW, createdModsPanel.rawH - 35)
	scrollbarPanel:setAdjustElementPosition(true)
	scrollbarPanel:setAdjustElementSize(true)
	scrollbarPanel:setSpacing(3)
	scrollbarPanel:setPadding(3, 3)
	scrollbarPanel:setTargetQuery(workshop.MOD_QUERY_TYPES.PUBLISHED)
	scrollbarPanel:setItemList(self.createdMods)
	
	local control = scrollbarPanel:createPageControls(createdModsPanel)
	
	control:setSize(220, 32)
	control:initButtons("bh22")
	scrollbarPanel:setPage(1)
	scrollbarPanel:setFillElementID(workshop.CREATED_MOD_ELEMENT)
	scrollbarPanel:createElementCache(workshop.CREATED_MOD_ELEMENT)
	scrollbarPanel:addDepth(100)
	scrollbarPanel:verifyButtons()
	
	local publishNew = gui.create("WorkshopNewModButton", createdModsPanel)
	
	publishNew:setPos(control.w + _S(5), 0)
	publishNew:setSize(frame.rawW - control.rawW - 15, 32)
	publishNew:setFont("bh24")
	publishNew:setText(_T("WORKSHOP_PUBLISH_NEW", "Publish new..."))
	publishNew:setHoverText(workshop.PUBLISH_NEW_HOVER_TEXT)
	
	self.createdModsScroll = scrollbarPanel
	
	local created = propSheet:addItem(createdModsPanel, _T("WORKSHOP_CREATED_MODS", "Created mods"), 154, 28, workshop.switchToCreatedModsTabCallback)
	
	created:setID(workshop.ELEMENT_IDS.CREATED_MODS)
	created:addHoverText(_T("WORKSHOP_CREATED_MODS_DESCRIPTION", "View all the mods you've created for Game Dev Studio"), "pix20")
	
	local subModsPanel = gui.create("Panel")
	
	subModsPanel:setSize(propSheet.rawW, propSheet.rawH - 30)
	
	subModsPanel.shouldDraw = false
	
	local subbedModsScroll = gui.create("WorkshopScrollbarPanel", subModsPanel)
	
	subbedModsScroll:setPos(0, _S(35))
	subbedModsScroll:setSize(subModsPanel.rawW, subModsPanel.rawH - 35)
	subbedModsScroll:setAdjustElementPosition(true)
	subbedModsScroll:setAdjustElementSize(true)
	subbedModsScroll:setSpacing(3)
	subbedModsScroll:setPadding(3, 3)
	subbedModsScroll:setTargetQuery(workshop.MOD_QUERY_TYPES.SUBSCRIBED)
	subbedModsScroll:setItemList(self.subscribedMods)
	subbedModsScroll:setMaxPages(math.ceil(steam.GetNumSubscribedItems() / workshop.ITEMS_PER_PAGE))
	
	self.subscribedModsScroll = subbedModsScroll
	
	local control = subbedModsScroll:createPageControls(subModsPanel)
	
	control:setSize(220, 32)
	control:initButtons("bh22")
	subbedModsScroll:setPage(1)
	subbedModsScroll:setFillElementID(workshop.SUBBED_MOD_ELEMENT)
	subbedModsScroll:createElementCache(workshop.SUBBED_MOD_ELEMENT)
	subbedModsScroll:addDepth(100)
	subbedModsScroll:verifyButtons()
	
	local nextB, prevB = control:getButtons()
	
	self.nextModListPageButton = nextB
	
	local subbed = propSheet:addItem(subModsPanel, _T("WORKSHOP_SUBSCRIBED_MODS", "Subscribed mods"), 154, 28, workshop.switchToSubscribedModsTabCallback)
	
	subbed:setID(workshop.ELEMENT_IDS.CREATED_MODS)
	subbed:addHoverText(_T("WORKSHOP_SUBSCRIBED_MODS_DESCRIPTION", "View all the mods you are currently subscribed to"), "pix20")
	
	self.subbedModsScroll = subbedModsScroll
	self.createdModsPage = 1
	self.subscribedModsPage = 1
	self.currentQuery = workshop.MOD_QUERY_TYPES.PUBLISHED
	
	self:setCurrentPage(1)
	
	self.menuOpen = true
	
	self:requestImage()
	frame:center()
	frameController:push(frame)
end

function workshop:finishCallback()
	workshop:startUploadingMod()
end

function workshop:finishUpdateCallback()
	workshop:startUpdatingMod()
end

function workshop.validFolderCallback(button)
	local data = workshop:getModUploadData()
	local folder = data.folder
	
	if data.createdPreviews then
		button.previewScroller:removeAllItems()
		
		data.createdPreviews = false
	end
	
	for key, item in ipairs(button.directoryScroller:getItems()) do
		if item.class == "WorkshopFolderSelection" then
			item:verifyDirectory()
		end
	end
	
	if not folder then
		button:setCanClick(false)
	elseif not workshop:getModDirectoryValidity(folder) then
		button:setCanClick(false)
		
		data.folder = nil
	else
		button:setCanClick(true)
	end
	
	button:setText(_T("NEXT", "Next"))
	
	return true
end

function workshop.validPreviewCallback(button)
	local data = workshop:getModUploadData()
	local preview = data.preview
	local idx = 1
	
	if not data.createdPreviews then
		local finalDir = data.folder .. "/"
		local scroll = button.previewScroller
		
		for key, file in ipairs(love.filesystem.getDirectoryItems(finalDir)) do
			if not love.filesystem.isDirectory(file) and workshop:isValidImageExtension(file) then
				local item = gui.create("WorkshopPreviewSelection")
				
				item:setBackColor(key % 2 == 0 and workshop.FOLDER_COLOR_TWO or workshop.FOLDER_COLOR_ONE)
				item:setHeight(22)
				item:setDirectory(finalDir .. file, file)
				item:setFont("bh18")
				scroll:addItem(item)
			end
		end
		
		data.createdPreviews = true
	else
		local idx = 1
		local items = button.previewScroller:getItems()
		
		for i = 1, #items do
			local item = items[idx]
			
			if item.class == "WorkshopPreviewSelection" then
				if item:verifyDirectory() then
					idx = idx + 1
				else
					item:kill()
				end
			else
				idx = idx + 1
			end
		end
	end
	
	if #button.previewScroller:getItems() == 0 then
		button:getParent():setPage(1)
	end
	
	if preview then
		if not love.filesystem.exists(preview) then
			button:setCanClick(false)
		else
			button:setCanClick(true)
		end
	else
		button:setCanClick(false)
	end
	
	button:setText(_T("NEXT", "Next"))
	
	return true
end

function workshop.finishSwitchCallback(button)
	local data = workshop:getModUploadData()
	
	workshop:verifyFinishClickability()
	button:setText(_T("FINISH", "Finish"))
	
	return true
end

function workshop:getModsDirectory(release)
	if release then
		return love.filesystem.getWorkingDirectory() .. "/"
	end
	
	return love.filesystem.getSource() .. "/"
end

function workshop:startUploadingMod()
	local data = self.modUploadData
	local source = workshop:getModsDirectory(RELEASE)
	
	self.itemCreationState = workshop.MOD_PUBLISH_STATES.CREATING
	
	self:lockNewModMenu()
	self:_writeMetaData()
	events:fire(workshop.EVENTS.ITEM_CREATION_STARTED)
	steam.BeginUploadingMod(data.title, "Change the description!", source .. data.folder .. workshop.MOD_FILES_FOLDER, source .. data.preview, self.modUploadData.tags)
end

function workshop:startUpdatingMod()
	local data = self.modUploadData
	local source = workshop:getModsDirectory(RELEASE)
	
	self.itemCreationState = workshop.MOD_PUBLISH_STATES.UPLOADING
	
	self:lockNewModMenu()
	self:_writeMetaData()
	events:fire(workshop.EVENTS.ITEM_UPDATE_STARTED)
	steam.StartModUpdate(data.id, data.title, source .. data.folder .. workshop.MOD_FILES_FOLDER, source .. data.preview, self.modUploadData.tags)
end

function workshop:_writeMetaData()
	local data = self.modUploadData
	local source = workshop:getModsDirectory(RELEASE) .. data.folder .. workshop.MOD_FILES_FOLDER
	local encoded = json:encode({
		title = data.title,
		time = os.time()
	})
	local hdl = io.open(source .. "metadata", "w")
	
	hdl:write(encoded)
	hdl:close()
end

function workshop:postKillModCreationFrame()
	workshop:onClosedNewModMenu()
end

function workshop:getNextPageButton()
	return self.nextPageButton
end

function workshop:onClosedNewModMenu()
	self.newModFrame = nil
	self.nextPageButton = nil
	self.prevPageButton = nil
	self.modUploadPageController = nil
	self.workshopNameTextbox = nil
	
	table.clearArray(self.tagElements)
end

workshop.FOLDER_COLOR_ONE = color(0, 0, 0, 50)
workshop.FOLDER_COLOR_TWO = color(0, 0, 0, 100)
workshop.AUTO_ADJUST_NAME_FONTS = {
	"bh24",
	"bh22",
	"bh20",
	"bh18",
	"bh16"
}

function workshop:getItemCreationState()
	return self.itemCreationState
end

function workshop:onCreatedItem()
	self.itemCreationState = workshop.MOD_PUBLISH_STATES.UPLOADING
	
	events:fire(workshop.EVENTS.ITEM_CREATED)
end

function workshop:onFailedCreateItem()
	self.itemCreationState = nil
	
	self:unlockNewModMenu()
	events:fire(workshop.EVENTS.ITEM_CREATION_FAILED)
end

function workshop:onUploadedItem()
	self.itemCreationState = nil
	
	timer.simple(1.5, function()
		if self.newModFrame then
			self.newModFrame:kill()
		end
	end)
	events:fire(workshop.EVENTS.ITEM_UPLOADED)
end

function workshop:onFailedUploadItem()
	self.itemCreationState = nil
	
	self:unlockNewModMenu()
	events:fire(workshop.EVENTS.ITEM_UPLOAD_FAILED)
end

function workshop:verifyFinishClickability()
	local canClick = true
	
	self.nextPageButton:clearInvalidityParameters()
	
	if #self.modUploadData.tags == 0 then
		canClick = false
		
		self.nextPageButton:addInvalidityParameters(_T("WORKSHOP_INVALIDITY_TAGS", "Must select at least one tag"))
	end
	
	if not self.modUploadData.title or #string.withoutspaces(self.modUploadData.title) == 0 then
		canClick = false
		
		self.nextPageButton:addInvalidityParameters(_T("WORKSHOP_INVALIDITY_TITLE", "Must set a proper workshop item name"))
	end
	
	self.nextPageButton:setCanClick(canClick)
	self.nextPageButton:queueSpriteUpdate()
end

function workshop:lockNewModMenu()
	local frame = self.newModFrame
	
	frame:getCloseButton():setCanClick(false)
	
	frame.closeViaEscape = false
	
	frame:queueSpriteUpdate()
	self.nextPageButton:setCanClick(false)
	self.nextPageButton:queueSpriteUpdate()
	self.prevPageButton:setCanClick(false)
	self.prevPageButton:queueSpriteUpdate()
	self.workshopNameTextbox:setCanClick(false)
	self.workshopNameTextbox:queueSpriteUpdate()
	
	for key, elem in ipairs(self.tagElements) do
		elem:setCanClick(false)
	end
end

function workshop:unlockNewModMenu()
	local frame = self.newModFrame
	
	if frame then
		frame:getCloseButton():setCanClick(true)
		
		frame.closeViaEscape = true
		
		frame:queueSpriteUpdate()
		self.nextPageButton:setCanClick(true)
		self.nextPageButton:queueSpriteUpdate()
		self.prevPageButton:setCanClick(true)
		self.prevPageButton:queueSpriteUpdate()
		self.workshopNameTextbox:setCanClick(true)
		self.workshopNameTextbox:queueSpriteUpdate()
		
		for key, elem in ipairs(self.tagElements) do
			elem:setCanClick(true)
			elem:queueSpriteUpdate()
		end
	end
end

workshop.failedToLoadHoverText = {
	{
		font = "pix20",
		wrapWidth = 350,
		text = _T("FAILED_TO_LOAD_DESCRIPTION", "These mods have failed to load due to an incorrectly set-up mod folder. (main.lua not found)")
	}
}

function workshop:createLocalModMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 500)
	frame:setFont("pix24")
	frame:setTitle(_T("LOCAL_MODS_TITLE", "Local Mods"))
	
	local scroll = gui.create("ScrollbarPanel", frame)
	
	scroll:setPos(_S(5), _S(35))
	scroll:setSize(390, 460)
	scroll:setAdjustElementPosition(true)
	scroll:setSpacing(3)
	scroll:setPadding(3, 3)
	
	local loadedCat = gui.create("Category")
	
	loadedCat:setSize(390, 28)
	loadedCat:setFont("pix24")
	loadedCat:setText(_T("LOADED_MODS", "Loaded mods"))
	loadedCat:assumeScrollbar(scroll)
	scroll:addItem(loadedCat)
	
	for key, folderName in ipairs(love.filesystem.loadedModDirectories) do
		local display = gui.create("LocalInstalledMod", scroll)
		
		display:setFont("bh20")
		display:setHeight(24)
		display:setFolderName(folderName)
		loadedCat:addItem(display)
	end
	
	if #love.filesystem.failedLoadModDirectories > 0 then
		local failedCat = gui.create("Category")
		
		failedCat:setSize(390, 28)
		failedCat:setFont("pix24")
		failedCat:setText(_T("FAILEDT_TO_LOAD_MODS", "Failed to load mods"))
		failedCat:assumeScrollbar(scroll)
		failedCat:setHoverText(workshop.failedToLoadHoverText)
		scroll:addItem(failedCat)
		
		for key, folderName in ipairs(love.filesystem.failedLoadModDirectories) do
			local display = gui.create("LocalInstalledMod", scroll)
			
			display:setFont("bh20")
			display:setHeight(24)
			display:setFolderName(folderName)
			failedCat:addItem(display)
		end
	end
	
	frame:center()
	frameController:push(frame)
end

function workshop:createNewModMenu(isUpdate, modData)
	self:initModUploadData()
	
	local frameTitle
	
	if isUpdate then
		self.modUploadData.id = modData.id
		frameTitle = _T("WORKSHOP_UPDATE_MOD_TITLE", "Update Mod")
	else
		frameTitle = _T("WORKSHOP_NEW_MOD_TITLE", "New Mod")
	end
	
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setSize(400, 500)
	frame:setText(frameTitle)
	
	frame.postKill = postKillModCreationFrame
	self.newModFrame = frame
	
	local closeButton = frame:getCloseButton()
	local closeX, closeY = closeButton:getPos()
	local help = gui.create("WorkshopModHelp", frame)
	
	help:setSize(closeButton.rawW, closeButton.rawH)
	help:setPos(closeX - help.w - _S(2), closeY)
	
	local pageCtrl = gui.create("PageController", frame)
	
	pageCtrl:setPos(_S(5), _S(35))
	pageCtrl:setSize(390, 460)
	
	self.modUploadPageController = pageCtrl
	
	local pageOne = pageCtrl:createPage(390, 430)
	local label = gui.create("Label", pageOne)
	
	label:setFont("bh20")
	label:setPos(0, 0)
	label:wrapText(frame.w - _S(10), _T("WORKSHOP_MOD_CREATION_STEP_ONE_DESC", "Please select the folder containing the mod files"))
	
	local infoLabel = gui.create("Label", pageOne)
	
	infoLabel:setFont("pix18")
	infoLabel:setPos(0, label.h)
	infoLabel:wrapText(frame.w - _S(10), _T("WORKSHOP_MOD_CREATION_STEP_ONE_DESC_2", "Mod folders should be placed within the 'mods_staging' folder in the root folder of the game.\nMod files should be positioned within the 'files' folder.\nFor example: 'mods_staging/myMod/files/'"))
	
	local dirScroll = gui.create("ScrollbarPanel", pageOne)
	
	dirScroll:setPos(0, infoLabel.h + infoLabel.y + _S(5))
	dirScroll:setSize(pageCtrl.rawW, pageOne.rawH - _US(dirScroll.localY) - 5)
	dirScroll:setAdjustElementPosition(true)
	dirScroll:setSpacing(3)
	dirScroll:setPadding(3, 3)
	dirScroll:addDepth(100)
	
	local stagingFolder = workshop.MOD_STAGING_FOLDER
	
	for key, file in ipairs(love.filesystem.getDirectoryItems(stagingFolder)) do
		local realFile = stagingFolder .. file
		
		if love.filesystem.isDirectory(realFile) then
			local selection = gui.create("WorkshopFolderSelection")
			
			selection:setBackColor(key % 2 == 0 and workshop.FOLDER_COLOR_TWO or workshop.FOLDER_COLOR_ONE)
			selection:setDirectory(realFile, file)
			selection:setHeight(22)
			selection:setFont("bh18")
			dirScroll:addItem(selection)
		end
	end
	
	pageCtrl:setPageButtonShowCallback(1, pageCtrl.BUTTONS.NEXT, workshop.validFolderCallback)
	
	local pageTwo = pageCtrl:createPage(390, 430)
	local label = gui.create("Label", pageTwo)
	
	label:setFont("bh20")
	label:setPos(0, 0)
	label:wrapText(frame.w - _S(10), _T("WORKSHOP_MOD_CREATION_STEP_TWO_DESC", "Select the preview file to use"))
	
	local infoLabel = gui.create("Label", pageTwo)
	
	infoLabel:setFont("pix18")
	infoLabel:setPos(0, label.h)
	infoLabel:wrapText(frame.w - _S(10), _T("WORKSHOP_MOD_CREATION_STEP_TWO_DESC_2", "This file will be used as the image people see when browsing for addons.\nAdd more pictures to your mod's folder to have more images to select."))
	
	local previewScroll = gui.create("ScrollbarPanel", pageTwo)
	
	previewScroll:setPos(0, infoLabel.h + infoLabel.y + _S(5))
	previewScroll:setSize(pageCtrl.rawW, pageOne.rawH - _US(previewScroll.localY) - 5)
	previewScroll:setAdjustElementPosition(true)
	previewScroll:setSpacing(3)
	previewScroll:setPadding(3, 3)
	previewScroll:addDepth(100)
	pageCtrl:setPageButtonShowCallback(2, pageCtrl.BUTTONS.NEXT, workshop.validPreviewCallback)
	
	local pageThree = pageCtrl:createPage(390, 430)
	local label = gui.create("Label", pageThree)
	
	label:setFont("bh20")
	label:setPos(0, 0)
	
	local text
	
	if isUpdate then
		text = _T("WORKSHOP_MOD_CREATION_STEP_THREE_DESC_UPDATE", "Change mod name (optional)")
	else
		text = _T("WORKSHOP_MOD_CREATION_STEP_THREE_DESC", "Enter the mod name (can be changed later)")
	end
	
	label:wrapText(frame.w - _S(10), text)
	
	local infoLabel = gui.create("Label", pageThree)
	
	infoLabel:setFont("pix18")
	infoLabel:setPos(0, label.h)
	
	local text
	
	if isUpdate then
		text = _T("WORKSHOP_MOD_CREATION_STEP_THREE_DESC_2_UPDATE", "The addon description will remain unchanged after updating the addon.")
	else
		text = _T("WORKSHOP_MOD_CREATION_STEP_THREE_DESC_2", "You will need to manually fill out the description on the Workshop page of your mod, as well as add any images and/or videos you wish to have.\nThe item's visibility will be set to 'private' upon publishing.")
	end
	
	infoLabel:wrapText(frame.w - _S(10), text)
	
	local textbox = gui.create("WorkshopModNameTextbox", pageThree)
	
	textbox:setPos(0, infoLabel.h + infoLabel.y + _S(5))
	textbox:setAutoAdjustFonts(workshop.AUTO_ADJUST_NAME_FONTS)
	textbox:setShouldCenter(true)
	textbox:setSize(390, 30)
	textbox:setMaxText(workshop.MAX_TITLE_LENGTH)
	
	if modData then
		self.modUploadData.title = modData.title
		self.modUploadData.tags = modData.tags
		
		textbox:setText(modData.title)
	end
	
	textbox:addDepth(200)
	
	self.workshopNameTextbox = textbox
	
	local label = gui.create("Label", pageThree)
	
	label:setFont("bh20")
	label:setPos(0, textbox.localY + textbox.h + _S(5))
	label:wrapText(frame.w - _S(10), _T("WORKSHOP_MOD_CREATION_STEP_THREE_DESC_3", "Select fitting tags (can be changed)"))
	
	local infoLabel = gui.create("Label", pageThree)
	
	infoLabel:setFont("pix18")
	infoLabel:setPos(0, label.localY + label.h)
	infoLabel:wrapText(frame.w - _S(10), _T("WORKSHOP_MOD_CREATION_STEP_THREE_DESC_4", "These are the tags that players will be able to search for mods by.\nPlease do not abuse them by selecting unfitting tags that mis-lead players about the real content of the mod."))
	
	local tagY = infoLabel.localY + infoLabel.h + _S(20)
	local elementSize = 24
	local elementSpace = 32
	local elementSpaceW = _S(180)
	
	self.tagElements = {}
	
	for key, tag in ipairs(workshop.TAG_ORDER) do
		local tagBox = gui.create("WorkshopTagCheckbox", pageThree)
		local x = 0
		
		if key % 2 == 0 then
			x = elementSpaceW
		end
		
		tagBox:setPos(x, tagY)
		
		if key % 2 == 0 then
			tagY = tagY + _S(elementSpace)
		end
		
		tagBox:setSize(elementSize, elementSize)
		tagBox:setText(workshop.TAG_TEXT[tag])
		tagBox:setTag(tag)
		
		self.tagElements[#self.tagElements + 1] = tagBox
	end
	
	local display = gui.create("WorkshopModUploadProgress", pageThree)
	
	display:setSize(390, 50)
	display:setFont("bh20")
	display:setText(_T("WORKSHOP_WAITING_FOR_INPUT", "Waiting for input"), true)
	display:setPos(0, tagY + _S(10))
	
	if isUpdate then
		pageCtrl:setPageButtonCallback(3, pageCtrl.BUTTONS.NEXT, workshop.finishUpdateCallback)
	else
		pageCtrl:setPageButtonCallback(3, pageCtrl.BUTTONS.NEXT, workshop.finishCallback)
	end
	
	pageCtrl:setPageButtonShowCallback(3, pageCtrl.BUTTONS.NEXT, workshop.finishSwitchCallback)
	
	self.nextPageButton = pageCtrl:initNextButton(_T("BUTTON_NEXT", "Next"), 100, 26, "WorkshopNextPageSwitchButton")
	self.nextPageButton.directoryScroller = dirScroll
	self.nextPageButton.previewScroller = previewScroll
	self.prevPageButton = pageCtrl:initPrevButton(_T("BUTTON_PREVIOUS", "Previous"), 100, 26)
	
	pageCtrl:positionButtons()
	
	local swlaLabel = gui.create("WorkshopLegalAgreementElement", pageThree)
	
	swlaLabel:setFont("bh18")
	swlaLabel:setPos(0, label.h)
	
	local text
	
	if isUpdate then
		text = _T("WORKSHOP_MOD_CREATION_LEGAL_AGREEMENT_UPDATE", "By updating this item, you agree to the Steam Workshop Legal Agreement.")
	else
		text = _T("WORKSHOP_MOD_CREATION_LEGAL_AGREEMENT", "By publishing this item, you agree to the Steam Workshop Legal Agreement.")
	end
	
	swlaLabel:wrapText(frame.w - _S(10), text)
	swlaLabel:setSize(390, _US(swlaLabel.h) + 8)
	swlaLabel:setPos(0, self.nextPageButton.localY - _S(5) - swlaLabel.h)
	pageCtrl:updateButtonStates()
	pageCtrl:setPage(1)
	frame:center()
	frameController:push(frame)
end

function workshop:autoGrabSubscribedMods()
	self.subModGrabPage = 1
	
	self:querySubscribedMods(self.subModGrabPage)
end

workshop:init()
