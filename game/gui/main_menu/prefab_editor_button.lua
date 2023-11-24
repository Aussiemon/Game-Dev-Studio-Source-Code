local prefabEdit = {}

prefabEdit.text = _T("PREFAB_EDITOR", "Prefab editor")
prefabEdit.hoverText = {
	{
		font = "bh20",
		wrapWidth = 400,
		text = _T("PREFAB_EDITOR_BUTTON_TEXT", "Create office and decorational buildings for integration into maps.")
	}
}

function prefabEdit:init()
	self:setFont(fonts.get("pix24"))
end

function prefabEdit:onClick(x, y, key)
	officePrefabEditor:enter()
end

gui.register("PrefabEditorButton", prefabEdit, "Button")
