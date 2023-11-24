gameEditions = {}
gameEditions.registeredBase = {}
gameEditions.registeredBaseByID = {}
gameEditions.registeredParts = {}
gameEditions.registeredPartsByID = {}
gameEditions.DEFAULT_DESIRE = 0
gameEditions.maxValue = 0
gameEditions.DEFAULT_EDITION = "regular"
gameEditions.MAX_PRICE = 200
gameEditions.ADVANCE_PAYMENT = 10000
gameEditions.EVENTS = {
	PART_ADDED = events:new(),
	PART_REMOVED = events:new(),
	SETUP_ELEMENT_SELECTED = events:new(),
	NAME_SET = events:new(),
	PRICE_CHANGED = events:new(),
	MENU_OPENED = events:new()
}

local editionClass = {}

editionClass.mtindex = {
	__index = editionClass
}
editionClass.icons = {
	{
		"game_edition_regular",
		0
	},
	{
		"game_edition_special",
		2
	},
	{
		"game_edition_deluxe",
		4
	},
	{
		"game_edition_limited",
		7
	},
	{
		"game_edition_collectors",
		9
	}
}

function editionClass:init()
	self.content = {}
	self.contentMap = {}
	self.value = 0
	self.realValue = 0
	self.produceCost = 0
	self.sales = 0
	self.desire = 1
	self.price = 0
	self.upFrontCost = 0
	self.freeBuffer = gameEditions.ADVANCE_PAYMENT
	self.deletable = true
end

function editionClass:updateIcon()
	local cnt = #self.content
	local highest, bestIcon = -math.huge
	
	for key, cfg in ipairs(self.icons) do
		local required = cfg[2]
		
		if required <= cnt and highest < required then
			bestIcon = cfg[1]
			highest = required
		end
	end
	
	self.icon = bestIcon or self.icons[1][1]
end

function editionClass:modulatePrice(sales)
	local buf = self.freeBuffer
	
	if buf > 0 then
		local delta = buf - sales
		
		self.freeBuffer = math.max(0, delta)
		
		if delta < 0 then
			local absDelta = -delta
			
			return buf / sales * self.price + absDelta / sales * self.realPrice
		end
	else
		return self.realPrice
	end
	
	return self.price
end

function editionClass:getRealPrice()
	return self.realPrice
end

function editionClass:updateRealPrice()
	self.realPrice = self.price - self.produceCost
end

function editionClass:updateUpFrontCost()
	self.upFrontCost = gameEditions.ADVANCE_PAYMENT * self.produceCost
end

function editionClass:adjustPreReleaseSaleBuffer()
	if self.project:getReleaseDate() then
		return 
	end
	
	if self.produceCost > 0 then
		self.freeBuffer = gameEditions.ADVANCE_PAYMENT
	else
		self.freeBuffer = 0
	end
end

function editionClass:validateSaleBuffer()
	if self.produceCost > 0 then
		self.freeBuffer = math.max(0, self.freeBuffer - self.sales)
	else
		self.freeBuffer = 0
	end
end

function editionClass:getUpFrontCost()
	return self.upFrontCost
end

function editionClass:getFreeCopies()
	return self.freeCopies
end

function editionClass:setDeletable(state)
	self.deletable = state
end

function editionClass:getDeletable()
	return self.deletable
end

function editionClass:getValue()
	return self.value
end

function editionClass:getRealValue()
	return self.realValue
end

function editionClass:getDesire()
	return self.desire
end

function editionClass:getDesireDisplay()
	return math.round(self.desire * 100, 1)
end

function editionClass:setPrice(price)
	self.price = price
	
	self:updateRealPrice()
	events:fire(gameEditions.EVENTS.PRICE_CHANGED, self)
end

function editionClass:getPrice()
	return self.price
end

function editionClass:getIcon()
	return self.icon
end

function editionClass:setProject(proj)
	if proj ~= self.project then
		self.project = proj
		
		if proj:getPrice() then
			self:setPrice(proj:getPrice())
		end
	end
end

function editionClass:getProject()
	return self.project
end

function editionClass:fullRecalculate()
	self.value = 0
	self.produceCost = 0
	self.desire = 1
	
	local genre = self.project:getGenre()
	
	for key, partData in ipairs(self.content) do
		self.value = self.value + partData:getValue()
		self.produceCost = self.produceCost + partData:getProduceCost()
		self.desire = self.desire + partData:getDesire(genre)
	end
	
	self:updateVariables()
end

function editionClass:setDebugPrice()
	self:setPrice(self.project:getPrice() + self.produceCost * 1.5)
end

function editionClass:updateRealValue()
	self.realValue = self.value - self.produceCost
end

function editionClass:calculateSaleModifier()
end

function editionClass:setName(name)
	if name == string.withoutspaces("") then
		name = self:getDefaultName()
	end
	
	self.name = name
	
	events:fire(gameEditions.EVENTS.NAME_SET, self)
end

function editionClass:getDefaultName()
	for key, edit in ipairs(self.project:getEditions()) do
		if edit == self then
			return _format(_T("DEFAULT_GAME_EDITION_NAME", "Edition #NUMBER"), "NUMBER", key)
		end
	end
	
	return "invalid edition"
end

function editionClass:getName()
	return self.name
end

function editionClass:updateVariables()
	self:updateRealValue()
	self:updateRealPrice()
	self:updateUpFrontCost()
	self:updateIcon()
	self.project:updateEditionPayment()
	self.project:calculateEditionPurchasePercentages()
	self:adjustPreReleaseSaleBuffer()
end

function editionClass:addPart(partData, skipCalc)
	self.content[#self.content + 1] = partData
	self.contentMap[partData.id] = true
	
	self:changeValue(partData:getValue())
	self:changeProduceCost(partData:getProduceCost())
	self:changeDesire(partData:getDesire(self.project:getGenre()))
	
	if not skipCalc then
		self:updateVariables()
	end
	
	events:fire(gameEditions.EVENTS.PART_ADDED, self)
end

function editionClass:removePart(partData)
	table.removeObject(self.content, partData)
	
	self.contentMap[partData.id] = nil
	
	self:changeValue(-partData:getValue())
	self:changeProduceCost(-partData:getProduceCost())
	self:changeDesire(partData:getDesire(self.project:getGenre()))
	self:updateVariables()
	events:fire(gameEditions.EVENTS.PART_REMOVED, self)
end

function editionClass:getParts()
	return self.content
end

function editionClass:hasPart(id)
	return self.contentMap[id]
end

function editionClass:changeValue(value)
	self.value = self.value + value
end

function editionClass:changeProduceCost(value)
	self.produceCost = self.produceCost + value
end

function editionClass:getProduceCost()
	return self.produceCost
end

function editionClass:changeDesire(value)
	self.desire = self.desire + value
end

function editionClass:changeSales(sales)
	self.sales = self.sales + sales
end

function editionClass:getSales()
	return self.sales
end

function editionClass:save()
	local content = {}
	
	for key, partData in ipairs(self.content) do
		content[key] = partData.id
	end
	
	return {
		content = content,
		sales = self.sales,
		name = self.name,
		price = self.price,
		deletable = self.deletable,
		freeBuffer = self.freeBuffer
	}
end

function editionClass:load(data)
	self.sales = data.sales
	self.name = data.name
	self.price = data.price
	self.deletable = data.deletable
	self.freeBuffer = data.freeBuffer
	
	local parts = gameEditions.registeredPartsByID
	
	for key, id in ipairs(data.content) do
		self.content[key] = parts[id]
		self.contentMap[id] = true
	end
	
	self:fullRecalculate()
	self:updateIcon()
end

local basePartFuncs = {}

basePartFuncs.mtindex = {
	__index = basePartFuncs
}

function basePartFuncs:getName()
	return self.display
end

function basePartFuncs:getValue()
	return self.value
end

function basePartFuncs:getProduceCost()
	return self.produceCost
end

function basePartFuncs:getGenreUIIconConfig(backdropW, backdropH, iconSize)
	local w, h = quadLoader:getQuad(self.icon):getQuadDimensions(iconSize)
	
	return {
		{
			icon = "profession_backdrop",
			width = backdropW,
			height = backdropH
		},
		{
			icon = self.icon,
			width = w,
			height = h,
			x = backdropW * 0.5 - w * 0.5,
			y = backdropH * 0.5 - iconSize * 0.5
		}
	}
end

function basePartFuncs:getDesire(genreID)
	local desire = self.desireByGenre[genreID]
	
	if desire then
		return desire
	end
	
	return self.fallbackDesire
end

function basePartFuncs:fillDescbox(descbox, gameProj)
	descbox:addText(_T("GAME_EDITION_PART_GENRE_MATCH", "Genre matches:"), "bh20", textColor, 4, 250)
	
	local partID = self.id
	
	for key, data in ipairs(genres.registered) do
		if studio:isEditionMatchRevealed(partID, data.id) then
			local signs, textColor = self:getSignAndColor(data.id)
			
			descbox:addText(_format("SIGNS GENRE", "SIGNS", signs, "GENRE", data.display), "bh20", textColor, 0, 250, genres:getGenreUIIconConfig(data, 24, 24, 22))
		else
			descbox:addText(_format("GENRE ???", "GENRE", data.display), "bh20", game.UI_COLORS.GREY, 0, 250, genres:getGenreUIIconConfig(data, 24, 24, 22))
		end
	end
end

function editionClass:fillGameProjectDescbox(element, gameProj, wrapW)
	local hoverText = {}
	local parts = self.content
	local wrapW = 230
	
	if self.freeBuffer > 0 then
		table.insert(hoverText, {
			font = "bh20",
			iconHeight = 22,
			icon = "question_mark",
			iconWidth = 22,
			lineSpace = 4,
			text = _format(_T("GAME_EDITION_BUFFER_AVAILABLE", "You have REMAINING units of this edition in stock, and no manufacturing costs will be applied to these editions until they're sold off."), "REMAINING", string.comma(self.freeBuffer)),
			textColor = game.UI_COLORS.LIGHT_BLUE,
			wrapWidth = wrapW
		})
	end
	
	if #parts > 0 then
		table.insert(hoverText, {
			font = "bh20",
			lineSpace = 4,
			text = _T("GAME_EDITION_CONTENTS", "Contents:")
		})
		
		local genre = gameProj:getGenre()
		
		for key, part in ipairs(parts) do
			local signs, textColor
			
			if studio:isEditionMatchRevealed(part.id, genre) then
				signs, textColor = part:getSignAndColor(genre)
			else
				signs, textColor = "???", game.UI_COLORS.GREY
			end
			
			table.insert(hoverText, {
				font = "bh20",
				iconWidth = 24,
				iconHeight = 24,
				text = _format("PART - SIGNS", "PART", part:getName(), "SIGNS", signs),
				textColor = textColor,
				lineSpace = key == partCount and 0 or 4,
				wrapWidth = wrapW,
				icon = part.icon
			})
		end
	else
		table.insert(hoverText, {
			font = "bh20",
			iconHeight = 22,
			icon = "question_mark",
			iconWidth = 22,
			text = _T("GAME_EDITION_CONTENTS_NOTHING", "This game edition has nothing bundled with it."),
			wrapWidth = wrapW
		})
	end
	
	if #hoverText > 0 then
		element:setHoverText(hoverText)
	end
end

function basePartFuncs:getSignAndColor(genreID)
	return game.getContributionSign(1, 1 + self:getDesire(genreID), 0.05, 3, nil, nil, nil)
end

function gameEditions:registerBase(data)
	table.insert(self.registeredBase, data)
	
	self.registeredBaseByID[data.id] = data
	
	local partMap = self.registeredPartsByID
	
	if data.partIDs then
		data.parts = {}
		
		for key, id in ipairs(data.partIDs) do
			data.parts[#data.parts + 1] = partMap[id]
		end
	end
end

function gameEditions:registerPart(data)
	table.insert(self.registeredParts, data)
	
	self.registeredPartsByID[data.id] = data
	
	if not data.fallbackDesire then
		data.fallbackDesire = gameEditions.DEFAULT_DESIRE
	end
	
	self.maxValue = self.maxValue + data.value - data.produceCost
	
	setmetatable(data, basePartFuncs.mtindex)
end

function gameEditions:instantiate(gameProj, id)
	local new = {}
	
	setmetatable(new, editionClass.mtindex)
	new:init()
	new:setProject(gameProj)
	
	if id then
		local data = self.registeredBaseByID[id]
		
		for key, partData in ipairs(data.parts) do
			new:addPart(partData, true)
		end
		
		new:setName(data.display)
		new:setPrice((gameProj:getPrice() or 0) + data.markup)
		new:updateVariables()
	end
	
	return new
end

function gameEditions:getPartData(id)
	return self.registeredPartsByID[id]
end

function gameEditions:calculateUpFrontCost(gameProj)
	local total = 0
	
	for key, edit in ipairs(gameProj:getEditions()) do
		total = total + edit:getUpFrontCost()
	end
	
	return total
end

function gameEditions:pickEditionCallback()
	local proj = self.tree.project
	local edition = gameEditions:instantiate(proj, self.id)
	
	proj:addEdition(edition)
end

function gameEditions:fillWithEditionOptions(comboBox)
	for key, edit in ipairs(self.registeredBase) do
		local option = comboBox:addOption(0, 0, 0, 24, edit.display, fonts.get("pix20"), gameEditions.pickEditionCallback)
		
		option.id = edit.id
	end
end

gameEditions.PART_INFO_DESCBOX_ID = "game_edition_part_info_descbox"
gameEditions.EDITION_NAMING_DESCBOX_ID = "game_edition_name_textbox"

function gameEditions:createMenu(gameProj)
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setTitle(_T("GAME_EDITIONS_TITLE", "Game Editions"))
	frame:setSize(600, 500)
	
	local scroller = gui.create("GameEditionScroller", frame)
	
	scroller:setPos(_S(5), _S(30))
	scroller:setSize(270, frame.rawH - 105)
	scroller:setAdjustElementPosition(true)
	scroller:setAdjustElementSize(true)
	scroller:setSpacing(3)
	scroller:setPadding(3, 3)
	scroller:createGameEditions(gameProj)
	scroller:addDepth(100)
	
	local basicElemWidth = scroller.rawW - 26 - 5
	local newButton = gui.create("AddNewGameEditionButton", frame)
	
	newButton:setSize(basicElemWidth, 26)
	newButton:setFont("bh24")
	newButton:setText(_T("ADD_NEW", "Add new..."))
	newButton:setProject(gameProj)
	newButton:setPos(_S(5), frame.h - newButton.h - _S(5))
	
	local costDisplay = gui.create("EditionCostDisplay", frame)
	
	costDisplay:setSize(basicElemWidth, 30)
	costDisplay:setPos(newButton.localX, newButton.localY - costDisplay.h - _S(5))
	costDisplay:setFont("bh24")
	costDisplay:setCost(self:calculateUpFrontCost(gameProj))
	
	local removeAll = gui.create("RemoveAllEditionsButton", frame)
	
	removeAll:setSize(26, 26)
	removeAll:setPos(newButton.localX + _S(5) + newButton.w, newButton.localY)
	removeAll:setProject(gameProj)
	
	local nameBox = gui.create("GameEditionNameTextbox", frame)
	
	nameBox:setPos(scroller.localX + scroller.w + _S(5), scroller.y)
	nameBox:setSize(frame.rawW - _US(nameBox.x) - 100, 26)
	nameBox:setFont("bh24")
	nameBox:setAutoAdjustFonts(fonts.BOLD_AUTO_ADJUST_FONTS)
	nameBox:setID(gameEditions.EDITION_NAMING_DESCBOX_ID)
	nameBox:setCanClick(false)
	
	local priceBox = gui.create("GameEditionPriceTextbox", frame)
	
	priceBox:setPos(nameBox.localX + nameBox.w + _S(5), nameBox.y)
	priceBox:setSize(frame.rawW - _US(priceBox.x) - 5, nameBox.rawH)
	priceBox:setFont("bh24")
	priceBox:setMaxValue(gameEditions.MAX_PRICE)
	priceBox:setAutoAdjustFonts(fonts.BOLD_AUTO_ADJUST_FONTS)
	priceBox:setCanClick(false)
	
	local setupScroller = gui.create("EditionSetupScroller", frame)
	
	setupScroller:setPos(nameBox.localX, nameBox.localY + nameBox.h + _S(5))
	setupScroller:setSize(frame.rawW - _US(setupScroller.x) - 5, frame.rawH - _US(setupScroller.y) - 5)
	setupScroller:setAdjustElementPosition(true)
	setupScroller:setAdjustElementSize(true)
	setupScroller:setSpacing(3)
	setupScroller:setPadding(3, 3)
	setupScroller:addDepth(200)
	scroller:setSetupScroller(setupScroller)
	frame:center()
	
	local partInfoDescbox = gui.create("GenericDescbox")
	
	partInfoDescbox:setPos(frame.x + frame.w + _S(5), frame.y)
	partInfoDescbox:tieVisibilityTo(frame)
	partInfoDescbox:setID(gameEditions.PART_INFO_DESCBOX_ID)
	partInfoDescbox:setFadeInSpeed(0)
	partInfoDescbox:hide()
	partInfoDescbox:overwriteDepth(1000)
	frameController:push(frame)
	events:fire(gameEditions.EVENTS.MENU_OPENED, gameProj)
end

gameEditions.DESIRE_LOW = 0.05
gameEditions.DESIRE_MODERATE = 0.1
gameEditions.DESIRE_HIGH = 0.15

gameEditions:registerPart({
	value = 10,
	produceCost = 3,
	id = "tshirt",
	icon = "gec_tshirt",
	display = _T("GAME_EDITION_PART_TSHIRT", "T-shirt"),
	displaySingular = _T("GAME_EDITION_PART_TSHIRT_SINGULAR", "a t-shirt"),
	desireByGenre = {
		action = gameEditions.DESIRE_LOW,
		adventure = gameEditions.DESIRE_LOW,
		horror = gameEditions.DESIRE_LOW,
		simulation = gameEditions.DESIRE_LOW,
		fighting = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_LOW,
		rpg = gameEditions.DESIRE_LOW,
		sandbox = gameEditions.DESIRE_LOW,
		racing = gameEditions.DESIRE_LOW
	}
})
gameEditions:registerPart({
	value = 8,
	produceCost = 2.5,
	id = "making_of",
	icon = "gec_making_of",
	display = _T("GAME_EDITION_PART_MAKING_OF", "'Making of' CD"),
	displaySingular = _T("GAME_EDITION_PART_MAKING_OF_SINGULAR", "a 'Making of' CD"),
	desireByGenre = {
		action = gameEditions.DESIRE_LOW,
		adventure = gameEditions.DESIRE_MODERATE,
		horror = gameEditions.DESIRE_MODERATE,
		simulation = gameEditions.DESIRE_MODERATE,
		fighting = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_MODERATE,
		rpg = gameEditions.DESIRE_HIGH,
		sandbox = gameEditions.DESIRE_MODERATE,
		racing = gameEditions.DESIRE_MODERATE
	}
})
gameEditions:registerPart({
	value = 20,
	produceCost = 5,
	id = "world_map",
	icon = "gec_world_map",
	display = _T("GAME_EDITION_PART_WORLD_MAP", "Game world map"),
	displaySingular = _T("GAME_EDITION_PART_WORLD_MAP_SINGULAR", "a game world map"),
	desireByGenre = {
		fighting = 0,
		racing = 0,
		action = 0,
		sandbox = 0,
		adventure = gameEditions.DESIRE_MODERATE,
		horror = gameEditions.DESIRE_LOW,
		simulation = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_HIGH,
		rpg = gameEditions.DESIRE_HIGH
	}
})
gameEditions:registerPart({
	value = 50,
	produceCost = 15,
	id = "amulet",
	icon = "gec_amulet",
	display = _T("GAME_EDITION_PART_AMULET", "Amulet"),
	displaySingular = _T("GAME_EDITION_PART_AMULET_SINGULAR", "an amulet"),
	desireByGenre = {
		racing = 0,
		sandbox = 0,
		strategy = 0,
		simulation = 0,
		action = gameEditions.DESIRE_MODERATE,
		adventure = gameEditions.DESIRE_MODERATE,
		horror = gameEditions.DESIRE_LOW,
		fighting = gameEditions.DESIRE_LOW,
		rpg = gameEditions.DESIRE_MODERATE
	}
})
gameEditions:registerPart({
	value = 15,
	produceCost = 6,
	id = "trinkets",
	icon = "gec_trinkets",
	display = _T("GAME_EDITION_PART_TRINKETS", "Trinkets"),
	displaySingular = _T("GAME_EDITION_PART_TRINKETS_SINGULAR", "trinkets"),
	desireByGenre = {
		action = gameEditions.DESIRE_LOW,
		adventure = gameEditions.DESIRE_LOW,
		horror = gameEditions.DESIRE_LOW,
		simulation = gameEditions.DESIRE_LOW,
		fighting = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_LOW,
		rpg = gameEditions.DESIRE_LOW,
		sandbox = gameEditions.DESIRE_LOW,
		racing = gameEditions.DESIRE_LOW
	}
})
gameEditions:registerPart({
	value = 10,
	produceCost = 3,
	id = "stickers",
	icon = "gec_stickers",
	display = _T("GAME_EDITION_PART_STICKERS", "Stickers"),
	displaySingular = _T("GAME_EDITION_PART_STICKERS_SINGULAR", "stickers"),
	desireByGenre = {
		fighting = 0,
		sandbox = 0,
		simulation = 0,
		action = gameEditions.DESIRE_MODERATE,
		adventure = gameEditions.DESIRE_LOW,
		horror = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_MODERATE,
		rpg = gameEditions.DESIRE_LOW,
		racing = gameEditions.DESIRE_HIGH
	}
})
gameEditions:registerPart({
	value = 10,
	produceCost = 3,
	id = "manual",
	icon = "gec_manual",
	display = _T("GAME_EDITION_PART_GAME_MANUAL", "Game manual"),
	displaySingular = _T("GAME_EDITION_PART_GAME_MANUAL_SINGULAR", "a game manual"),
	desireByGenre = {
		action = gameEditions.DESIRE_LOW,
		adventure = gameEditions.DESIRE_LOW,
		horror = gameEditions.DESIRE_LOW,
		simulation = gameEditions.DESIRE_MODERATE,
		fighting = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_MODERATE,
		rpg = gameEditions.DESIRE_LOW,
		sandbox = gameEditions.DESIRE_MODERATE,
		racing = gameEditions.DESIRE_LOW
	}
})
gameEditions:registerPart({
	value = 10,
	produceCost = 3,
	id = "artbook",
	icon = "gec_artbook",
	display = _T("GAME_EDITION_PART_ARTBOOK", "Artbook"),
	displaySingular = _T("GAME_EDITION_PART_ARTBOOK_SINGULAR", "an artbook"),
	desireByGenre = {
		sandbox = 0,
		simulation = 0,
		action = gameEditions.DESIRE_LOW,
		adventure = gameEditions.DESIRE_LOW,
		horror = gameEditions.DESIRE_HIGH,
		fighting = gameEditions.DESIRE_MODERATE,
		strategy = gameEditions.DESIRE_MODERATE,
		rpg = gameEditions.DESIRE_MODERATE,
		racing = gameEditions.DESIRE_LOW
	}
})
gameEditions:registerPart({
	value = 15,
	produceCost = 6,
	id = "item_replica",
	icon = "gec_replica",
	display = _T("GAME_EDITION_PART_ITEM_REPLICA", "Item replica"),
	displaySingular = _T("GAME_EDITION_PART_ITEM_REPLICA_SINGULAR", "an item replica"),
	desireByGenre = {
		action = gameEditions.DESIRE_MODERATE,
		adventure = gameEditions.DESIRE_MODERATE,
		horror = gameEditions.DESIRE_MODERATE,
		simulation = gameEditions.DESIRE_LOW,
		fighting = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_LOW,
		rpg = gameEditions.DESIRE_MODERATE,
		sandbox = gameEditions.DESIRE_LOW,
		racing = gameEditions.DESIRE_LOW
	}
})
gameEditions:registerPart({
	value = 30,
	produceCost = 15,
	id = "statue",
	icon = "gec_bust",
	display = _T("GAME_EDITION_PART_PROTAGONIST_BUST", "Protagonist bust"),
	displaySingular = _T("GAME_EDITION_PART_PROTAGONIST_BUST_SINGULAR", "a bust of the protagonist"),
	desireByGenre = {
		action = gameEditions.DESIRE_LOW,
		adventure = gameEditions.DESIRE_LOW,
		horror = gameEditions.DESIRE_LOW,
		simulation = gameEditions.DESIRE_LOW,
		fighting = gameEditions.DESIRE_LOW,
		strategy = gameEditions.DESIRE_LOW,
		rpg = gameEditions.DESIRE_LOW,
		sandbox = gameEditions.DESIRE_LOW,
		racing = gameEditions.DESIRE_LOW
	}
})
gameEditions:registerBase({
	markup = 0,
	id = gameEditions.DEFAULT_EDITION,
	display = _T("GAME_EDITION_REGULAR", "Regular edition"),
	partIDs = {}
})
gameEditions:registerBase({
	id = "special",
	markup = 10,
	display = _T("GAME_EDITION_SPECIAL", "Special edition"),
	partIDs = {
		"tshirt",
		"making_of"
	}
})
gameEditions:registerBase({
	id = "deluxe",
	markup = 20,
	display = _T("GAME_EDITION_DELUXE", "Deluxe edition"),
	partIDs = {
		"tshirt",
		"making_of",
		"manual",
		"stickers"
	}
})
gameEditions:registerBase({
	id = "super",
	markup = 40,
	display = _T("GAME_EDITION_SUPER", "Super edition"),
	partIDs = {
		"tshirt",
		"making_of",
		"manual",
		"stickers",
		"artbook",
		"world_map",
		"trinkets"
	}
})
gameEditions:registerBase({
	id = "collectors",
	markup = 70,
	display = _T("GAME_EDITION_COLLECTORS", "Collectors edition"),
	partIDs = {
		"tshirt",
		"making_of",
		"manual",
		"stickers",
		"artbook",
		"world_map",
		"trinkets",
		"amulet",
		"statue",
		"item_replica"
	}
})
