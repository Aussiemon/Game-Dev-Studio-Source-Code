local createMap = {}

createMap.text = _T("NEW_MAP", "New map")

function createMap:init()
	self:setFont(fonts.get("pix24"))
end

function createMap:onClick(x, y, key)
	frameController:pop()
	mapEditor:createMapSizeSelectionFrame()
end

gui.register("CreateNewMapButton", createMap, "Button")
