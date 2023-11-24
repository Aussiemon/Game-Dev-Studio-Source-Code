local prefabLoad = {}

function prefabLoad:init()
	self:setFont("pix24")
end

function prefabLoad:setPrefabID(id)
	self.prefabID = id
	
	self:setText(id)
end

function prefabLoad:onClick()
	frameController:pop()
	officePrefabEditor:loadPrefab(self.prefabID)
end

gui.register("LoadPrefabButton", prefabLoad, "Button")
