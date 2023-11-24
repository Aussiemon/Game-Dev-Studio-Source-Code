local uploadProg = {}

uploadProg.CATCHABLE_EVENTS = {
	workshop.EVENTS.ITEM_CREATED,
	workshop.EVENTS.ITEM_CREATION_FAILED,
	workshop.EVENTS.ITEM_UPLOADED,
	workshop.EVENTS.ITEM_UPLOAD_FAILED,
	workshop.EVENTS.ITEM_UPLOAD_STARTED,
	workshop.EVENTS.ITEM_CREATION_STARTED,
	workshop.EVENTS.ITEM_UPDATE_STARTED
}

function uploadProg:init()
	self.textCycle = {}
end

function uploadProg:handleEvent(event)
	if event == workshop.EVENTS.ITEM_CREATION_FAILED then
		self:setText(_T("WORKSHOP_MOD_CREATION_FAILED", "Mod creation failed!"), false)
	elseif event == workshop.EVENTS.ITEM_UPLOAD_FAILED then
		self:setText(_T("WORKSHOP_MOD_UPLOAD_FAILED", "Mod upload failed!"), false)
	elseif event == workshop.EVENTS.ITEM_CREATED or event == workshop.EVENTS.ITEM_UPLOAD_STARTED then
		self:clearUploadData()
		
		local uploaded, total, status = steam.GetUploadData()
		
		self:updateUploadStatusText(status)
		self:setText(_T("WORKSHOP_MOD_UPLOADING_FILES", "Uploading files"), true)
	elseif event == workshop.EVENTS.ITEM_CREATION_STARTED then
		self:setText(_T("WORKSHOP_MOD_CREATING_MOD", "Creating mod"), true)
		self:clearUploadData()
	elseif event == workshop.EVENTS.ITEM_UPDATE_STARTED then
		self:setText(_T("WORKSHOP_MOD_UPDATING_MOD", "Updating mod"), true)
		self:clearUploadData()
	else
		self:setText(_T("WORKSHOP_MOD_UPLOADED", "Mod uploaded!"), false)
		self:clearUploadData()
	end
end

function uploadProg:setText(text, cycle)
	self.text = text
	self.cycleDots = cycle
	
	if cycle then
		for i = 1, 3 do
			self.textCycle[i] = text .. string.rep(".", i)
		end
		
		self.cycle = 1
		
		self:setDisplayText(self.textCycle[self.cycle])
		
		self.cycleTime = 0
	else
		self:setDisplayText(text)
	end
end

function uploadProg:setDisplayText(text)
	self.displayText = text
	self.textWidth = self.fontObject:getWidth(self.displayText)
	self.displayX = self.w * 0.5 - self.fontObject:getWidth(self.displayText) * 0.5
end

function uploadProg:updateUploadStatusText(status)
	self:setText(workshop:getItemUpdateStatusText(status))
	
	self.previousUploadStatus = status
end

function uploadProg:clearUploadData()
	self.previousUploadStatus = nil
	self.uploadText = nil
end

function uploadProg:think()
	if workshop:getItemCreationState() == workshop.MOD_PUBLISH_STATES.UPLOADING then
		local uploaded, total, status = steam.GetUploadData()
		
		self.uploadText = _format(_T("WORKSHOP_MOD_UPLOAD_PROGRESS", "UPLOADED/TOTALMB"), "UPLOADED", math.round(uploaded / 1024 / 1024, 4), "TOTAL", math.round(total / 1024 / 1024, 4))
		self.uploadTextX = self.w * 0.5 - self.fontObject:getWidth(self.uploadText) * 0.5
		self.uploadTextY = self.fontHeight + _S(5)
		
		if status ~= self.previousUploadStatus then
			self:updateUploadStatusText(status)
		end
	end
	
	if self.cycleDots then
		self.cycleTime = self.cycleTime + frameTime
		
		if self.cycleTime >= 1 then
			self.cycleTime = self.cycleTime - 1
			self.cycle = self.cycle + 1
			
			if self.cycle > #self.textCycle then
				self.cycle = 1
			end
			
			self:setDisplayText(self.textCycle[self.cycle])
		end
	end
end

function uploadProg:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayText, self.displayX, 0, 255, 255, 255, 255, 0, 0, 0, 255)
	
	if self.uploadText then
		love.graphics.printST(self.uploadText, self.uploadTextX, self.uploadTextY, 255, 255, 255, 255, 0, 0, 0, 255)
	end
end

gui.register("WorkshopModUploadProgress", uploadProg)
