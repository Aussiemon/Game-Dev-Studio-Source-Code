local quitGame = {}

quitGame.text = _T("OPTIONS", "Options")

function quitGame:init()
	self:setFont(fonts.get("pix24"))
end

function quitGame:onClick(x, y, key)
	mainMenu:createOptionsMenu()
end

gui.register("OptionsMenuButton", quitGame, "Button")
