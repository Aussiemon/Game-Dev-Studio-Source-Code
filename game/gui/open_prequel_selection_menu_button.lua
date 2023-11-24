local prequelMenuButton = {}

function prequelMenuButton:init()
end

function prequelMenuButton:setProject(proj)
	self.project = proj
end

function prequelMenuButton:onClick(x, y, key)
	self.project:createPrequelSelectionMenu()
end

gui.register("OpenPrequelSelectionMenuButton", prequelMenuButton, "Button")
