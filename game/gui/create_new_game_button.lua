local createNewGameButton = {}

function createNewGameButton:init()
	self.font = fonts.get("pix24")
	
	self:setText(_T("CREATE_NEW_GAME"), "Create new game")
end

function createNewGameButton:setMainPanel(obj)
	self.mainPanel = obj
end

function createNewGameButton:onClick()
	self.mainPanel:createNewGameMenu()
end

gui.create("CreateNewGameButton", createNewGameButton, "Button")
