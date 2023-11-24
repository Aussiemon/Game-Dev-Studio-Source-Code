interests = {}
interests.registered = {}
interests.registeredByID = {}
interests.valid = {}
interests.MAX_INTERESTS = 2
interests.THANK_CHANCE = 25
interests.NEW_INTEREST_CHANCE = 33
interests.totalWeight = 0
interests.descboxWrapWidth = 350

local defaultInterestFuncs = {}

defaultInterestFuncs.mtindex = {
	__index = defaultInterestFuncs
}
defaultInterestFuncs.formatTable = {}

function defaultInterestFuncs:formatThankText(employee, object)
	self.formatTable.NAME = employee:getFullName(true)
	self.formatTable.OBJECT = object:getName()
	
	return string.formatbykeys(self.thankText, self.formatTable)
end

function defaultInterestFuncs:canHaveInterest(targetEmployee)
	return true
end

function defaultInterestFuncs:getIconConfig(backdropSize, iconSize)
	return {
		{
			icon = "profession_backdrop",
			width = backdropSize,
			height = backdropSize
		},
		{
			y = 1,
			x = 1,
			icon = self.quad,
			width = iconSize,
			height = iconSize
		}
	}
end

function defaultInterestFuncs:setupContributionDisplay(descBox, wrapWidth)
	if self.taskCount > 0 then
		descBox:addSpaceToNextText(10)
		descBox:addText(_T("INTEREST_CONTRIBUTES_TO_TASKS", "This interest provides knowledge which adds extra Quality points in certain tasks."), "pix18", nil, 4, math.max(200, wrapWidth * 0.75))
		descBox:addText(_format(_T("CONTRIBUTES_TO_TASKS_COUNTER", "Tasks contributing to: COUNTER"), "COUNTER", self.taskCount), "bh20", game.UI_COLORS.DARK_LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		
		return true
	end
	
	return false
end

function interests:registerNew(data)
	setmetatable(data, defaultInterestFuncs.mtindex)
	table.insert(interests.registered, data)
	
	interests.registeredByID[data.id] = data
	
	if data.selectableForPlayer == nil then
		data.selectableForPlayer = true
	end
	
	if data.selectableForSearch == nil then
		data.selectableForSearch = true
	end
	
	data.description = data.description or "'description' not set for this interest"
	data.quad = data.quad or "employee"
	data.taskCount = 0
	data.hoverText = data.hoverText or {
		{
			font = "pix20",
			text = data.description,
			wrapWidth = interests.descboxWrapWidth
		}
	}
	self.totalWeight = 0
end

function interests:setupContributionLists()
	local knowMap = knowledge.registeredByID
	local seenGenres = {}
	local seenThemes = {}
	local verifyContrib = {}
	
	for key, data in ipairs(self.registered) do
		if data.knowledgeProgression then
			local contributions = {}
			
			for key, progressData in ipairs(data.knowledgeProgression) do
				local knowledgeData = knowMap[progressData.id]
				local contrib = knowledgeData.contributions
				
				if knowledgeData.taskCount > 0 then
					data.taskCount = data.taskCount + knowledgeData.taskCount
				end
				
				if contrib then
					for key, contribData in ipairs(contrib) do
						verifyContrib[#verifyContrib + 1] = contribData
					end
				end
			end
			
			local rIdx = 1
			
			while true do
				local data = verifyContrib[rIdx]
				
				if not data then
					break
				else
					local idx = 1
					
					for i = 1, #verifyContrib do
						local otherData = verifyContrib[idx]
						
						if data ~= otherData and data.theme == otherData.theme and data.genre == otherData.genre then
							table.remove(verifyContrib, idx)
						else
							idx = idx + 1
						end
					end
					
					rIdx = rIdx + 1
				end
			end
			
			for key, data in ipairs(verifyContrib) do
				contributions[#contributions + 1] = {
					theme = data.theme,
					genre = data.genre
				}
				verifyContrib[key] = nil
			end
			
			knowledge:sortContributionsByAlphabet(contributions)
			
			data.knowledgeContributions = contributions
		end
		
		table.clear(seenGenres)
		table.clear(seenThemes)
		table.clearArray(verifyContrib)
	end
end

function interests:recalculateWeightRanges()
	self.totalWeight = 0
	
	for key, interestData in ipairs(self.registered) do
		self.totalWeight = self.totalWeight + 1
		interestData.startRange = self.totalWeight
		self.totalWeight = self.totalWeight + interestData.chance
		interestData.endRange = self.totalWeight
	end
end

function interests:findInterestByRange(range)
	for key, data in ipairs(self.registered) do
		if range <= data.startRange and range <= data.endRange then
			return data
		end
	end
	
	return nil
end

function interests:addKnowledgeProgression(interest, id, min, max)
	local data = interests.registeredByID[interest]
	
	data.knowledgeProgression = data.knowledgeProgression or {}
	
	table.insert(data.knowledgeProgression, {
		id = id,
		min = min,
		max = max
	})
end

function interests:assignToEmployee(employee)
	table.clear(self.valid)
	
	for key, data in ipairs(interests.registered) do
		if math.random(1, 100) <= data.chance and data:canHaveInterest(employee) then
			table.insert(self.valid, data)
		end
	end
	
	local validInterests = #self.valid
	
	if validInterests > 0 then
		local maxRange = math.random(0, math.min(interests.MAX_INTERESTS, validInterests))
		
		if maxRange > 0 then
			for i = 1, maxRange do
				local randomIndex = math.random(1, #self.valid)
				local randomInterest = self.valid[randomIndex]
				local canAdd = not self:hasMutuallyExclusiveInterests(employee, randomInterest.id)
				
				if canAdd then
					employee:addInterest(randomInterest.id)
				end
				
				table.remove(self.valid, randomIndex)
			end
		end
	end
end

function interests:addMutualExclusion(interestA, interestB)
	self:_addMutualExclusion(interestA, interestB)
	self:_addMutualExclusion(interestB, interestA)
end

function interests:_addMutualExclusion(a, b)
	local data = interests.registeredByID[a]
	
	data.mutualExclusion = data.mutualExclusion or {}
	data.mutualExclusion[b] = true
end

function interests:isMutuallyExcluded(interestA, interestB)
	local data = interests.registeredByID[interestA]
	
	return data.mutualExclusion and data.mutualExclusion[interestB] or false
end

function interests:hasMutuallyExclusiveInterests(employee, interestID)
	for key, interest in ipairs(employee:getInterests()) do
		if self:isMutuallyExcluded(interest, interestID) then
			return true
		end
	end
	
	return false
end

function interests:attemptGiveNewInterest(target, interest)
	local targetInterests = target:getInterests()
	
	if not target:hasInterest(interest) and #targetInterests < interests.MAX_INTERESTS and math.random(1, 100) <= interests.NEW_INTEREST_CHANCE then
		for key, traitID in ipairs(target:getTraits()) do
			local data = traits:getData(traitID)
			
			if not data:canHaveInterest(target, interest) then
				return false
			end
		end
		
		if self:hasMutuallyExclusiveInterests(target, interest) then
			return false
		end
		
		target:addInterest(interest)
	end
end

function interests:getData(id)
	return interests.registeredByID[id]
end

function interests:getInterestThankText(id)
	return interests.registeredByID[id].thankText
end

function interests:prepareInterestThankText(employee, object)
	local interestBoost, interestID = table.random(object:getInterests())
	local data = interests.registeredByID[interestID]
	
	return data:formatThankText(employee, object)
end

function interests:getPersonTitle(id)
	return interests.registeredByID[id].person
end

function interests:generateInterestDescription(id)
	local interestData = interests.registeredByID[id]
	local finalString = interestData.description
	local allProgression = self:generateKnowledgeProgressionString(id)
	
	if allProgression then
		finalString = finalString .. "\n\n" .. string.easyformatbykeys(_T("INTEREST_PROVIDES_KNOWLEDGE_CONTRIBUTION", "Provides knowledge in: CONTRIBUTION."), "CONTRIBUTION", self:generateKnowledgeProgressionString(id))
	else
		finalString = finalString .. "\n\n" .. _T("INTEREST_DOES_NOT_PROGRESS_KNOWLEDGE", "Does not provide any knowledge that would be useful in game development.")
	end
	
	return finalString
end

function interests:generateKnowledgeProgressionString(id)
	local interestData = interests.registeredByID[id]
	
	if interestData.knowledgeProgression then
		local finalString = ""
		local totalIndexes = #interestData.knowledgeProgression
		
		for key, data in ipairs(interestData.knowledgeProgression) do
			local knowledgeData = knowledge.registeredByID[data.id]
			
			if key == totalIndexes then
				finalString = finalString .. knowledgeData.display
			else
				finalString = finalString .. knowledgeData.display .. ", "
			end
		end
		
		return finalString
	end
	
	return nil
end

interests.INTEREST_INFO_DESCBOX_ID = "interest_info_descbox"

function interests:createInterestSelectionPopup(employee, selectElement)
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont("pix24")
	frame:setTitle(_T("INTERESTS", "Interests"))
	
	if selectElement:getSelectedInterest() then
		local closeButton = frame:getCloseButton()
		local deselect = gui.create("InterestDeselectButton", frame)
		
		deselect:setSize(200, 22)
		deselect:setFont("bh20")
		deselect:setText(_T("DESELECT_INTEREST", "Deselect interest"))
		deselect:setPos(closeButton.localX - deselect.w - _S(5), closeButton.localY)
		deselect:setSelectionElement(selectElement)
		
		deselect.basePanel = frame
	end
	
	local scroller = gui.create("ScrollbarPanel", frame)
	
	scroller:setSize(390, 560)
	scroller:setPos(_S(5), _S(35))
	scroller:setAdjustElementPosition(true)
	scroller:setSpacing(3)
	scroller:setPadding(3, 3)
	scroller:addDepth(200)
	
	for key, data in ipairs(self.registered) do
		if data.selectableForPlayer and not employee:hasInterest(data.id) then
			local element = gui.create("InterestSelectionButton")
			
			element:setSize(370, 45)
			element:setInterest(data)
			element:setSelectionElement(selectElement)
			
			element.basePanel = frame
			
			scroller:addItem(element)
		end
	end
	
	frame:center()
	
	local interestInfoDescbox = gui.create("GenericDescbox")
	
	interestInfoDescbox:tieVisibilityTo(frame)
	interestInfoDescbox:setID(interests.INTEREST_INFO_DESCBOX_ID)
	interestInfoDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	interestInfoDescbox:bringUp()
	frameController:push(frame)
end

interests:registerNew({
	drivePerPoint = 0.05,
	id = "lifting",
	quad = "interest_weightlifting",
	thankText = "NAME has thanked you for purchasing OBJECT, he says he'll be able to spend less time at the gym, which means higher drive.",
	selectableForPlayer = false,
	chance = 50,
	noObjectRepetition = true,
	display = _T("WEIGHTLIFTING", "Weightlifting"),
	person = _T("WEIGHTLIFTER_SINGULAR", "an athlete"),
	description = _T("WEIGHTLIFTING_DESCRIPTION", "The feeling of being physically strong is like a drug to some.\nPurchasing objects related to weightlifting will allow employees with this interest to maintain a high drive level for longer.")
})
interests:registerNew({
	drivePerPoint = 0,
	quad = "interest_firearms",
	id = "firearms",
	chance = 50,
	display = _T("FIREARMS", "Firearms"),
	person = _T("FIREARMS_SINGULAR", "a firearm enthusiast"),
	description = _T("FIREARMS_DESCRIPTION", "To these people, nothing beats the feeling of a gun recoiling in their hands as they fire it."),
	knowledgeProgression = {
		{
			id = "firearms",
			min = 2,
			max = 3
		}
	}
})
interests:registerNew({
	drivePerPoint = 0.05,
	person = "a martial artist",
	quad = "interest_martial_arts",
	id = "martialarts",
	thankText = "NAME has thanked you for purchasing OBJECT, he says he'll spend some of his training days here, which means higher drive.",
	chance = 50,
	display = _T("MARTIAL_ARTS", "Martial arts"),
	description = _T("MARTIAL_ARTS_DESCRIPTION", "Making a fighting game without having any knowledge on martial arts is like trying to impress a gun nut without having fired a weapon. Martial arts knowledge is crucial for any Fighting game looking to impress."),
	knowledgeProgression = {
		{
			id = "fighting",
			min = 1,
			max = 3
		}
	}
})
interests:registerNew({
	drivePerPoint = 0.05,
	quad = "activity_airsoft",
	id = "milsim",
	chance = 50,
	display = _T("MILSIM_INTEREST", "Mil-sim"),
	person = _T("MILSIM_ENTHUSIAST", "a mil-sim enthusiast"),
	description = _T("MILSIM_INTEREST_DESCRIPTION", "Taking interest in Mil-sim (ie. paintball or airsoft) will prove useful to those looking to gain knowledge on Military jargon."),
	knowledgeProgression = {
		{
			id = "firearms",
			min = 1,
			max = 1
		},
		{
			id = "military_jargon",
			min = 1,
			max = 2
		}
	}
})
interests:registerNew({
	drivePerPoint = 0.05,
	quad = "interest_parkour",
	id = "parkour",
	thankText = "NAME has thanked you for purchasing OBJECT, he says he'll spend some of his training days here, which means higher drive.",
	chance = 50,
	display = _T("PARKOUR", "Parkour"),
	person = _T("TRACER_SINGULAR", "a tracer"),
	description = _T("PARKOUR_DESCRIPTION", "Learn to effectively use your own momentum, get physically stronger and become more agile. What's not to like?"),
	knowledgeProgression = {
		{
			id = "parkour",
			min = 1,
			max = 3
		}
	}
})
interests:registerNew({
	drivePerPoint = 0,
	quad = "interest_hunting",
	id = "hunting",
	chance = 50,
	display = _T("HUNTING", "Hunting"),
	person = _T("HUNTER_SINGULAR", "a hunter"),
	description = _T("HUNTING_DESCRIPTION", "Patience, firearm knowledge and camouflage are the things you think of when someone mentions hunting. Hunting provides knowledge in Stealth and Firearms."),
	knowledgeProgression = {
		{
			id = "stealth",
			min = 1,
			max = 3
		},
		{
			id = "firearms",
			amount = 1
		},
		{
			id = "survival",
			min = 0,
			max = 1
		}
	}
})
interests:registerNew({
	drivePerPoint = 0,
	id = "pacifism",
	quad = "interest_pacifism",
	selectableForPlayer = false,
	chance = 10,
	noObjectRepetition = true,
	selectableForSearch = false,
	display = _T("PACIFISM", "Pacifism"),
	description = _T("PACIFISM_DESCRIPTION", "Peace, brutha!"),
	person = _T("PACIFIST_SINGULAR", "a pacifist")
})
interests:addMutualExclusion("pacifism", "milsim")
interests:addMutualExclusion("pacifism", "firearms")
interests:registerNew({
	drivePerPoint = 0,
	quad = "interest_photography",
	id = "photography",
	chance = 50,
	display = _T("PHOTOGRAPHY", "Photography"),
	person = _T("PHOTOGRAPHER_SINGULAR", "a photographer"),
	description = _T("PHOTOGRAPHY_DESCRIPTION", "Having the right reference material can make all the difference between photorealism and uncanny valley."),
	knowledgeProgression = {
		{
			id = "photography",
			min = 1,
			max = 3
		}
	}
})
interests:registerNew({
	drivePerPoint = 0,
	quad = "interest_public_speaking",
	id = "public_speaking",
	chance = 50,
	display = _T("PUBLIC_SPEAKING", "Public speaking"),
	person = _T("PUBLIC_SPEAKER", "an orator"),
	description = _T("PUBLIC_SPEAKING_DESCRIPTION", "Public speaking is an important aspect of being a leader. A good speaking ability is necessary to rouse Drive within your subordinates.\n\nThis interest will provide Public speaking knowledge, which will aid in motivational speeches, damage control and help attract more people to your booth in game conventions."),
	knowledgeProgression = {
		{
			id = "public_speaking",
			min = 1,
			max = 3
		}
	}
})
interests:registerNew({
	drivePerPoint = 0,
	quad = "interest_medieval_fighting",
	id = "medieval_fighting",
	chance = 50,
	display = _T("MEDIEVAL_FIGHTING", "Medieval fighting"),
	description = _T("MEDIEVAL_FIGHTING_DESCRIPTION", "Taking an interest in the medieval ages will surely help with making better games set in the medieval times."),
	person = _T("MEDIEVAL_SINGULAR", "a person interested in the medieval times"),
	knowledgeProgression = {
		{
			id = "medieval_fighting",
			min = 1,
			max = 3
		}
	}
})
interests:registerNew({
	drivePerPoint = 0,
	quad = "interest_machine_learning",
	id = "machine_learning",
	chance = 50,
	display = _T("MACHINE_LEARNING", "Machine learning"),
	person = _T("MACHINE_LEARNING_ENTHUSIAST", "a machine learning enthusiast"),
	description = _T("MACHINE_LEARNING_DESCRIPTION", "Besides being interested in programming in general, this person is very interested in machine learning.\n\nMachine learning helps in understanding how to create better artificial intelligence."),
	availabilityDate = {
		year = 1994,
		month = 2
	},
	knowledgeProgression = {
		{
			id = "machine_learning",
			min = 1,
			max = 3
		}
	},
	canHaveInterest = function(self, targetEmployee)
		if targetEmployee:getRole() ~= "software_engineer" then
			return false
		end
		
		local availability = self.availabilityDate
		
		if timeline.curTime < timeline:getDateTime(availability.year, availability.month) then
			return false
		end
		
		return true
	end
})
interests:registerNew({
	drivePerPoint = 0,
	id = "abstract_art",
	quad = "interest_abstract_art",
	chance = 50,
	display = _T("ABSTRACT_ART", "Abstract art"),
	person = _T("ABSTRACT_ART_ENTHUSIAST", "an abstract art enthusiast"),
	description = _T("ABSTRACT_ART_DESCRIPTION", "Based entirely on the depths of the human imagination. Art consisting of unusual shapes & forms, colors, and lines are appreciated by many."),
	knowledgeProgression = {
		{
			id = "stylizing",
			min = 1,
			max = 3
		}
	}
})
interests:registerNew({
	id = "primitive_technology",
	chance = 50,
	quad = "interest_primitive_technology",
	drivePerPoint = 0,
	display = _T("PRIMITIVE_TECHNOLOGY", "Primitive technology"),
	person = _T("PRIMITIVE_TECHNOLOGY_ENTHUSIAST", "an primitive technology enthusiast"),
	knowledgeProgression = {
		{
			id = "survival",
			min = 1,
			max = 3
		},
		{
			id = "primitive_technology",
			min = 1,
			max = 2
		}
	},
	description = _T("PRIMITIVE_TECHNOLOGY_DESCRIPTION", "Going camping with just the bare minimum and then making your own tools out of whatever you can find will surely make you knowledgeable in Survival.")
})
interests:registerNew({
	id = "auto_racing",
	chance = 50,
	quad = "interest_auto_racing",
	drivePerPoint = 0,
	display = _T("AUTO_RACING", "Auto racing"),
	person = _T("AUTO_RACING_ENTHUSIAST", "an auto racing enthusiast"),
	knowledgeProgression = {
		{
			id = "vehicles",
			min = 1,
			max = 3
		}
	},
	description = _T("AUTO_RACING_DESCRIPTION", "Some people love fast cars, and what better way is there to indulge in that love than competitive racing?")
})
