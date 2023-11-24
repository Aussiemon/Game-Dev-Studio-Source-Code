local closeCandidateFrameButton = {}

function closeCandidateFrameButton:onMouseEntered()
	closeCandidateFrameButton.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("CLOSE_CANDIDATE_WINDOW_DESCRIPTION", "Closing this window will dismiss the remaining job candidates."), "pix18", nil, 0, 300, "question_mark", 22, 22)
	self.descBox:centerToElement(self)
end

function closeCandidateFrameButton:onMouseLeft()
	closeCandidateFrameButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("CloseCandidateFrameButton", closeCandidateFrameButton, "FrameCloseButton")
