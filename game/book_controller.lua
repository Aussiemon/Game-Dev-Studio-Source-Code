bookController = {}
bookController.registered = {}
bookController.registeredByID = {}
bookController.totalMaximumBoosts = {}
bookController.BOOST_ELEMENT_WIDTH = 100
bookController.BOOST_ELEMENT_HEIGHT = 34
bookController.EVENTS = {
	BOOK_PURCHASED = events:new(),
	BOOK_PLACED = events:new(),
	BOOK_REMOVED = events:new(),
	RECALCULATED_BOOSTS = events:new()
}
bookController.CATCHABLE_EVENTS = {
	officeBuilding.EVENTS.PURCHASED
}

function bookController:init()
	self.ownedBooks = {}
	self.ownedBookCount = {}
	self.allocatedBooks = {}
	self.inUseBooks = {}
	self.unlockedBooks = {}
	self.skillExperienceBoosts = {}
	self.currentDisplayedBooks = {}
	self.bookshelfObjects = {}
	self.unallocatedBooks = {}
	self.highestSkillLevels = {}
	self.averageSkillLevels = {}
	
	events:addDirectReceiver(self, bookController.CATCHABLE_EVENTS)
end

function bookController:remove()
	table.clear(self.ownedBooks)
	table.clear(self.ownedBookCount)
	table.clear(self.inUseBooks)
	table.clear(self.allocatedBooks)
	table.clear(self.unlockedBooks)
	table.clear(self.skillExperienceBoosts)
	table.clear(self.unallocatedBooks)
	table.clear(self.bookshelfObjects)
	table.clear(self.currentDisplayedBooks)
end

function bookController:handleEvent(event, building)
	if event == officeBuilding.EVENTS.PURCHASED then
		self:prepareOffice(building)
	end
end

function bookController:prepareOffices()
	for key, object in ipairs(studio:getOwnedBuildings()) do
		self:prepareOffice(object)
		self:recalculateSkillExperienceBoosts(object)
	end
end

function bookController:prepareOffice(officeObject)
	if self.allocatedBooks[officeObject] then
		return 
	end
	
	self.allocatedBooks[officeObject] = self.allocatedBooks[officeObject] or {}
	self.skillExperienceBoosts[officeObject] = self.skillExperienceBoosts[officeObject] or {}
	
	local boosts = self.skillExperienceBoosts[officeObject]
	
	for key, skillData in ipairs(skills.registered) do
		boosts[skillData.id] = 1
	end
end

function bookController:addBookshelfObject(bookshelf)
	table.insert(self.bookshelfObjects, bookshelf)
end

function bookController:removeBookshelfObject(bookshelf)
	if self.bookshelfObjects then
		for key, otherBookshelf in ipairs(self.bookshelfObjects) do
			if otherBookshelf == bookshelf then
				table.remove(self.bookshelfObjects, key)
				
				break
			end
		end
	end
end

function bookController:getBookshelves()
	return self.bookshelfObjects
end

function bookController:getUnallocatedBooks(officeObject)
	for key, bookID in ipairs(self.ownedBooks) do
		if not self.allocatedBooks[officeObject][bookID] then
			local inUse = self.inUseBooks[bookID]
			
			if not inUse or inUse < self.ownedBookCount[bookID] then
				self.unallocatedBooks[#self.unallocatedBooks + 1] = bookID
			end
		end
	end
	
	return self.unallocatedBooks
end

function bookController:allocateBook(bookID, bookshelf, skipRecalculation)
	local office = bookshelf:getOffice()
	
	self:prepareOffice(office)
	
	self.allocatedBooks[office][bookID] = true
	self.inUseBooks[bookID] = (self.inUseBooks[bookID] or 0) + 1
	self.lastBookChange = bookID
	
	if not skipRecalculation then
		self:recalculateSkillExperienceBoosts(bookshelf:getOffice())
	end
	
	events:fire(bookController.EVENTS.BOOK_PLACED, bookID, bookshelf)
end

function bookController:recalculateAllSkillExperienceBoosts()
	for key, object in ipairs(studio:getOwnedBuildings()) do
		self:recalculateSkillExperienceBoosts(object)
	end
end

function bookController:deallocateBook(bookID, bookshelf, skipRecalculation)
	self.allocatedBooks[bookshelf:getOffice()][bookID] = nil
	self.inUseBooks[bookID] = self.inUseBooks[bookID] - 1
	self.lastBookChange = bookID
	
	if not skipRecalculation then
		self:recalculateSkillExperienceBoosts(bookshelf:getOffice())
	end
	
	events:fire(bookController.EVENTS.BOOK_REMOVED, bookID, bookshelf)
end

function bookController:recalculateSkillExperienceBoosts(officeObject)
	local boosts = self.skillExperienceBoosts[officeObject]
	
	for key, skillData in ipairs(skills.registered) do
		boosts[skillData.id] = 1
	end
	
	for bookName, bookshelfObject in pairs(self.allocatedBooks[officeObject]) do
		local bookData = bookController.registeredByID[bookName]
		
		boosts[bookData.skillBoost.id] = boosts[bookData.skillBoost.id] + bookData.skillBoost.boost
		
		bookData:onRecalculateSkillExperienceBoosts()
	end
	
	events:fire(bookController.EVENTS.RECALCULATED_BOOSTS, self.lastBookChange)
end

function bookController:getUnlockedBooks()
	return self.unlockedBooks
end

function bookController:isBookUnlocked(bookID)
	return bookController.registeredByID[bookID]:isUnlocked()
end

function bookController:onCloseFrame()
	self.currentBookshelfObject = nil
	self.currentOffice = nil
	
	table.clear(self.currentDisplayedBooks)
end

function bookController:createBookInventoryElement(bookData)
	local element = gui.create("BookInventoryElement")
	
	element:setBookData(bookData)
	element:setHeight(64)
	
	return element
end

function bookController:isBookAllocated(office, bookID)
	if not self.allocatedBooks[office] then
		return 
	end
	
	return self.allocatedBooks[office][bookID]
end

function bookController:createInventoryBooks(scrollbarPanel)
	local office = self.currentBookshelfObject:getOffice()
	
	for key, bookID in ipairs(self.ownedBooks) do
		if self:getAllocatableBookCount(bookID) > 0 and not self.allocatedBooks[office][bookID] then
			scrollbarPanel:addItem(self:createBookInventoryElement(bookController.registeredByID[bookID]))
		end
	end
end

function bookController:createBookPurchaseElement(bookData)
	local element = gui.create("BookPurchaseElement")
	
	element:setBookData(bookData)
	element:setHeight(64)
	
	return element
end

function bookController:setupSkillLevelInfoData()
	local office = self.currentBookshelfObject:getOffice()
	local employees = office:getEmployees()
	
	for key, data in ipairs(skills.registered) do
		local skillID = data.id
		
		self.highestSkillLevels[skillID] = 0
		self.averageSkillLevels[skillID] = 0
		
		local matchedRoles = 0
		
		for key, employee in ipairs(employees) do
			local skillLevel = employee:getSkillLevel(skillID)
			
			self.highestSkillLevels[skillID] = math.max(self.highestSkillLevels[skillID], skillLevel)
			
			local roleData = employee:getRoleData()
			
			if roleData.mainSkill then
				if roleData.mainSkill == skillID then
					self.averageSkillLevels[skillID] = self.averageSkillLevels[skillID] + skillLevel
					matchedRoles = matchedRoles + 1
				end
			elseif not data.developmentSkill then
				self.averageSkillLevels[data.id] = self.averageSkillLevels[data.id] + skillLevel
				matchedRoles = matchedRoles + 1
			end
		end
		
		if matchedRoles > 0 then
			self.averageSkillLevels[skillID] = math.min(data.maxLevel, math.floor(self.averageSkillLevels[skillID] / matchedRoles))
		else
			self.averageSkillLevels[skillID] = 0
		end
		
		self.highestSkillLevels[skillID] = math.min(data.maxLevel, self.highestSkillLevels[skillID])
	end
end

function bookController:resetSkillLevelInfoData()
	for key, data in ipairs(skills.registered) do
		self.highestSkillLevels[data.id] = 0
		self.averageSkillLevels[data.id] = 0
	end
end

function bookController:getSkillLevelInfo()
	return self.averageSkillLevels, self.highestSkillLevels
end

function bookController:createBookPurchaseMenu(bookshelfObject)
	self.currentBookshelfObject = bookshelfObject
	
	self:setupSkillLevelInfoData()
	
	self.currentOffice = bookshelfObject:getOffice()
	
	local yOffset = 85
	local frame = gui.create("BookManagementFrame")
	
	frame:setSize(350, 450)
	frame:setFont("pix24")
	frame:setTitle(_T("BOOK_MANAGEMENT_TITLE", "Book management"))
	
	local propertysheet = gui.create("PropertySheet", frame)
	
	propertysheet:setPos(_S(5), _S(32 + yOffset))
	propertysheet:setTabOffset(4, 4)
	propertysheet:setSize(frame.rawW - 10, frame.rawH - (25 + yOffset))
	propertysheet:setFont(fonts.get("pix24"))
	
	local bookshelfInfo = gui.create("BookshelfInfoDisplay", frame, bookshelfObject)
	
	bookshelfInfo:setPos(_S(5), _S(35))
	bookshelfInfo:setSize(frame.rawW - 10, 81.333)
	
	local shopPanel = gui.create("BookPurchaseScrollbarPanel")
	
	shopPanel:setSize(propertysheet.rawW, propertysheet.rawH - 42)
	shopPanel:setSpacing(3)
	shopPanel:setPadding(3, 3)
	shopPanel:setAdjustElementPosition(true)
	shopPanel:addDepth(100)
	
	for key, bookData in ipairs(self.registered) do
		if bookData:isBookUnlocked() and self:getBuyableBookCount(bookData.id) > 0 then
			shopPanel:addItem(self:createBookPurchaseElement(bookData))
		end
	end
	
	propertysheet:addItem(shopPanel, _T("BOOKS_SHOP", "Shop"), nil, 25, nil)
	
	local inventoryPanel = gui.create("BookInventoryScrollbarPanel")
	
	inventoryPanel:setSize(propertysheet.rawW, propertysheet.rawH - 42)
	inventoryPanel:setSpacing(3)
	inventoryPanel:setPadding(3, 3)
	inventoryPanel:setAdjustElementPosition(true)
	inventoryPanel:addDepth(100)
	self:createInventoryBooks(inventoryPanel)
	propertysheet:addItem(inventoryPanel, _T("BOOKS_INVENTORY", "Inventory"), nil, 26, nil)
	frame:center()
	frame:createBookBoostList()
	frameController:push(frame)
end

function bookController:getCurrentBookshelfObject()
	return self.currentBookshelfObject
end

function bookController:getNextBookOfSkillBoost(previousBookID, boostSkillID)
	for key, bookData in ipairs(bookController.registered) do
		if bookData.id ~= previousBookID and bookData.skillBoost and bookData.skillBoost.id == boostSkillID and not self.unlockedBooks[bookData.id] and not self.currentDisplayedBooks[bookData.id] and bookData:isBookUnlocked() then
			return bookData
		end
	end
	
	return nil
end

function bookController:getSkillExperienceBoost(skillID, officeObject)
	officeObject = officeObject or self.currentOffice
	
	return self.skillExperienceBoosts[officeObject][skillID]
end

function bookController:formulateSkillBoostText(skillID, short, office)
	local skillData = skills:getData(skillID)
	
	office = office or self.currentBookshelfObject:getOffice()
	
	local baseText = short and _T("BOOK_BOOST_LAYOUT_SHORT", "+BOOST% SKILL XP gain") or _T("BOOK_BOOST_LAYOUT", "+BOOST% SKILL experience gain")
	
	return string.easyformatbykeys(baseText, "BOOST", math.round(self.skillExperienceBoosts[office][skillID] * 100 - 100), "SKILL", skillData.display)
end

function bookController:getSkillExperienceBoosts(officeObject)
	return self.skillExperienceBoosts[officeObject]
end

function bookController:getBuyableBookCount(bookID)
	return #studio:getOwnedBuildings() - (self.ownedBookCount[bookID] or 0)
end

function bookController:getAllocatableBookCount(bookID)
	return self.ownedBookCount[bookID] - (self.inUseBooks[bookID] or 0)
end

function bookController:purchaseBook(bookID)
	if self:getBuyableBookCount(bookID) == 0 then
		return 
	end
	
	local data = bookController.registeredByID[bookID]
	
	studio:deductFunds(data.cost, nil, "misc")
	
	if not table.find(self.ownedBooks, bookID) then
		self.ownedBooks[#self.ownedBooks + 1] = bookID
	end
	
	self.ownedBookCount[bookID] = (self.ownedBookCount[bookID] or 0) + 1
	self.unlockedBooks[bookID] = true
	
	data:onPurchase()
	events:fire(bookController.EVENTS.BOOK_PURCHASED, bookID)
end

function bookController:getBookData(bookID)
	return bookController.registeredByID[bookID]
end

function bookController:getMaxSkillBoost(skillID)
	return self.totalMaximumBoosts[skillID] or 0
end

function bookController:save()
	return {
		ownedBooks = self.ownedBooks,
		unlockedBooks = self.unlockedBooks,
		ownedBookCount = self.ownedBookCount
	}
end

function bookController:load(data)
	if not data then
		return 
	end
	
	self.ownedBooks = data.ownedBooks or self.ownedBooks
	self.unlockedBooks = data.unlockedBooks or self.unlockedBooks
	self.ownedBookCount = data.ownedBookCount or self.ownedBookCount
end

function bookController:postLoad()
	self:prepareOffices()
end

local baseBookFuncs = {}

baseBookFuncs.mtindex = {
	__index = baseBookFuncs
}

function baseBookFuncs:onRecalculateSkillExperienceBoosts()
end

function baseBookFuncs:formulateBoostText()
	if self.skillBoost then
		local skillData = skills:getData(self.skillBoost.id)
		
		return string.easyformatbykeys(_T("BOOK_BOOST_LAYOUT", "+BOOST% SKILL experience gain"), "BOOST", math.round(self.skillBoost.boost * 100), "SKILL", skillData.display)
	end
	
	return nil
end

function baseBookFuncs:isBookUnlocked()
	if self.bookRequirements then
		local books = bookController:getUnlockedBooks()
		
		for key, bookID in ipairs(self.bookRequirements) do
			if not books[bookID] then
				return false
			end
		end
	end
	
	return true
end

function baseBookFuncs:getCost()
	return self.cost
end

function baseBookFuncs:onPurchase()
end

function bookController.registerBook(data)
	table.insert(bookController.registered, data)
	
	bookController.registeredByID[data.id] = data
	
	if data.skillBoost then
		bookController.totalMaximumBoosts[data.skillBoost.id] = (bookController.totalMaximumBoosts[data.skillBoost.id] or 0) + data.skillBoost.boost
	end
	
	data.icon = data.icon or "bookstack_1"
	
	setmetatable(data, baseBookFuncs.mtindex)
end

bookController.registerBook({
	cost = 500,
	id = "software_book_1",
	icon = "book_software",
	display = _T("SOFTWARE_BOOK_1_NAME", "Software: Introduction to algorithms"),
	description = {
		{
			font = "pix16",
			text = _T("SOFTWARE_BOOK_1_DESCRIPTION_1", "A collection of books that introduce and explain various common problem-solving algorithms.")
		}
	},
	skillBoost = {
		id = "software",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1000,
	id = "software_book_2",
	icon = "book_software",
	display = _T("SOFTWARE_BOOK_2_NAME", "Software: Advanced system design"),
	description = {
		{
			font = "pix16",
			text = _T("SOFTWARE_BOOK_2_DESCRIPTION", "This book collection explains how to write systems that work in tandem with each other efficiently.")
		}
	},
	bookRequirements = {
		"software_book_1"
	},
	skillBoost = {
		id = "software",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1500,
	id = "software_book_3",
	icon = "book_software",
	display = _T("SOFTWARE_BOOK_3_NAME", "Software: Large project maintenance"),
	description = {
		{
			font = "pix16",
			text = _T("SOFTWARE_BOOK_3_DESCRIPTION", "A big collection of books that delve deep into the ins and outs of how to write easily-maintainable code in a large production environment.")
		}
	},
	bookRequirements = {
		"software_book_2"
	},
	skillBoost = {
		id = "software",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 200,
	id = "development_book_1",
	icon = "book_development",
	display = _T("DEVELOPMENT_BOOK_1_NAME", "Development: Planning ahead"),
	description = {
		{
			font = "pix16",
			text = _T("DEVELOPMENT_BOOK_1_DESCRIPTION", "A collection of books that explain how to minimize work time by planning things ahead.")
		}
	},
	skillBoost = {
		id = "development",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 400,
	id = "development_book_2",
	icon = "book_development",
	display = _T("DEVELOPMENT_BOOK_2_NAME", "Development: Get yourself sorted"),
	description = {
		{
			font = "pix16",
			text = _T("DEVELOPMENT_BOOK_2_DESCRIPTION", "Books written by a renowned psychologist, provides great help on sorting your personal problems out, which can help greatly in time-critical situations, as well in staying focused.")
		}
	},
	bookRequirements = {
		"development_book_1"
	},
	skillBoost = {
		id = "development",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 600,
	id = "development_book_3",
	icon = "book_development",
	display = _T("DEVELOPMENT_BOOK_3_NAME", "Development: Time management"),
	description = {
		{
			font = "pix16",
			text = _T("DEVELOPMENT_BOOK_3_DESCRIPTION", "Another book collection which provides advice on how to manage free time very efficiently.")
		}
	},
	bookRequirements = {
		"development_book_2"
	},
	skillBoost = {
		id = "development",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 500,
	id = "sound_book_1",
	icon = "book_sound",
	display = _T("SOUND_BOOK_1_NAME", "Audio: Aestho Electro"),
	description = {
		{
			font = "pix16",
			text = _T("SOUND_BOOK_1_DESCRIPTION", "Great music will be much easier to make with this book collection on a bookshelf.")
		}
	},
	skillBoost = {
		id = "sound",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1000,
	id = "sound_book_2",
	icon = "book_sound",
	display = _T("SOUND_BOOK_2_NAME", "Audio: A guide to gun sounds"),
	description = {
		{
			font = "pix16",
			text = _T("SOUND_BOOK_2_DESCRIPTION", "This book collection comes with sample material and will help you create convincing firearm sounds.")
		}
	},
	bookRequirements = {
		"sound_book_1"
	},
	skillBoost = {
		id = "sound",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1500,
	id = "sound_book_3",
	icon = "book_sound",
	display = _T("SOUND_BOOK_3_NAME", "Audio: Leaves rustling"),
	description = {
		{
			font = "pix16",
			text = _T("SOUND_BOOK_3_DESCRIPTION", "A collection of books explaining how to record great-sounding ambient sounds.")
		}
	},
	bookRequirements = {
		"sound_book_2"
	},
	skillBoost = {
		id = "sound",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 500,
	id = "graphics_book_1",
	icon = "book_graphics",
	display = _T("GRAPHICS_BOOK_1_NAME", "Graphics: Human Anatomy"),
	description = {
		{
			font = "pix16",
			text = _T("GRAPHICS_BOOK_1_DESCRIPTION", "Stick figures ain't gonna cut it. Stylized or realistic - it doesn't matter, you need to know proportions of the human body.")
		}
	},
	skillBoost = {
		id = "graphics",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1000,
	id = "graphics_book_2",
	icon = "book_graphics",
	display = _T("GRAPHICS_BOOK_2_NAME", "Graphics: Color palettes"),
	description = {
		{
			font = "pix16",
			text = _T("GRAPHICS_BOOK_2_DESCRIPTION", "A collection of books explaining how to pick proper color palettes for any image composition.")
		}
	},
	bookRequirements = {
		"graphics_book_1"
	},
	skillBoost = {
		id = "graphics",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1500,
	id = "graphics_book_3",
	icon = "book_graphics",
	display = _T("GRAPHICS_BOOK_3_NAME", "Graphics: Motion & Movement"),
	description = {
		{
			font = "pix16",
			text = _T("GRAPHICS_BOOK_3_DESCRIPTION", "These books will allow you to learn how to animate convicing movement easy and quickly.")
		}
	},
	bookRequirements = {
		"graphics_book_2"
	},
	skillBoost = {
		id = "graphics",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 500,
	id = "concept_book_1",
	icon = "book_concept",
	display = _T("CONCEPT_BOOK_1_NAME", "Concept: Write it down!"),
	description = {
		{
			font = "pix16",
			text = _T("CONCEPT_BOOK_1_DESCRIPTION", "These books explain the basics of how to design a game and not jump from feature to feature, ensuring efficient time utilisation.")
		}
	},
	skillBoost = {
		id = "concept",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1000,
	id = "concept_book_2",
	icon = "book_concept",
	display = _T("CONCEPT_BOOK_2_NAME", "Concept: Ain't broke? Don't fix."),
	description = {
		{
			font = "pix16",
			text = _T("CONCEPT_BOOK_2_DESCRIPTION", "Common game design mistakes and things to look out for are described here.")
		}
	},
	bookRequirements = {
		"concept_book_1"
	},
	skillBoost = {
		id = "concept",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1500,
	id = "concept_book_3",
	icon = "book_concept",
	display = _T("CONCEPT_BOOK_3_NAME", "Concept: Improvisation - final layer"),
	description = {
		{
			font = "pix16",
			text = _T("CONCEPT_BOOK_3_DESCRIPTION", "This book collection explains the importance of game feature improvisation and not planning every single feature out in advance.")
		}
	},
	bookRequirements = {
		"concept_book_2"
	},
	skillBoost = {
		id = "concept",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 500,
	id = "management_book_1",
	icon = "book_management",
	display = _T("MANAGEMENT_BOOK_1_NAME", "Management: Welcome to the studio"),
	description = {
		{
			font = "pix16",
			text = _T("MANAGEMENT_BOOK_1_DESCRIPTION", "A great collection of books that explains how to ease new workers into working positions, allowing you to save time and, preferably, money.")
		}
	},
	skillBoost = {
		id = "management",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1000,
	id = "management_book_2",
	icon = "book_management",
	display = _T("MANAGEMENT_BOOK_2_NAME", "Management: Time is money"),
	description = {
		{
			font = "pix16",
			text = _T("MANAGEMENT_BOOK_2_DESCRIPTION", "The basics of employee management are explained in these books, which will aid managers with learning how to manage more people.")
		}
	},
	bookRequirements = {
		"management_book_1"
	},
	skillBoost = {
		id = "management",
		boost = 0.1
	}
})
bookController.registerBook({
	cost = 1500,
	id = "management_book_3",
	icon = "book_management",
	display = _T("MANAGEMENT_BOOK_3_NAME", "Management: Take a break"),
	description = {
		{
			font = "pix16",
			text = _T("MANAGEMENT_BOOK_3_DESCRIPTION", "Know when to and when not to push your employees to the limit with crunch time with these books.")
		}
	},
	bookRequirements = {
		"management_book_2"
	},
	skillBoost = {
		id = "management",
		boost = 0.1
	}
})
