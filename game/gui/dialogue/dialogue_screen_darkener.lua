dialogueScreenDark = {}

function dialogueScreenDark:setDialogueBox(box)
	self.dialogueBox = box
end

function dialogueScreenDark:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and self.dialogueBox and self.dialogueBox:getFlyInDistance() <= 0 then
		self.dialogueBox:advanceSpool(true)
	end
end

gui.register("DialogueScreenDarkener", dialogueScreenDark, "ScreenDarkener")
