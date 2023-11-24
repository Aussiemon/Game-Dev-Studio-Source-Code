local deleteButton = {}

deleteButton.skinPanelFillColor = color(100, 100, 100, 255)
deleteButton.skinPanelHoverColor = color(255, 255, 255, 255)

function deleteButton:updateSprites()
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "delete", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
end

function deleteButton:onMouseEntered()
	deleteButton.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("DELETE_SAVEFILE", "Delete savefile"), "bh24", nil, 0, 500)
	self.descBox:positionToMouse(_S(10), _S(10))
end

function deleteButton:onMouseLeft()
	deleteButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function deleteButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:createSavefileDeletionPopup()
	end
end

function deleteButton:deleteSavefileCallback()
	if self.isSnapshot then
		game.deleteSavefile(self.pathToFolder, self.fileName, self.previewData and self.previewData.playthroughHash, true)
	else
		game.deleteSavefile(self.pathToFolder, self.fileName, nil, false)
	end
end

function deleteButton:deleteSavefileAndSnapshotsCallback()
	game.deleteSavefile(self.pathToFolder, self.fileName, self.previewData and self.previewData.playthroughHash, self.isSnapshot)
end

deleteButton.snapshotFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "Вы уверены что хотите стереть это сохранение?\nВы также сотрёте %s ежегодных сохранений", "Вы уверены что хотите стереть это сохранение?\nВы также сотрёте %s ежегодные сохранения", "Вы уверены что хотите стереть это сохранение?\nВы также сотрёте %s ежегодное сохранение", true)
	end
}

function deleteButton:createSavefileDeletionPopup()
	local title, text
	
	self.previewData = self.parent:getPreviewData()
	
	local isSnapshot = self.parent:getIsSnapshot()
	local snapshotCount = 0
	
	if isSnapshot then
		title = _T("DELETE_SNAPSHOT_SAVEFILE_TITLE", "Delete Snapshot Savefile")
		text = _T("DELETE_SNAPSHOT_SAVEFILE_DESC", "Are you sure you wish to delete this snapshot?")
	else
		title = _T("DELETE_SAVEFILE_TITLE", "Delete Savefile")
		
		if self.previewData and self.previewData.playthroughHash then
			local snapshotSavefiles = saveSnapshot:getPlaythroughSnapshots(self.previewData.playthroughHash)
			
			if #snapshotSavefiles > 0 then
				snapshotCount = #snapshotSavefiles / 2
				
				local method = deleteButton.snapshotFormatMethods[translation.currentLanguage]
				
				if method then
					text = method(snapshotCount)
				elseif snapshotCount == 1 then
					text = _T("DELETE_SAVEFILE_AND_SNAPSHOT_DESC", "Are you sure you wish to delete this savefile?\nDeleting it will also delete 1 snapshot.")
				else
					text = _format(_T("DELETE_SAVEFILE_AND_SNAPSHOTS_DESC", "Are you sure you wish to delete this savefile?\nDeleting it will also delete AMOUNT snapshots."), "AMOUNT", snapshotCount)
				end
			else
				text = _T("DELETE_SAVEFILE_DESC", "Are you sure you wish to delete this savefile?")
			end
		else
			text = _T("DELETE_SAVEFILE_DESC", "Are you sure you wish to delete this savefile?")
		end
	end
	
	local popup = game.createPopup(500, title, text, "pix24", "pix20", true)
	local button = popup:addButton("pix20", _T("DELETE_SAVEFILE", "Delete savefile"), deleteButton.deleteSavefileCallback)
	
	button.isSnapshot = isSnapshot
	button.previewData = self.previewData
	button.pathToFolder = self.parent:getPathToFolder()
	button.fileName = self.parent:getFileName()
	
	if snapshotCount > 0 then
		local button = popup:addButton("pix20", _T("DELETE_SAVEFILE_AND_SNAPSHOTS", "Delete savefile & snapshots"), deleteButton.deleteSavefileAndSnapshotsCallback)
		
		button.isSnapshot = isSnapshot
		button.previewData = self.previewData
		button.pathToFolder = self.parent:getPathToFolder()
		button.fileName = self.parent:getFileName()
	end
	
	local button = popup:addButton("bh20", _T("CANCEL", "Cancel"))
	
	popup:center()
	frameController:push(popup)
end

gui.register("SaveGameDeleteButton", deleteButton, "GenericElement")
