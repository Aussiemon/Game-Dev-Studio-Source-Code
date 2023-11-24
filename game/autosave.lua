autosave = {}
autosave.DEFAULT_SAVE_PERIOD = 5
autosave.MAX_SAVE_PERIOD = 10
autosave.SAVE_PERIOD_BASE_VALUE = 60
autosave.savePeriod = autosave.SAVE_PERIOD_BASE_VALUE * autosave.DEFAULT_SAVE_PERIOD
autosave.enabled = true
autosave.blockers = {}
autosave.timeProgress = 0
autosave.APPEND_STRING = "_autosave"
autosave.APPEND_STRING_FINAL = autosave.APPEND_STRING .. game.SAVE_FILE_FORMAT
autosave.ON_AUTOSAVE_STRING = _T("GAME_AUTOSAVED", "Game has been auto-saved.")

function autosave:init()
	self.timeProgress = 0
	self.blockers = {}
	
	self:updateBlockedState()
end

function autosave:remove()
	self.timeProgress = 0
	
	table.clear(self.blockers)
	self:updateBlockedState()
end

function autosave:addBlocker(blocker)
	if self:getBlocker(blocker) then
		return 
	end
	
	table.insert(self.blockers, blocker)
	self:updateBlockedState()
end

function autosave:removeBlocker(blocker)
	local foundBlocker, key = self:getBlocker(blocker)
	
	if foundBlocker then
		table.remove(self.blockers, key)
		self:updateBlockedState()
	end
end

function autosave:getBlocker(blocker)
	for key, object in ipairs(self.blockers) do
		if object == blocker then
			return object, key
		end
	end
	
	return nil, nil
end

function autosave:updateBlockedState()
	self.blockedAutosave = #self.blockers > 0
end

function autosave:setSavePeriod(period)
	self.savePeriod = period
	self.finalSavePeriod = self.SAVE_PERIOD_BASE_VALUE * period
end

function autosave:getSavePeriod()
	return self.savePeriod
end

function autosave:update(dt)
	if self.enabled and not self.blockedAutosave then
		self.timeProgress = self.timeProgress + dt
		
		if self.timeProgress >= self.finalSavePeriod then
			self:perform()
			
			self.timeProgress = self.timeProgress - self.finalSavePeriod
		end
	end
end

function autosave:enable()
	self.enabled = true
end

function autosave:disable()
	self.enabled = false
	self.timeProgress = 0
end

eventBoxText:registerNew({
	id = "game_autosaved",
	getText = function(self, data)
		return autosave.ON_AUTOSAVE_STRING
	end
})

function autosave:perform()
	if game.currentLoadedSaveFile ~= nil then
		game.save(string.gsub(game.currentLoadedSaveFile or game.getSaveFileName(), game.SAVE_FILE_FORMAT, autosave.APPEND_STRING_FINAL), true)
	else
		game.save(game.getSaveFileName())
	end
	
	game.addToEventBox("game_autosaved", nil, 1)
end

autosave:setSavePeriod(autosave.DEFAULT_SAVE_PERIOD)
