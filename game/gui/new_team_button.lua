local newTeam = {}

function newTeam:init()
	self:setFont(fonts.get("pix24"))
	self:setText(_T("CREATE_NEW_TEAM", "Create new team"))
	self:setPanelHoverColor(249, 255, 145, 255)
end

function newTeam:onClick()
	game.openTeamCreationMenu()
end

gui.register("NewTeamButton", newTeam, "Button")
