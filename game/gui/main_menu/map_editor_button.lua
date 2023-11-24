local mapEdit = {}

mapEdit.text = _T("MAP_EDITOR", "Map editor")
mapEdit.hoverText = {
	{
		font = "bh20",
		wrapWidth = 400,
		text = _T("MAP_EDITOR_BUTTON_TEXT", "Create maps for use in new scenarios. Setup of scenarios is done separately and requires scripting knowledge.")
	}
}

function mapEdit:init()
	self:setFont(fonts.get("pix24"))
end

function mapEdit:onClick(x, y, key)
	mapEditor:createStartFrame()
end

gui.register("MapEditorButton", mapEdit, "Button")
