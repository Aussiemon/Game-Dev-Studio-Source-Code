local frame = {}

function frame:postKill()
	dialogueHandler:show()
end

gui.register("FanOfferFrame", frame, "Frame")
