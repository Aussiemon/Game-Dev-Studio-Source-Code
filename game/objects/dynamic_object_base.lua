local dynamicObjectBase = {}

dynamicObjectBase.tileWidth = 0
dynamicObjectBase.tileHeight = 0
dynamicObjectBase.class = "dynamic_object_base"
dynamicObjectBase.BASE = true

function dynamicObjectBase:init()
end

function dynamicObjectBase:kill()
	dynamicObjectBase.baseClass.kill(self)
	game.removeDynamicObject(self)
end

objects.registerNew(dynamicObjectBase)
