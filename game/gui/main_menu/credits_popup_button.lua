local credsButton = {}

function credsButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		game.createCreditsPopup()
	end
end

gui.register("CreditsPopupButton", credsButton, "Button")
