local tutorDark = {}

function tutorDark:draw(w, h)
	if dialogueHandler:isActive() then
		return 
	end
	
	tutorDark.baseClass.draw(self, w, h)
end

gui.register("TutorialScreenDarkener", tutorDark, "ScreenDarkener")
