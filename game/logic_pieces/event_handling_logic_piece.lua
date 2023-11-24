local logicPiece = {}

logicPiece.id = "event_handling_logic_piece"
logicPiece.CATCHABLE_EVENTS = {}

function logicPiece:start()
	logicPiece.baseClass.start(self)
	events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function logicPiece:onRemoved()
	events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
end

logicPieces:registerNew(logicPiece, "base_logic")
