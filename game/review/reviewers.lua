reviewers = {}
reviewers.registered = {}
reviewers.registeredByID = {}
reviewers.DEFAULT_INTERVIEW_MAX_CHANCE = 100

local baseReviewersFuncs = {}

baseReviewersFuncs.mtindex = {
	__index = baseReviewersFuncs
}

function baseReviewersFuncs:offerBribe(reviewer, amount, gameProj)
	local chance = math.randomf(1, 100)
	local acceptChance = self:getBribeAcceptChance(reviewer, amount)
	
	if acceptChance < chance then
		if math.random(1, 100) >= self:getBribeRevealChance() then
			reviewer:refuseBribe(amount, gameProj)
		else
			reviewer:revealBribe(amount, gameProj)
		end
		
		return false
	end
	
	reviewer:acceptBribe(amount, gameProj)
	
	return true
end

function baseReviewersFuncs:getExtraBribeAcceptChance(bribeSize)
	local bribeData = advertisement:getData("bribe")
	local distance = bribeData.maximumBribe - bribeData.minimumBribe
	
	return (bribeSize - bribeData.minimumBribe) / distance * self.bribeAcceptChanceIncreaseFromMoney
end

function baseReviewersFuncs:getBribeAcceptChance(reviewerObj, amount)
	return reviewerObj:getBribeAcceptChance() + self:getExtraBribeAcceptChance(amount)
end

function baseReviewersFuncs:getInquireText()
	return self.inquireText
end

function baseReviewersFuncs:getBribeRevealChance()
	local chance = self.bribeRevealChance
	
	return chance
end

function baseReviewersFuncs:getName()
	return self.display
end

function baseReviewersFuncs:getDescription()
	return self.description
end

function baseReviewersFuncs:getScoreBoostPerCashAmount()
	return self.pointPerCashAmount
end

function reviewers:registerNew(data)
	table.insert(reviewers.registered, data)
	
	reviewers.registeredByID[data.id] = data
	
	for key, descData in ipairs(data.description) do
		descData.font = descData.font or "pix20"
		descData.color = descData.color or advertisement.WHITE
		descData.lineSpace = descData.lineSpace or 0
	end
	
	data.maxInterviewChance = data.maxInterviewChance or reviewers.DEFAULT_INTERVIEW_MAX_CHANCE
	
	setmetatable(data, baseReviewersFuncs.mtindex)
end

function reviewers:getData(id)
	return reviewers.registeredByID[id]
end

local bribeData = advertisement:getData("bribe")
local legitReviews = {}

legitReviews.id = "legit_reviews"
legitReviews.icon = "reviewer_legit_reviews"
legitReviews.display = _T("LEGIT_REVIEWS", "Legit Reviews")
legitReviews.description = {
	{
		font = "bh22",
		text = _T("LEGIT_REVIEWS_DESC1", "We review games. No bull, real talk.")
	},
	{
		font = "pix18",
		text = _T("LEGIT_REVIEWS_DESC2", "This community has been around for a long time. It has a formidable reputation of being transparent in their reviews and sponsorships, as well as providing unbiased information on games.\nUnfortunately, the fanbase, while loyal, is not very large.")
	}
}
legitReviews.maxInterviewChance = 90
legitReviews.bribeAcceptChance = 5
legitReviews.bribeAcceptChanceIncreaseFromMoney = 5
legitReviews.bribeRevealChance = 15
legitReviews.bribeRevealChanceMonthly = legitReviews.bribeRevealChance / 15
legitReviews.pointPerCashAmount = bribeData.maximumBribe / 4
legitReviews.interviewBaseAcceptChance = 50
legitReviews.interviewReputationCutoff = 5000
legitReviews.interviewAcceptChancePerReputation = 0.01
legitReviews.popularity = 0.3
legitReviews.autoInterviewChanceMultiplier = 0.5
legitReviews.recentReviewTimeCutoff = 60
legitReviews.recentInterviewTimeAffector = 0.2
legitReviews.inquireText = _T("LEGIT_REVIEWS_INQUIRE", "Like their name suggests, they make unbiased reviews. I have heard some stories of them taking a bribe or two, but offering them any kind of bribe is a bad idea. Best case scenario - they'll refuse your bribe offer; worst case scenario - they'll make it known to everyone and your reputation will suffer real hard. I doubt you'll be able to sway their opinion that much by offering a fat wad of cash either.")

reviewers:registerNew(legitReviews)

local reviewerTwo = {}

reviewerTwo.id = "reviewer_2"
reviewerTwo.icon = "reviewer_gamesbomb"
reviewerTwo.display = _T("REVIEWER_2_NAME", "GamesBomb")
reviewerTwo.description = {
	{
		font = "bh22",
		text = _T("REVIEWER_2_DESCRIPTION_1", "Great games and reviews at GamesBomb!")
	},
	{
		font = "pix18",
		text = _T("REVIEWER_2_DESCRIPTION_2", "This community is known for it's partnerships with multiple game studios.\nThe traffic this community gets can be envied by others, but they are known give interviews for the most part only to big players in the game industry, rarely making an exception for small-time devs or newcomers.")
	}
}
reviewerTwo.maxInterviewChance = 60
reviewerTwo.bribeAcceptChance = 80
reviewerTwo.bribeRevealChance = 5
reviewerTwo.bribeRevealChanceMonthly = reviewerTwo.bribeRevealChance / 15
reviewerTwo.bribeAcceptChanceIncreaseFromMoney = 20
reviewerTwo.pointPerCashAmount = bribeData.maximumBribe / 4
reviewerTwo.interviewBaseAcceptChance = 10
reviewerTwo.interviewReputationCutoff = 15000
reviewerTwo.interviewAcceptChancePerReputation = 0.006666666666666667
reviewerTwo.popularity = 2
reviewerTwo.autoInterviewChanceMultiplier = 0.5
reviewerTwo.recentReviewTimeCutoff = 60
reviewerTwo.recentInterviewTimeAffector = 0.2
reviewerTwo.inquireText = _T("REVIEWER_2_INQUIRE", "These guys are popular and have a pretty big community. Know what that means? They don't care about small-time developers or newcomers. Another thing it means is they need those 'partnerships', and what better way is there to get 'partnership' money, than to make a mutually beneficial agreement in terms of a game rating?")

reviewers:registerNew(reviewerTwo)

local reviewerThree = {}

reviewerThree.id = "reviewer_3"
reviewerThree.icon = "reviewer_igm"
reviewerThree.display = _T("REVIEWER_3_NAME", "IGM")
reviewerThree.description = {
	{
		font = "bh22",
		text = _T("REVIEWER_3_DESCRIPTION_1", "Your daily dose of game reviews.")
	},
	{
		font = "pix18",
		text = _T("REVIEWER_3_DESCRIPTION_2", "This community is known for it's partnerships with large game companies, with an indie title collaboration popping up every once in a while. They have a large userbase and while it's not as big as the one that GamesBomb has, it's a lot more stable.")
	}
}
reviewerThree.maxInterviewChance = 70
reviewerThree.bribeAcceptChance = 40
reviewerThree.bribeRevealChance = 10
reviewerThree.bribeRevealChanceMonthly = reviewerTwo.bribeRevealChance / 15
reviewerThree.bribeAcceptChanceIncreaseFromMoney = 50
reviewerThree.pointPerCashAmount = bribeData.maximumBribe / 4
reviewerThree.interviewBaseAcceptChance = 30
reviewerThree.interviewReputationCutoff = 10000
reviewerThree.interviewAcceptChancePerReputation = 0.005
reviewerThree.popularity = 1.3
reviewerThree.autoInterviewChanceMultiplier = 0.5
reviewerThree.recentReviewTimeCutoff = 60
reviewerThree.recentInterviewTimeAffector = 0.2
reviewerThree.inquireText = _T("REVIEWER_3_INQUIRE", "'IGM' is only second in terms of popularity to GamesBomb, and while they're pretty honest in their reviews, they still make deals with developers every once in a while. Don't try offering them a small bribe, it most likely is not going to work. But if you offer them a big enough wad of cash, I'm sure they wouldn't say no.")

reviewers:registerNew(reviewerThree)

local reviewerFour = {}

reviewerFour.id = "reviewer_4"
reviewerFour.icon = "reviewer_gaming_nexus"
reviewerFour.display = _T("REVIEWER_4_NAME", "Gaming Nexus")
reviewerFour.description = {
	{
		font = "bh22",
		text = _T("REVIEWER_4_DESCRIPTION_1", "The most recent games & news.")
	},
	{
		font = "pix18",
		text = _T("REVIEWER_4_DESCRIPTION_2", "Only second to 'Legit Reviews' in their transparency about partnerships with game developers, this community has a larger userbase because they take games & their reviews a bit less serious than them.")
	}
}
reviewerFour.maxInterviewChance = 80
reviewerFour.bribeAcceptChance = 10
reviewerFour.bribeRevealChance = 0
reviewerFour.bribeRevealChanceMonthly = 0
reviewerFour.bribeAcceptChanceIncreaseFromMoney = 40
reviewerFour.pointPerCashAmount = bribeData.maximumBribe / 2.5
reviewerFour.interviewBaseAcceptChance = 10
reviewerFour.interviewReputationCutoff = 15000
reviewerFour.interviewAcceptChancePerReputation = 0.006666666666666667
reviewerFour.popularity = 0.7
reviewerFour.autoInterviewChanceMultiplier = 0.5
reviewerFour.recentReviewTimeCutoff = 60
reviewerFour.recentInterviewTimeAffector = 0.2
reviewerFour.inquireText = _T("REVIEWER_4_INQUIRE", "They might not have the largest fanbase, but they're very consistent with their reviews. From what I've heard they're 50/50 in terms of partnerships, provided you hand them a big enough suitcase of money. What I also know is that while they might not always agree to a partnership, they also will never let anyone know about your offers.")

reviewers:registerNew(reviewerFour)
