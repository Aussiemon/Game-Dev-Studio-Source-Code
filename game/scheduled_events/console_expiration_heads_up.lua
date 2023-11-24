local consoleExpirationHeadsUp = {}

consoleExpirationHeadsUp.id = "console_expiration_heads_up"
consoleExpirationHeadsUp.platformID = nil
consoleExpirationHeadsUp.inactive = true

function consoleExpirationHeadsUp:validateEvent()
	return scheduledEvents.activatedEvents[self.id]
end

function consoleExpirationHeadsUp:getTitle()
	if not self.canDisplayText then
		return nil
	end
	
	return _T("CONSOLE_EXPIRATION_NOTIFICATION_TITLE", "Console expiration heads-up")
end

function consoleExpirationHeadsUp:getText()
	local platformObj = platformShare:getPlatformByID(self.platformID)
	
	if not platformObj then
		return nil
	end
	
	local data = platformObj:getPlatformData()
	
	return _format(_T("CONSOLE_EXPIRATION_NOTIFICATION_DESC", "'MANUFACTURER' has notified you that their 'PLATFORM' game platform will not be supported after YEAR/MONTH. After the support for it is dropped, it will stay on market for TIME."), "MANUFACTURER", platformObj:getManufacturer():getName(), "PLATFORM", platformObj:getName(), "YEAR", data.expiryDate.year, "MONTH", data.expiryDate.month, "TIME", timeline:getTimePeriodText(data.postExpireOnMarketTime))
end

function consoleExpirationHeadsUp:activate()
	local platformObj = platformShare:getPlatformByID(self.platformID)
	
	if platformObj and platformObj:getPlayerMadeGames() > 0 and platformObj:getManufacturer() then
		self.canDisplayText = true
	end
	
	consoleExpirationHeadsUp.baseClass.activate(self)
end

scheduledEvents:registerNew(consoleExpirationHeadsUp, "generic_timed_popup")
