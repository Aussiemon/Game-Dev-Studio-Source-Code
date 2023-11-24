local wordOfMouth = {}

wordOfMouth.id = "word_of_mouth"
wordOfMouth.inactive = true

function wordOfMouth:validateEvent()
	return true
end

function wordOfMouth:activate()
	wordOfMouth.baseClass.activate(self)
	
	if self.project:isOffMarket() then
		return 
	end
	
	gameProject.subEvents:get("word_of_mouth"):perform(self.project)
end

function wordOfMouth:canActivateLoad()
	return false
end

function wordOfMouth:canActivate()
	return timeline.curTime >= self.activationDate
end

function wordOfMouth:setProject(proj)
	self.project = proj
end

function wordOfMouth:setActivationDate(date)
	self.activationDate = date
end

function wordOfMouth:save()
	local saved = wordOfMouth.baseClass.save(self)
	
	saved.projID = self.project:getUniqueID()
	
	local own = self.project:getOwner()
	
	if not own:isPlayer() then
		saved.rivalID = own:getID()
	end
	
	saved.activationDate = self.activationDate
	
	return saved
end

function wordOfMouth:load(data)
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
	
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(wordOfMouth)
