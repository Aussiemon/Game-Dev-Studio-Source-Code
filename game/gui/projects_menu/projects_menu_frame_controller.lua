local projectsMenuFrameController = {}

projectsMenuFrameController.buttonSpacing = 5

function projectsMenuFrameController:init()
	self.buttons = {}
end

function projectsMenuFrameController:addButton(button)
	local lastButton = self.buttons[#self.buttons]
	local y = 0
	
	button:setParent(self)
	
	if lastButton then
		y = lastButton.localY + lastButton.h + _S(self.buttonSpacing)
	end
	
	button:setFrameController(self)
	button:setPos(self.x, y)
	table.insert(self.buttons, button)
	self:setSize(button.rawW, _US(button.localY) + button.rawH)
end

function projectsMenuFrameController:setFrame(tabButton)
	for key, button in ipairs(self.buttons) do
		if button ~= tabButton then
			button:hideFrame()
		end
	end
	
	tabButton:showFrame()
	
	self.previousTab = tabButton
end

function projectsMenuFrameController:switchFrame(tabButton)
	if self.previousTab then
		self.previousTab:hideFrame()
	end
	
	tabButton:showFrame()
	
	self.previousTab = tabButton
end

gui.register("ProjectsMenuFrameController", projectsMenuFrameController)
