local delayedRepDrop = {}

delayedRepDrop.repDrop = nil
delayedRepDrop.inactive = true
delayedRepDrop.id = "delayed_reputation_drop"

function delayedRepDrop:validateEvent()
	return true
end

function delayedRepDrop:activate()
	studio:decreaseReputation(self.repDrop)
end

function delayedRepDrop:setReputationDrop(drop)
	self.repDrop = drop
end

function delayedRepDrop:save()
	local saved = delayedRepDrop.baseClass.save(self)
	
	saved.repDrop = self.repDrop
	
	return saved
end

function delayedRepDrop:load(data)
	self.repDrop = data.repDrop
end

scheduledEvents:registerNew(delayedRepDrop)
