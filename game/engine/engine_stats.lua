engineStats = {}
engineStats.registered = {}
engineStats.registeredByID = {}
engineStats.DEFAULT_MAX = 1

function engineStats:registerNew(data)
	table.insert(engineStats.registered, data)
	
	engineStats.registeredByID[data.id] = data
	data.startLevel = data.startLevel or 0
	data.maxLevel = data.maxLevel or engineStats.DEFAULT_MAX
end

function engineStats:initializeStatStructure(engineObj, targetList)
	for key, data in ipairs(engineStats.registered) do
		targetList[data.id] = data.startLevel
	end
	
	return targetList
end

function engineStats:fillDescbox(projectObject, descBox, font, wrapWidth, iconSize)
	local curStats = projectObject:getRevisionStats(projectObject:getRevision())
	
	for key, statData in ipairs(engineStats.registered) do
		descBox:addText(_format(_T("ENGINE_STAT_LEVEL", "NAME - STAT%"), "NAME", statData.display, "STAT", math.round(curStats[statData.id] * 100)), font, nil, 0, wrapWidth, statData.icon, iconSize, iconSize)
	end
	
	if not projectObject:isLicenseable() then
		descBox:addText(_format(_T("ENGINE_REVISION_COUNT", "REVISIONS Revisions"), "REVISIONS", projectObject:getRevisionCount()), font, nil, 0, wrapWidth)
	end
	
	descBox:addText(_format(_T("ENGINE_FEATURE_COUNT", "FEATURES Features"), "FEATURES", projectObject:getFeatureCount()), font, game.UI_COLORS.IMPORTANT_1, 0, wrapWidth)
end

engineStats:registerNew({
	startLevel = 0,
	attractiveness = 10,
	id = "performance",
	icon = "performance",
	display = _T("PERFORMANCE", "Performance"),
	description = _T("ENGINE_PERFORMANCE_DESCRIPTION", "How well the internal systems of this game engine perform. Directly contributes to game review score."),
	barColor = color(209, 255, 183, 255)
})
engineStats:registerNew({
	startLevel = 0,
	attractiveness = 20,
	id = "easeOfUse",
	icon = "ease_of_use",
	display = _T("EASE_OF_USE", "Ease of Use"),
	description = _T("ENGINE_EASE_OF_USE_DESCRIPTION", "Determines how easy the engine is to use when creating content. Affects game development speed."),
	barColor = color(165, 205, 255, 255)
})
engineStats:registerNew({
	startLevel = 1,
	attractiveness = 0,
	id = "integrity",
	icon = "wrench",
	display = _T("INTEGRITY", "Integrity"),
	description = _T("ENGINE_INTEGRITY_DESCRIPTION", "Governs how tidy the engine code is. Determines how much time it takes to implement a new feature or revamp an engine."),
	barColor = color(255, 240, 132, 255)
})
