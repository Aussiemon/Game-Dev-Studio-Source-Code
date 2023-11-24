local inviteConfirm = {}

function inviteConfirm:init()
	self:setFont(fonts.get("pix20"))
	self:setText(_T("CONFIRM", "Confirm"))
	
	self.inviteTargets = {}
end

function inviteConfirm:setBribeSize(size)
	self.bribeSize = size
end

function inviteConfirm:setTarget(target, state)
	if state then
		self.inviteTargets[#self.inviteTargets + 1] = target
	else
		table.removeObject(self.inviteTargets, target)
	end
end

function inviteConfirm:isInvited(target)
	return table.find(self.inviteTargets, target)
end

function inviteConfirm:setProject(proj)
	self.project = proj
end

function inviteConfirm:getBribeSize()
	return self.bribeSize
end

function inviteConfirm:isDisabled()
	if not self.project or #self.inviteTargets == 0 then
		return true
	end
	
	return false
end

function inviteConfirm:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	for key, targetObj in ipairs(self.inviteTargets) do
		targetObj:offerInterview(self.project)
	end
	
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	
	if #self.inviteTargets == 1 then
		popup:setTitle(_T("INVITATION_SENT_TITLE", "Invitation Sent"))
		popup:setText(_T("INVITATION_SENT_DESC", "Sent invitation to review community, their answer will be available in a few days."))
	else
		popup:setTitle(_T("INVITATIONS_SENT_TITLE", "Invitations Sent"))
		popup:setText(_format(_T("INVITATIONS_SENT_DESC", "Sent invitations to COMMUNITIES communities, their answer will be available in a few days."), "COMMUNITIES", #self.inviteTargets))
	end
	
	popup:setOnKillCallback(game.genericClearFrameControllerCallback)
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"), nil)
	popup:center()
	frameController:push(popup)
end

gui.register("ConfirmInviteButton", inviteConfirm, "Button")
