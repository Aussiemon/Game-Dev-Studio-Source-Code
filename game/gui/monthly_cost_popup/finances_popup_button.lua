local financesButton = {}

function financesButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		game.createFinancesPopup()
	end
end

gui.register("FinancesPopupButton", financesButton, "Button")
