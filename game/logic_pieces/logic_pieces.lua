logicPieces = {}
logicPieces.registered = {}
logicPieces.registeredByID = {}
logicPieces.active = {}

function logicPieces:registerNew(data, inherit)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
	
	if inherit then
		local inherited = self.registeredByID[inherit]
		
		setmetatable(data, inherited.mtindex)
		
		data.baseClass = inherited
	end
	
	data.mtindex = {
		__index = data
	}
end

function logicPieces:getData(id)
	return logicPieces.registeredByID[id]
end

function logicPieces.create(id)
	local new = {}
	
	setmetatable(new, logicPieces.registeredByID[id].mtindex)
	new:init()
	
	return new
end

function logicPieces:addActive(piece)
	table.insert(self.active, piece)
end

function logicPieces:removeActive(piece)
	table.removeObject(self.active, piece)
end

function logicPieces:remove()
	while #self.active > 0 do
		self.active[#self.active]:remove()
	end
end

function logicPieces:save()
	return {}
end

function logicPieces:load(data)
end

function logicPieces:loadLogicPiece(data, ...)
	local logicData = logicPieces.registeredByID[data.id]
	
	if logicData:canLoad(data, ...) then
		local piece = logicPieces.create(data.id)
		
		piece:load(data)
		
		return piece
	end
	
	return nil
end

require("game/logic_pieces/logic_piece")
require("game/logic_pieces/event_handling_logic_piece")
require("game/logic_pieces/mmo_subscriptions_logic_piece")
require("game/logic_pieces/microtransactions_logic_piece")
