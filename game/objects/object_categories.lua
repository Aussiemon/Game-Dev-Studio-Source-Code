objectCategories = {}
objectCategories.registered = {}
objectCategories.allCategories = {}

function objectCategories:registerNew(data)
	data.objects = {}
	data.icon = data.icon or "development_tab_icon"
	objectCategories.registered[data.id] = data
	
	table.insert(objectCategories.allCategories, data)
end

function objectCategories:addToCategory(category, object)
	if type(category) == "string" then
		table.insert(objectCategories.registered[category].objects, object)
	elseif type(category) == "table" then
		for key, categoryID in ipairs(category) do
			table.insert(objectCategories.registered[categoryID].objects, object)
		end
	else
		error("attempt to register invalid object category type: " .. type(category) .. ", valid only string or table with string category names")
	end
end

function objectCategories:getCategory(category)
	return objectCategories.registered[category]
end

function objectCategories:getCategoryContents(category)
	return objectCategories.registered[category].objects
end

objectCategories:registerNew({
	id = "general",
	icon = "new_tab_general",
	iconActive = "new_tab_general_hover",
	display = _T("OBJECT_CATEGORY_GENERAL", "General")
})
objectCategories:registerNew({
	id = "sanitary",
	icon = "new_tab_sanitary",
	iconActive = "new_tab_sanitary_hover",
	display = _T("OBJECT_CATEGORY_SANITARY", "Sanitary")
})
objectCategories:registerNew({
	id = "office",
	icon = "new_tab_office",
	iconActive = "new_tab_office_hover",
	display = _T("OBJECT_CATEGORY_OFFICE", "Office")
})
objectCategories:registerNew({
	id = "food",
	icon = "new_tab_food",
	iconActive = "new_tab_food_hover",
	display = _T("OBJECT_CATEGORY_FOOD", "Food")
})
objectCategories:registerNew({
	id = "leisure",
	icon = "new_tab_leisure",
	iconActive = "new_tab_leisure_hover",
	display = _T("OBJECT_CATEGORY_LEISURE", "Leisure")
})
