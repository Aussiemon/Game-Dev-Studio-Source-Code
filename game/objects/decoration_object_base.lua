local decorBase = {}

decorBase.class = "decoration_object_base"
decorBase.spriteList = {}
decorBase.objectAtlas = "decorations"
decorBase.display = "decoration"
decorBase.OFFICE_OBJECT = false
decorBase.BASE = true

function decorBase:init()
	decorBase.baseClass.init(self)
	
	self.reachable = true
end

function decorBase:onRemoved()
	game.worldObject:removeDecorationObject(self)
end

function decorBase:canSell()
	return false
end

function decorBase:onPurchased()
end

function decorBase:handleClick()
	return false
end

function decorBase:canInteractWithExpansion()
	return false
end

function decorBase:shouldIgnoreRoomChecking(checkedBy)
	return true
end

function decorBase:attemptRegister()
end

function decorBase:isValidRoom()
	return true
end

local genericObjectBase = objects.getClassData("generic_object")

function decorBase:enterVisibilityRange()
	genericObjectBase.enterVisibilityRange(self)
	self:pickSpritebatch()
end

function decorBase:leaveVisibilityRange()
	genericObjectBase.leaveVisibilityRange(self)
end

function decorBase:save()
	local saved = decorBase.baseClass.save(self)
	
	saved.ourSprite = self.ourSprite
	
	return saved
end

function decorBase:load(data)
	decorBase.baseClass.load(self, data)
end

function decorBase:draw()
end

objects.registerNew(decorBase, "static_object_base")
