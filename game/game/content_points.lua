contentPoints = {}
contentPoints.registered = {}
contentPoints.registeredByID = {}

function contentPoints:registerNew(data)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
end

function contentPoints:getData(pointID)
	return self.registeredByID[pointID]
end

contentPoints:registerNew({
	id = "campaign",
	display = _T("CONTENT_TYPE_CAMPAIGN", "Campaign")
})
contentPoints:registerNew({
	id = "gameplay",
	display = _T("CONTENT_TYPE_GAMEPLAY", "Gameplay")
})
contentPoints:registerNew({
	id = "cosmetics",
	display = _T("CONTENT_TYPE_COSMETICS", "Cosmetics")
})
