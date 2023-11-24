local published = {}

published.CATCHABLE_EVENTS = {
	workshop.EVENTS.PREVIEW_RECEIVED,
	workshop.EVENTS.MOD_DISABLED,
	workshop.EVENTS.MOD_ENABLED
}

function published.updateModCallback(button)
	workshop:createNewModMenu(true, button.modData)
end

function published:fillInteractionComboBox(combobox)
	published.baseClass.fillInteractionComboBox(self, combobox)
	
	local option = combobox:addOption(0, 0, 0, 24, _T("WORKSHOP_UPDATE_MOD", "Update mod..."), fonts.get("pix20"), published.updateModCallback)
	
	option.modData = self.data
end

function published:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, x - _S(5), y - _S(5))
	end
end

gui.register("WorkshopPublishedModDisplay", published, "WorkshopModDisplay")
