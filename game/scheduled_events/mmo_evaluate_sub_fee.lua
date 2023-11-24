local mmoFeeEval = {}

mmoFeeEval.id = "mmo_evaluate_sub_fee"
mmoFeeEval.inactive = true

function mmoFeeEval:validateEvent()
	return true
end

function mmoFeeEval:activate()
	mmoFeeEval.baseClass.activate(self)
	
	local logic = self.gameProj:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
	
	if not logic then
		return 
	end
	
	logic:evaluateSubscriptionFeeChange()
end

function mmoFeeEval:canActivateLoad()
	return false
end

function mmoFeeEval:canActivate()
	return timeline.curTime >= self.activationDate
end

function mmoFeeEval:setGame(gameObj)
	self.gameProj = gameObj
end

function mmoFeeEval:setActivationDate(date)
	self.activationDate = date
end

function mmoFeeEval:save()
	local saved = mmoFeeEval.baseClass.save(self)
	
	saved.gameID = self.gameProj:getUniqueID()
	saved.activationDate = self.activationDate
	
	return saved
end

function mmoFeeEval:load(data)
	self.gameProj = studio:getProjectByUniqueID(data.gameID)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(mmoFeeEval)
