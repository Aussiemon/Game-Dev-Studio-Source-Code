events = {}
events.receivers = {}
events.directReceivers = {}
events.functionReceivers = {}
events.counter = 0

function events:new()
	local event = self.counter
	
	self.counter = event + 1
	
	return event
end

function events:addReceiver(obj)
	if table.find(self.receivers, obj) then
		return 
	end
	
	obj._REH = false
	
	table.insert(self.receivers, obj)
end

local count = {}

function events:addDirectReceiver(obj, eventList, handlerName)
	obj._REH = false
	handlerName = handlerName or "handleEvent"
	
	for key, eventName in ipairs(eventList) do
		count[eventName] = (count[eventName] or 0) + 1
		self.directReceivers[eventName] = self.directReceivers[eventName] or {}
		
		local list = self.directReceivers[eventName]
		local method = obj[handlerName]
		local valid = true
		
		for key, data in ipairs(list) do
			if data.obj == obj and data.method == method then
				valid = false
				
				break
			end
		end
		
		if valid then
			table.insert(self.directReceivers[eventName], {
				obj = obj,
				method = method
			})
		end
	end
end

events.addListener = events.addReceiver
events.addHandler = events.addReceiver

function events:removeReceiver(obj)
	table.removeObject(self.receivers, obj)
	
	obj._REH = true
end

function events:removeAllReceivers()
	table.clearArray(self.receivers)
	table.clear(self.directReceivers)
	table.clear(self.functionReceivers)
end

function events:countReceivers()
	local dir = 0
	
	for eventName, list in pairs(self.directReceivers) do
		dir = dir + #list
	end
	
	local func = 0
	
	for eventName, list in pairs(self.functionReceivers) do
		func = func + #list
	end
	
	print(#self.receivers, dir, func)
end

function events:addFunctionReceiver(obj, func, event)
	local receivers = self.functionReceivers[event]
	
	if receivers then
		for key, data in ipairs(receivers) do
			if data.obj == obj then
				return 
			end
		end
	else
		self.functionReceivers[event] = {}
	end
	
	obj._REH = false
	
	table.insert(self.functionReceivers[event], {
		obj = obj,
		func = func
	})
end

function events:removeFunctionReceiver(obj, event)
	local receivers = self.functionReceivers[event]
	
	if receivers then
		for key, data in ipairs(receivers) do
			if data.obj == obj then
				table.remove(receivers, key)
			end
		end
	end
	
	obj._REH = true
end

function events:removeDirectReceiver(obj, eventList, handlerName)
	handlerName = handlerName or "handleEvent"
	
	for key, eventName in ipairs(eventList) do
		local list = self.directReceivers[eventName]
		
		if list then
			local removes = 0
			
			for listKey, data in ipairs(list) do
				if data.obj == obj and data.method == obj[handlerName] then
					table.remove(list, listKey)
					
					removes = removes + 1
					
					break
				end
			end
		end
	end
	
	obj._REH = true
end

events.removeListener = events.removeReceiver
events.removeHandler = events.removeReceiver

function events:send(eventName, ...)
	local index = 1
	local start = #self.receivers
	
	for i = 1, #self.receivers do
		local receiver = self.receivers[index]
		
		if receiver then
			receiver:handleEvent(eventName, ...)
			
			if not receiver._REH then
				index = index + 1
			end
		else
			break
		end
	end
	
	local directReceivers = self.directReceivers[eventName]
	
	if directReceivers then
		local index = 1
		
		for i = 1, #directReceivers do
			local directReceiver = directReceivers[index]
			
			if directReceiver then
				local obj = directReceiver.obj
				
				directReceiver.method(obj, eventName, ...)
				
				if not obj._REH then
					index = index + 1
				end
			else
				break
			end
		end
	end
	
	local funcReceivers = self.functionReceivers[eventName]
	
	if funcReceivers then
		local index = 1
		
		for i = 1, #funcReceivers do
			local data = funcReceivers[index]
			
			if data then
				data.func(data.obj, ...)
				
				if not data.obj._REH then
					index = index + 1
				end
			else
				break
			end
		end
	end
end

events.fire = events.send
