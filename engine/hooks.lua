hook = {}
registered.hooks = {}

function hook.add(hookCat, hookName, hookFunc)
	if not registered.hooks[hookCat] then
		registered.hooks[hookCat] = {}
	end
	
	table.insert(registered.hooks[hookCat], {
		hookName = hookName,
		hookFunc = hookFunc
	})
end

function hook.remove(hookCat, hookName)
	if registered.hooks[hookCat] and registered.hooks[hookCat][hookName] then
		registered.hooks.hookCat[hookName] = nil
	end
end

function hook.getInCategory(hookCat)
	return registered.hooks[hookCat]
end

function hook.getAll()
	return registered.hooks
end

local a, b, c, d, e, f, g

function hook.callByName(hookCat, hookName, ...)
	if not hookCat or not hookName then
		return 
	end
	
	if not registered.hooks[hookCat] then
		return ...
	end
	
	a, b, c, d, e, f, g = nil
	
	for k, v in pairs(registered.hooks[hookCat]) do
		if v.hookName == hookName then
			a, b, c, d, e, f, g = v.hookFunc(...)
		end
	end
	
	return a, b, c, d, e, f, g
end

function hook.call(hookCat, ...)
	if not hookCat then
		return 
	end
	
	if not registered.hooks[hookCat] then
		return ...
	end
	
	a, b, c, d, e, f, g = nil
	
	for k, v in pairs(registered.hooks[hookCat]) do
		a, b, c, d, e, f, g = v.hookFunc(...)
	end
	
	return a, b, c, d, e, f, g
end
