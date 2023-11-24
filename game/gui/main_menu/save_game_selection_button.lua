local saveSelect = {}

saveSelect.MAIN_PAD = 4
saveSelect.SCREENSHOT_PAD = 1

function saveSelect:init()
	self:setFont(fonts.get("pix24"))
	
	self.titleFont = fonts.get("bh22")
end

function saveSelect:createDeleteButton()
	self.deleteButton = gui.create("SaveGameDeleteButton", self)
	
	self.deleteButton:setSize(24, 24)
end

function saveSelect:setCanDeleteSavefiles(can)
	self.canDeleteSavefiles = can
	
	if can then
		self:createDeleteButton()
	end
end

function saveSelect:loadSelectionCallback()
	if self.option:verifyActiveMods() then
		self.option:loadSavefile()
	end
end

function saveSelect:loadSnapshotCallback()
	self.option:openSnapshotMenu()
end

function saveSelect:ignoreWarningLoadCallback()
	self.saveElement:loadSavefile(true)
end

function saveSelect:verifyActiveMods()
	if self.previewData then
		local modData = self.previewData.activeModData
		
		if modData then
			local missingMods = workshop:findMissingMods(modData)
			
			if #missingMods > 0 then
				local popup = gui.create("DescboxPopup")
				
				popup:setWidth(500)
				popup:setFont("pix24")
				popup:setTitle(_T("MISSING_MODS_TITLE", "Missing Mods"))
				popup:setTextFont("pix20")
				popup:setText(_T("MISSING_MODS_DESC_1", "This savefile relies on content added by mods that are no longer present. The savefile is not guaranteed to be stable. Below is a list of the missing mods."))
				
				local left, right, extra = popup:getDescboxes()
				
				extra:addSpaceToNextText(310)
				extra:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
				extra:addText(_T("MISSING_MODS_DESC_2", "The savefile is not guaranteed to load, and even if it does long term stability of the game on this particular playthrough is not guaranteed either."), "bh18", game.UI_COLORS.RED, 6, popup.rawW - 20, "exclamation_point_red", 22, 22)
				extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
				extra:addText(_T("MISSING_MODS_DESC_3", "When removing mods it is recommended to start a new playthrough instead."), "bh18", game.UI_COLORS.LIGHT_BLUE, 4, popup.rawW - 20, "question_mark", 22, 22)
				
				local button = popup:addButton("pix20", _T("MISSING_MODS_LOAD_SAVEFILE", "I don't care, load it!"), saveSelect.ignoreWarningLoadCallback)
				
				button.saveElement = self
				
				popup:addButton("pix20", _T("MISSING_MODS_GO_BACK", "Go back"))
				
				local scroller = gui.create("ScrollbarPanel", popup)
				
				scroller:setSize(490, 300)
				scroller:setPos(_S(5), _S(40) + popup.textHeight)
				scroller:setSpacing(3)
				scroller:setPadding(3, 3)
				scroller:setAdjustElementSize(true)
				scroller:setAdjustElementPosition(true)
				scroller:addDepth(100)
				
				local workshopMods = gui.create("Category")
				
				workshopMods:setSize(300, 26)
				workshopMods:setFont("bh24")
				workshopMods:setText(_T("WORKSHOP_MODS", "Workshop Mods"))
				workshopMods:assumeScrollbar(scroller)
				scroller:addItem(workshopMods)
				
				local localMods = gui.create("Category")
				
				localMods:setSize(300, 26)
				localMods:setFont("bh24")
				localMods:setText(_T("LOCAL_MODS", "Local Mods"))
				localMods:assumeScrollbar(scroller)
				scroller:addItem(localMods)
				
				for key, data in ipairs(missingMods) do
					local display = gui.create("LocalInstalledMod", scroll)
					
					display:setFont("bh20")
					display:setHeight(24)
					display:setFolderName(data[1])
					
					if data[2] then
						workshopMods:addItem(display, true)
					else
						localMods:addItem(display, true)
					end
				end
				
				popup:center()
				frameController:push(popup)
				
				return false
			end
		end
	end
	
	return true
end

function saveSelect:onSizeChanged()
	local smallest = math.min(self.rawW, self.rawH)
	local baseSpriteSize = smallest - saveSelect.MAIN_PAD * 2
	local underWidth = baseSpriteSize / 0.5625
	
	self.screenshotBorderWidth = _S(underWidth)
	self.screenshotBorderHeight = underHeight
	
	local scaledPad = _S(saveSelect.MAIN_PAD)
	
	self.baseTextX = self.screenshotBorderWidth + scaledPad * 2
	self.baseTextY = scaledPad
	
	if self.deleteButton then
		self.deleteButton:setPos(self.w - _S(5) - self.deleteButton.w, _S(3))
	end
	
	if self.title then
		self.showTitle = string.cutToWidth(self.title, self.titleFont, self.w - _S(30) - self.baseTextX)
	end
end

function saveSelect:onShow()
	self:verifyScreenshot()
end

function saveSelect:verifyScreenshot()
	if not self.screenshotImage and self.previewData and self.previewData.screenshot then
		self.screenshotImageData = love.image.newImageData(self.previewData.screenW, self.previewData.screenH, self.previewData.screenshot)
		self.screenshotImage = love.graphics.newImage(self.screenshotImageData)
	end
end

function saveSelect:fillInteractionComboBox(comboBox)
	local loadOption = comboBox:addOption(0, 0, 200, 18, _T("LOAD_SAVEFILE", "Load this savefile"), fonts.get("pix20"), saveSelect.loadSelectionCallback)
	
	loadOption.option = self
	
	local loadSnapshotOption = comboBox:addOption(0, 0, 200, 18, _T("LOAD_SNAPSHOT", "Load snapshot..."), fonts.get("pix20"), saveSelect.loadSnapshotCallback)
	
	loadSnapshotOption.option = self
end

function saveSelect:setIsSnapshot(state)
	self.isSnapshot = state
end

function saveSelect:getIsSnapshot()
	return self.isSnapshot
end

function saveSelect:getPreviewData()
	return self.previewData
end

function saveSelect:onClick(x, y, key)
	if self.isSnapshot and self:verifyActiveMods() then
		self:loadSavefile()
		
		return 
	end
	
	if not self.previewData or not self.previewData.playthroughHash then
		self:loadSavefile()
		
		return 
	end
	
	local snapshotFolderContents = saveSnapshot:getPlaythroughSnapshots(self.previewData.playthroughHash)
	
	if #snapshotFolderContents > 0 then
		interactionController:startInteraction(self, x - _S(20), y)
	else
		self:loadSavefile()
	end
end

function saveSelect:loadSavefile()
	mainMenu:closeLoadMenu()
	game.load(self.pathToFolder .. self.file, self.previewData and self.previewData.playthroughHash, self.isSnapshot)
end

function saveSelect:getPathToFolder()
	return self.pathToFolder
end

function saveSelect:getFileName()
	return self.fileName
end

function saveSelect:openSnapshotMenu()
	mainMenu:createLoadMenu(nil, saveSnapshot:getPlaythroughSnapshots(self.previewData.playthroughHash), saveSnapshot:getSnapshotSavePath(self.previewData.playthroughHash), _T("SELECT_SNAPSHOT", "Select snapshot"), true, self.canDeleteSavefiles)
end

function saveSelect:setSavegameIndex(index)
	self.index = index
end

function saveSelect:updateSprites()
	saveSelect.baseClass.updateSprites(self)
	
	local scaledPad = _S(saveSelect.MAIN_PAD)
	local smallest = math.min(self.rawW, self.rawH)
	local baseSpriteSize = smallest - saveSelect.MAIN_PAD * 2
	local underWidth, underHeight = baseSpriteSize / 0.5625, baseSpriteSize
	
	self:setNextSpriteColor(0, 0, 0, 150)
	
	self.underScreenshotSprite = self:allocateSprite(self.underScreenshotSprite, "generic_1px", scaledPad, scaledPad, 0, underWidth, underHeight, 0, 0, -0.1)
	
	if not self.screenshotImage then
		local iconSize = 40
		
		self.warningSprite = self:allocateSprite(self.warningSprite, "attention_red", _S(underWidth * 0.5 - iconSize * 0.5) + scaledPad, _S(underHeight * 0.5 - iconSize * 0.5) + scaledPad, 0, iconSize, iconSize, 0, 0, -0.05)
	end
end

function saveSelect:onKill()
	if self.screenshotImage then
		self.screenshotImage = nil
		
		self.screenshotImageData:destroy()
		
		self.screenshotImageData = nil
	end
end

function saveSelect:setFile(file, pathToFolder)
	self.file = file
	self.fileName = string.gsub(self.file, game.SAVE_FILE_FORMAT, "")
	self.pathToFolder = pathToFolder
	self.previewFile = game.getPreviewFile(pathToFolder .. file)
	
	local previewData, failReason = game.readSavePreview(self.previewFile)
	
	self.previewData = previewData
	
	if self.previewData then
		local employeeText = self.previewData.employeeCount == 1 and _T("SINGULAR_EMPLOYEE", "Employee") or _T("PLURAL_EMPLOYEES", "Employees")
		
		self.description = string.easyformatbykeys(_T("SAVEGAME_PREVIEW_LAYOUT", "CASH, EMPLOYEES EMPLOYEE_TEXT\nGame date: GAMEYEAR/GAMEMONTH\nSave date: SAVEDATE"), "CASH", string.roundtobigcashnumber(self.previewData.funds), "EMPLOYEES", self.previewData.employeeCount, "EMPLOYEE_TEXT", employeeText, "SAVEDATE", os.date("%x %H:%M:%S", self.previewData.saveDate), "GAMEYEAR", timeline:getYear(self.previewData.gameTime), "GAMEMONTH", timeline:getMonth(self.previewData.gameTime))
	else
		self.description = failReason or _T("SAVEGAME_PREVIEW_FILE_NOT_FOUND", "Preview file not found!")
	end
	
	local baseText = self.fileName
	
	if self.isSnapshot then
		self.title = _format(_T("SNAPSHOT_SAVEFILE_TITLE", "Snapshot SNAP"), "SNAP", baseText)
	else
		self.title = baseText
	end
end

function saveSelect:getPreviewData()
	return self.previewData
end

function saveSelect:draw(w, h)
	local mainFont = self.titleFont
	
	love.graphics.setFont(mainFont)
	love.graphics.printST(self.showTitle, self.baseTextX, self.baseTextY, 255, 255, 255, 255, 0, 0, 0, 255)
	love.graphics.setFont(fonts.get("pix20"))
	love.graphics.printST(self.description, self.baseTextX, self.baseTextY + mainFont:getHeight(), 255, 255, 255, 255, 0, 0, 0, 255)
	
	if self.screenshotImage then
		local scaledScreenshotPad = math.ceil(_S(saveSelect.SCREENSHOT_PAD))
		local w, h = self.screenshotImage:getScaleToSize(self.screenshotBorderWidth - scaledScreenshotPad * 4)
		
		love.graphics.draw(self.screenshotImage, self.baseTextY + scaledScreenshotPad * 2, self.baseTextY + scaledScreenshotPad, 0, w, h)
	end
end

gui.register("SaveGameSelectionButton", saveSelect, "Button")
