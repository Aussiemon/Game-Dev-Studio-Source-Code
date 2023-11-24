projectReview = {}
projectReview.mtindex = {
	__index = projectReview
}
projectReview.CON_QUALITY_CUTOFF = 0.4
projectReview.AVG_QUALITY_CUTOFF = 0.75
projectReview.AVERAGE_GAME_RATING_CUTOFF = 5
projectReview.PERFECT_GAME_RATING_CUTOFF = 10
projectReview.GOOD_GAME_RATING_CUTOFF = 8
projectReview.ABOVE_AVERAGE_RATING_CUTOFF = 7
projectReview.FEATURES_TYPE = {
	BEST = 1,
	AVG = 2,
	WORST = 3
}
projectReview.CON_DISPLAY_PRIORITY = 75
projectReview.MAX_REMARKS_TO_SHOW = 3
projectReview.MAX_DISPLAYED_QUALITY_LEVEL = 100
projectReview.EVENTS = {
	OPENED = events:new(),
	CLOSED = events:new()
}
projectReview.REVIEW_TEXT_TEMPLATE = "OVERALL_GOOD OR BAD_REMARK_IN CLOSING_"
projectReview.BASE_QUALITY_TEXT = {
	{
		_T("GAME_VERDICT_1", "'GAME' was complete garbage")
	},
	{
		_T("GAME_VERDICT_2", "'GAME' was really bad")
	},
	{
		_T("GAME_VERDICT_3", "'GAME' was bad")
	},
	{
		_T("GAME_VERDICT_4", "'GAME' was not good")
	},
	{
		_T("GAME_VERDICT_5", "'GAME' was average")
	},
	{
		_T("GAME_VERDICT_6", "'GAME' was ok")
	},
	{
		_T("GAME_VERDICT_7", "'GAME' was decent")
	},
	{
		_T("GAME_VERDICT_8", "'GAME' was good")
	},
	{
		_T("GAME_VERDICT_9", "'GAME' was great")
	},
	{
		_T("GAME_VERDICT_10", "'GAME' was amazing")
	}
}
projectReview.FINAL_SCORE_TEXT = {
	_T("GAME_FINAL_SCORE_TEXT_1", "Final score: SCORE/10"),
	_T("GAME_FINAL_SCORE_TEXT_2", "Our score: SCORE/10"),
	_T("GAME_FINAL_SCORE_TEXT_3", "Final verdict: SCORE/10"),
	_T("GAME_FINAL_SCORE_TEXT_4", "Our score: SCORE/10"),
	_T("GAME_FINAL_SCORE_TEXT_5", "Final rating: SCORE/10"),
	_T("GAME_FINAL_SCORE_TEXT_6", "Our rating: SCORE/10"),
	_T("GAME_FINAL_SCORE_TEXT_7", "We give it: SCORE/10")
}
projectReview.NO_ISSUES_TEXT = {
	_T("GAME_NO_ISSUES_1", "there are no problems with the game. 'STUDIO' have done an absolutely amazing job with the game."),
	_T("GAME_NO_ISSUES_2", "there isn't a single thing I can complain about, the game is absolutely fantastic, you owe the experiece it provides to yourself and 'STUDIO' deserves any praise they get."),
	_T("GAME_NO_ISSUES_3", "'STUDIO' can be proud, games like this are a rare sight - it is absolutely flawless."),
	_T("GAME_NO_ISSUES_4", "if it were up to me, I would give this game a Game of the Year award right now. Great job, 'STUDIO'!")
}
projectReview.GOOD_STUFF_TEXT = {
	_T("GAME_GOOD_STUFF_1", "there aren't any major issues that I can point out, 'STUDIO' did a good job."),
	_T("GAME_GOOD_STUFF_2", "the game holds it ground. Sure, it may have a small issue here and there, but nothing that would make it unenjoyable. Good job, 'STUDIO'."),
	_T("GAME_GOOD_STUFF_3", "'STUDIO' knew what they were doing, since, off the top of my head, I can't think of anything that would make my game experience bad.")
}
projectReview.ABOVE_AVERAGE_TEXT = {
	_T("GAME_ABOVE_AVERAGE_1", "while it's clear 'STUDIO' has effort put into the game, but we think the priorities for the it were a bit wrong."),
	_T("GAME_ABOVE_AVERAGE_2", "but does this make 'STUDIO''s latest game bad? No. Can it be considered above average? Sure!"),
	_T("GAME_ABOVE_AVERAGE_3", "don't go in expecting a masterpiece, but expect to have fun nonetheless. Not bad, 'STUDIO'.")
}
projectReview.AVERAGE_STUFF_TEXT = {
	_T("GAME_AVERAGE_STUFF_1", "as unfortunate as it is, 'STUDIO''s latest game can be considered average."),
	_T("GAME_AVERAGE_STUFF_2", "and while 'STUDIO''s newest game does have interesting concepts and ideas, it still falls short."),
	_T("GAME_AVERAGE_STUFF_3", "there was clear passion and effort put into the game, but we feel that the overall experience is average. Better luck next time, 'STUDIO'.")
}
projectReview.BAD_STUFF_TEXT = {
	_T("GAME_BAD_STUFF_1", "we do not know whether 'STUDIO' rushed their new game out out or was done with a lack of experience, but unfortunately, it is not a very good experience."),
	_T("GAME_BAD_STUFF_2", "'STUDIO''s newest game is less than stellar and as it is, I can not recommend it."),
	_T("GAME_BAD_STUFF_3", "to put it bluntly, the game is barely (if not at all for some people) enjoyable. For shame, 'STUDIO'.")
}
projectReview.remarks = {}
projectReview.remarksByID = {}
projectReview.registeredConclusions = {}
projectReview.registeredConclusionsByID = {}

local defaultRemarkFuncs = {}

defaultRemarkFuncs.mtindex = {
	__index = defaultRemarkFuncs
}

function defaultRemarkFuncs:onPicked()
end

function projectReview:registerRemark(remark)
	table.insert(projectReview.remarks, remark)
	
	projectReview.remarksByID[remark.id] = remark
	
	setmetatable(remark, defaultRemarkFuncs.mtindex)
end

function projectReview.new(reviewer)
	local new = {}
	
	setmetatable(new, projectReview.mtindex)
	new:init(reviewer)
	
	return new
end

local placeRemarks = {}

function projectReview:pickValidRemarks()
	table.clear(placeRemarks)
	
	local totalWeight, remarkCount = 0, 0
	
	for key, remarkData in ipairs(projectReview.remarks) do
		local list = {}
		
		remarkData:attemptAdd(self, list)
		
		if #list > 0 then
			totalWeight = totalWeight + 1
			placeRemarks[remarkData.id] = list
			list.weight = list.weight or 1
			list.startWeight = totalWeight
			list.finishWeight = list.startWeight + list.weight
			totalWeight = totalWeight + list.weight
			remarkCount = remarkCount + 1
		end
	end
	
	return placeRemarks, totalWeight, remarkCount
end

local defaultConclusionFuncs = {}

defaultConclusionFuncs.mtindex = {
	__index = defaultConclusionFuncs
}

function defaultConclusionFuncs:addToDescbox(descbox, wrapWidth)
end

function projectReview:registerConclusion(conclusion)
	table.insert(projectReview.registeredConclusions, conclusion)
	
	projectReview.registeredConclusionsByID[conclusion.id] = conclusion
	
	setmetatable(conclusion, defaultConclusionFuncs.mtindex)
end

local function readReview(self)
	self.review:createReviewPopup()
end

function projectReview:fillInteractionComboBox(comboBox)
	local option = comboBox:addOption(0, 0, 0, 24, _T("READ_REVIEW", "Read review"), fonts.get("pix20"), readReview)
	
	option.review = self
end

function projectReview:init(reviewer)
	self.reviewer = reviewer
	self.pros = {}
	self.cons = {}
	self.avgs = {}
	self.remarks = {}
end

function projectReview:setReviewer(reviewer)
	self.reviewer = reviewer
end

function projectReview:getReviewer()
	return self.reviewer
end

function projectReview:setProject(proj)
	self.project = proj
	
	self:generateProsAndCons(proj)
	
	local validRemarks, totalWeight, remarkCount = self:pickValidRemarks()
	local currentWeight = totalWeight
	
	for i = 1, math.min(remarkCount, projectReview.MAX_REMARKS_TO_SHOW) do
		local rolledWeight = math.random(1, currentWeight)
		local pickedRemarkID, pickedRemarkData
		
		for remarkID, remarkData in pairs(validRemarks) do
			if rolledWeight >= remarkData.startWeight and rolledWeight <= remarkData.finishWeight then
				pickedRemarkID = remarkID
				pickedRemarkData = remarkData
				validRemarks[remarkID] = nil
				
				break
			end
		end
		
		local remarkWeight = math.distance(pickedRemarkData.startWeight, pickedRemarkData.finishWeight) + 1
		
		for remarkID, remarkData in pairs(validRemarks) do
			if rolledWeight < remarkData.startWeight then
				remarkData.startWeight = remarkData.startWeight - remarkWeight
				remarkData.finishWeight = remarkData.finishWeight - remarkWeight
			end
		end
		
		currentWeight = currentWeight - remarkWeight
		
		projectReview.remarksByID[pickedRemarkID]:onPicked(self, pickedRemarkData)
		table.insert(self.remarks, {
			remarkID = pickedRemarkID,
			remarkData = pickedRemarkData
		})
	end
end

function projectReview:getProject()
	return self.project
end

function projectReview:setRating(rating)
	if rating >= 10 and self.cons and #self.cons > 0 then
		rating = rating - 1
	end
	
	self.rating = rating
end

function projectReview:getRating()
	return self.rating
end

function projectReview:addPro(pro)
	table.insert(self.pros, pro)
end

function projectReview:addCon(con)
	table.insert(self.cons, con)
end

function projectReview:getPros()
	return self.pros
end

function projectReview:getCons()
	return self.cons
end

function projectReview:getExistingIndex(from, index)
	if #from == 0 then
		return nil
	end
	
	index = index or math.random(1, #from)
	
	return from[index]
end

function projectReview:revealAndShow(data, featureType)
	local isNew = studio:revealGameQualityMatching(data.type, data.id, self.project)
	
	self:markNewReveal(isNew)
	
	if isNew then
		self:logReveal(data.type, data.id)
	end
	
	return gameQuality:getReviewText(data.id, featureType)
end

projectReview.REMARK_SEPARATOR = "\n[...] "

function projectReview:createReviewPopup()
	review:validateRealReviewStandard(self.project)
	review:getProjectQualityScoreAffector(self.project)
	
	local popup = gui.create("ReviewPopup")
	
	popup:setWidth(600)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("REVIEW_TITLE", "Review"))
	
	local flooredRating = math.floor(self.rating)
	local texts = projectReview.BASE_QUALITY_TEXT[flooredRating]
	local baseRatingText = string.easyformatbykeys(texts[math.random(1, #texts)], "GAME", self.project:getName())
	local separator = projectReview.REMARK_SEPARATOR
	local goodOrBadText = ""
	
	if self.pro or self.con or self.avg then
		if self.showCon then
			goodOrBadText = self:revealAndShow(self.con, projectReview.FEATURES_TYPE.WORST)
		elseif self.pro then
			goodOrBadText = self:revealAndShow(self.pro, projectReview.FEATURES_TYPE.BEST)
		elseif self.con then
			goodOrBadText = self:revealAndShow(self.con, projectReview.FEATURES_TYPE.WORST)
		elseif self.avg then
			goodOrBadText = self:revealAndShow(self.avg, projectReview.FEATURES_TYPE.AVG)
		end
		
		goodOrBadText = separator .. goodOrBadText[math.random(1, #goodOrBadText)]
	end
	
	local remarkText = ""
	
	for key, remarkData in ipairs(self.remarks) do
		remarkText = remarkText .. separator .. projectReview.remarksByID[remarkData.remarkID]:pickText(self, remarkData.remarkData)
	end
	
	local inClosingText = ""
	
	if flooredRating < projectReview.GOOD_GAME_RATING_CUTOFF then
		if flooredRating >= projectReview.ABOVE_AVERAGE_RATING_CUTOFF then
			inClosingText = projectReview.ABOVE_AVERAGE_TEXT[math.random(1, #projectReview.ABOVE_AVERAGE_TEXT)]
		elseif flooredRating >= projectReview.AVERAGE_GAME_RATING_CUTOFF then
			inClosingText = projectReview.AVERAGE_STUFF_TEXT[math.random(1, #projectReview.AVERAGE_STUFF_TEXT)]
		else
			inClosingText = projectReview.BAD_STUFF_TEXT[math.random(1, #projectReview.BAD_STUFF_TEXT)]
		end
	elseif flooredRating >= projectReview.PERFECT_GAME_RATING_CUTOFF then
		inClosingText = projectReview.NO_ISSUES_TEXT[math.random(1, #projectReview.NO_ISSUES_TEXT)]
	else
		inClosingText = projectReview.GOOD_STUFF_TEXT[math.random(1, #projectReview.GOOD_STUFF_TEXT)]
	end
	
	local finalInClosingText
	
	if inClosingText ~= "" then
		finalInClosingText = string.easyformatbykeys(inClosingText, "STUDIO", self.project:getOwner():getName())
	end
	
	inClosingText = finalInClosingText ~= "" and separator .. finalInClosingText or inClosingText
	
	local text = string.easyformatbykeys(projectReview.REVIEW_TEXT_TEMPLATE, "OVERALL_", baseRatingText, "GOOD OR BAD_", goodOrBadText, "REMARK_", remarkText, "IN CLOSING_", inClosingText)
	
	table.clear(placeRemarks)
	popup:setText(text)
	popup:setReview(self)
	popup:addButton(fonts.get("pix20"), "OK", nil)
	popup:center()
	self.project:createQualityPointDisplay(popup)
	frameController:push(popup)
	events:fire(projectReview.EVENTS.OPENED, popup)
end

function projectReview:attemptAddToQualityTable(from, into)
	if #from == 0 then
		return 
	end
	
	table.insert(into, from[math.random(1, #from)])
end

function projectReview:logReveal(revealType, info, featureReveal)
	if featureReveal then
		self.featureReveals = self.featureReveals or {}
		
		if info then
			self.featureReveals[revealType] = {}
			
			table.insert(self.featureReveals[revealType], info)
		else
			self.featureReveals[revealType] = true
		end
		
		return 
	end
	
	self.matchReveals = self.matchReveals or {}
	
	if info then
		self.matchReveals[revealType] = {}
		
		table.insert(self.matchReveals[revealType], info)
	else
		self.matchReveals[revealType] = true
	end
end

function projectReview:markNewReveal(isNew)
	if isNew then
		self.revealedNewInfo = true
	end
end

function projectReview:hasRevealedNothingNew()
	return not self.revealedNewInfo
end

function projectReview:getMatchReveals()
	return self.matchReveals
end

function projectReview:getFeatureReveals()
	return self.featureReveals
end

function projectReview:getConclusionData()
	return self.conclusionData
end

function projectReview:addConclusion(conclusionID, data)
	if not self.conclusions then
		self.conclusions = {}
		self.conclusionData = {}
	end
	
	if table.find(self.conclusions, conclusionID) then
		return 
	end
	
	table.insert(self.conclusions, conclusionID)
	
	self.conclusionData[conclusionID] = data
end

function projectReview:getConclusions()
	return self.conclusions
end

function projectReview:generateProsAndCons(gameObj)
	self.project = gameObj
	
	local qualityScore = review:getThoroughReviewInfo(gameObj, 1)
	local scoreImpact = genres:getScoreImpact(gameObj)
	
	self.displayAspectRatings = {}
	
	local displayOffset = review.aspectRatingVisualDisplayOffset
	local genreID = gameObj.genre
	local genreMap = genres.registeredByID
	
	for qualityID, score in pairs(qualityScore) do
		local realScore = score / genreMap[genreID].scoreImpact[qualityID]
		local negativeOffset = math.lerp(displayOffset[1], 0, realScore)
		
		self.displayAspectRatings[qualityID] = math.max(0, math.round(math.min(projectReview.MAX_DISPLAYED_QUALITY_LEVEL, realScore * 100 + math.random(negativeOffset, displayOffset[2]))))
		
		if realScore <= projectReview.CON_QUALITY_CUTOFF then
			if scoreImpact[qualityID] > 1 then
				table.insert(self.cons, {
					type = studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY,
					id = qualityID
				})
			end
		elseif realScore <= projectReview.AVG_QUALITY_CUTOFF then
			table.insert(self.avgs, {
				type = studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY,
				id = qualityID
			})
		elseif scoreImpact[qualityID] > 1 then
			table.insert(self.pros, {
				type = studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY,
				id = qualityID
			})
		end
	end
	
	self:pickOneGameTrait()
end

function projectReview:getAspectRatings()
	return self.displayAspectRatings
end

function projectReview:pickOneGameTrait()
	self.pro = self:getExistingIndex(self.pros)
	self.con = self:getExistingIndex(self.cons)
	self.avg = self:getExistingIndex(self.avgs)
	
	if self.con and self.pro and not studio:isGameQualityMatchRevealed(self.con.type, self.con.id, nil, self.project) then
		self.showCon = math.random(1, 100) <= projectReview.CON_DISPLAY_PRIORITY
	end
	
	table.clear(self.pros)
	table.clear(self.cons)
	table.clear(self.avgs)
end

function projectReview:save()
	return {
		rating = self.rating,
		pro = self.pro,
		con = self.con,
		avg = self.avg,
		showCon = self.showCon,
		reviewer = self.reviewer:getID(),
		remarks = self.remarks,
		matchReveals = self.matchReveals,
		revealedNewInfo = self.revealedNewInfo,
		displayAspectRatings = self.displayAspectRatings,
		featureReveals = self.featureReveals,
		conclusions = self.conclusions,
		conclusionData = self.conclusionData
	}
end

function projectReview:load(data, project)
	self.data = data
	self.rating = data.rating or data.score
	self.reviewer = review:getReviewer(data.reviewer)
	self.project = project
	self.pro = data.pro
	self.con = data.con
	self.avg = data.avg
	self.showCon = data.showCon
	self.remarks = data.remarks
	self.matchReveals = data.matchReveals
	self.revealedNewInfo = data.revealedNewInfo
	self.displayAspectRatings = data.displayAspectRatings
	self.featureReveals = data.featureReveals
	self.conclusions = data.conclusions
	self.conclusionData = data.conclusionData
	
	if not self.conclusionData and self.conclusions then
		self.conclusionData = {}
	end
end

require("game/review/project_review_remarks")
