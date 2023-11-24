local activePriceResearchElement = {}
local designTask = task:getData("design_task")

activePriceResearchElement.CATCHABLE_EVENTS = {
	designTask.EVENTS.REMOVE_DISPLAY,
	project.EVENTS.NAME_SET
}

local activeProjectElement = gui.getClassTable("ActiveProjectElement")

function activePriceResearchElement:init()
	activeProjectElement.init(self)
end

function activePriceResearchElement:handleEvent(event, object)
	if event == designTask.EVENTS.REMOVE_DISPLAY and object == self.task then
		self:kill()
	elseif event == project.EVENTS.NAME_SET and object == self.task:getProject() then
		self:updateText(self:getText())
	end
end

gui.register("ActivePriceResearchElement", activePriceResearchElement, "ActiveTaskElement")
