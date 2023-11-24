local md5 = require("engine/md5")

saveSnapshot = {}
saveSnapshot.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_YEAR
}
saveSnapshot.DIRECTORY = "snapshots/"
saveSnapshot.SAVE_SNAPSHOT_DIRECTORY = game.SAVE_DIRECTORY .. saveSnapshot.DIRECTORY

function saveSnapshot:init()
	self:initEventHandler()
end

function saveSnapshot:remove()
	self:removeEventHandler()
end

function saveSnapshot:disable()
	self.disabled = true
end

function saveSnapshot:enable()
	self.disabled = false
end

function saveSnapshot:initEventHandler()
	events:addDirectReceiver(self, saveSnapshot.CATCHABLE_EVENTS)
end

function saveSnapshot:removeEventHandler()
	events:removeDirectReceiver(self, saveSnapshot.CATCHABLE_EVENTS)
end

function saveSnapshot:handleEvent()
	if self.disabled then
		return 
	end
	
	self:saveNewYear()
end

function saveSnapshot:getSnapshotSavePath(hash)
	return saveSnapshot.SAVE_SNAPSHOT_DIRECTORY .. hash .. "/"
end

function saveSnapshot:getPlaythroughSnapshots(hash)
	return love.filesystem.getDirectoryItems(self:getSnapshotSavePath(hash))
end

eventBoxText:registerNew({
	id = "snapshot_saved",
	getText = function(self, data)
		return _T("SNAPSHOT_SAVED", "Start of new year - snapshot saved!")
	end
})

function saveSnapshot:saveNewYear()
	if not game.currentLoadedSaveFile then
		return 
	end
	
	if not game.playthroughHash then
		game.playthroughHash = self:generateHash()
		
		mainMenu:setupDesiredSaveName()
		game.beginSaving(game.getSaveFileName(game.desiredSaveName), nil, false)
		
		return 
	end
	
	local folderPath = self:getSnapshotSavePath(game.playthroughHash)
	local year = timeline:getYear() - game.curGametype:getStartTime() + 1
	
	love.filesystem.createDirectory(folderPath)
	game.save(folderPath .. year .. game.SAVE_FILE_FORMAT, true)
	game.addToEventBox("snapshot_saved", nil, 1)
end

function saveSnapshot:generateHash()
	return md5.sumhexa(game.curGametype:getID() .. tostring(os.time() + math.random()))
end
