local designerPanel = {}

function designerPanel:init()
	self.designers = {}
end

function designerPanel:setAvailableCategory(av)
	self.availableCategory = av
end

function designerPanel:setUnavailableCategory(av)
	self.unavailableCategory = av
end

function designerPanel:handleEvent(event, designer)
	if event == developer.EVENTS.TASK_CHANGED then
		if designer:getTask() then
			local element = self.designers[designer]
			
			self.unavailableCategory:addItem(element, true)
		else
			local element = self.designers[designer]
			
			self.availableCategory:addItem(element, true)
		end
	elseif event == developer.EVENTS.TASK_CANCELED then
		local element = self.designers[designer]
		
		self.availableCategory:addItem(element, true)
	end
end

function designerPanel:addDesigner(element, designer)
	self.designers[designer] = element
end

gui.register("DesignerScrollbarPanel", designerPanel, "ScrollbarPanel")
