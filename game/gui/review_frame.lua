local reviewPopup = {}

reviewPopup.extraInfoClass = "ReviewDescription"

function reviewPopup:setReview(review)
	self.leftDescbox:overwriteDepth(100)
	self.rightDescbox:overwriteDepth(100)
	self.extraInfo:overwriteDepth(100)
	
	self.review = review
	
	self.extraInfo:setReview(review)
	
	local wrapWidth = self.w - _S(10)
	local gameProj = self.review:getProject()
	local aspectRatings = self.review:getAspectRatings()
	local cur = 0
	
	for qualityID, level in pairs(aspectRatings) do
		cur = cur + 1
		
		local targetList
		
		if cur % 2 == 0 then
			targetList = self.leftDescbox
		else
			targetList = self.rightDescbox
		end
		
		targetList:addText(_format(_T("ASPECT_RATING_DISPLAY", "ASPECT - POINTS%"), "ASPECT", gameQuality.registeredByID[qualityID].display, "POINTS", level), "bh20", nil, 0, wrapWidth, {
			{
				height = 26,
				icon = "profession_backdrop",
				width = 26
			},
			{
				width = 20,
				height = 20,
				y = 1,
				x = 3,
				icon = gameQuality.registeredByID[qualityID].icon
			}
		})
	end
end

function reviewPopup:postKill()
	events:fire(projectReview.EVENTS.CLOSED, self)
end

gui.register("ReviewPopup", reviewPopup, "DescboxPopup")
