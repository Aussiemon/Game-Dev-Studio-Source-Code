local genKnowPopBoost = {}

genKnowPopBoost.id = "generic_knowledge_popularity_boost"
genKnowPopBoost.inactive = true

function genKnowPopBoost:validateEvent()
	return true
end

function genKnowPopBoost:activate()
	genKnowPopBoost.baseClass.activate(self)
	
	if self.project:isOffMarket() then
		return 
	end
	
	self.subEvent:perform(self.project)
end

function genKnowPopBoost:canActivateLoad()
	return false
end

function genKnowPopBoost:canActivate()
	return timeline.curTime >= self.activationDate
end

function genKnowPopBoost:setProject(proj)
	self.project = proj
end

function genKnowPopBoost:setSubEvent(subEvent)
	self.subEvent = subEvent
end

function genKnowPopBoost:setActivationDate(date)
	self.activationDate = date
end

function genKnowPopBoost:save()
	local saved = genKnowPopBoost.baseClass.save(self)
	
	saved.projID = self.project:getUniqueID()
	
	local own = self.project:getOwner()
	
	if not own:isPlayer() then
		saved.rivalID = own:getID()
	end
	
	saved.subEventID = self.subEvent.id
	saved.activationDate = self.activationDate
	
	return saved
end

function genKnowPopBoost:load(data)
	if data.rivalID then
		local company = rivalGameCompanies:getCompanyByID(data.rivalID)
		
		if company then
			local proj = company:getProjectByUniqueID(data.projID)
			
			if proj then
				self.project = proj
			end
		end
	else
		self.project = studio:getGameByUniqueID(data.projID)
		
		for key, company in ipairs(rivalGameCompanies:getCompanies()) do
			local proj = company:getProjectByUniqueID(data.projID)
			
			if proj then
				self.project = proj
				
				break
			end
		end
	end
	
	self:setSubEvent(gameProject.subEvents:get(data.subEventID))
	
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(genKnowPopBoost)
