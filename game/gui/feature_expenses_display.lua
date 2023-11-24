local featureExpenses = {}

featureExpenses.CATCHABLE_EVENTS = {
	complexProject.EVENTS.RecalculatedDesiredFeaturesCost,
	gameProject.EVENTS.EDITION_REMOVED,
	gameProject.EVENTS.EDITION_ADDED,
	gameEditions.EVENTS.PART_ADDED,
	gameEditions.EVENTS.PART_REMOVED
}
featureExpenses.INSTA_UPDATE = {
	[complexProject.EVENTS.RecalculatedDesiredFeaturesCost] = true,
	[gameProject.EVENTS.EDITION_REMOVED] = true,
	[gameProject.EVENTS.EDITION_ADDED] = true
}

function featureExpenses:init()
	self:setFont("pix24")
end

function featureExpenses:handleEvent(event, object)
	if featureExpenses.INSTA_UPDATE[event] then
		if self.project == object then
			self:setCost(self.project:getProjectStartCost())
		end
	elseif self.project:hasEdition(object) then
		self:setCost(self.project:getProjectStartCost())
	end
end

function featureExpenses:setProject(project)
	self.project = project
	
	self:setCost(self.project:getProjectStartCost())
end

function featureExpenses:hasEnoughFunds()
	return self.project:hasEnoughFunds()
end

function featureExpenses:setupDescBox()
	featureExpenses.baseClass.setupDescBox(self)
	
	if self.project:getContractor() then
		self.descBox:addSpaceToNextText(10)
		self.descBox:addText(_T("ALL_EXPENSES_COVERED_BY_CONTRACTOR", "All development costs are covered by the contractor."), "pix18", nil, 0, 400, "question_mark", 22, 22)
	end
end

gui.register("FeatureExpensesDisplay", featureExpenses, "CostDisplay")
