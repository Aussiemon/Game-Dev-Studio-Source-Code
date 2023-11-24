local logicPiece = {}

logicPiece.id = "base_logic"

function logicPiece:init()
	self:start()
end

function logicPiece:getID()
	return self.id
end

function logicPiece:start()
	logicPieces:addActive(self)
end

function logicPiece:handleEvent(event)
end

function logicPiece:fillInteractionComboBox(comboBox)
end

function logicPiece:remove()
	logicPieces:removeActive(self)
	self:onRemoved()
end

function logicPiece:onRemoved()
end

function logicPiece:save()
	return {
		id = self.id
	}
end

function logicPiece:canSave()
	return true
end

function logicPiece:load(data)
end

function logicPiece:postLoad()
end

function logicPiece:canLoad(data)
end

logicPieces:registerNew(logicPiece)
