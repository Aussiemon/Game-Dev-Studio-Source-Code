factValidity = {}

function factValidity:validateEmployee(employee)
	for key, data in ipairs(randomEvents.registered) do
		if data.validateFact then
			data:validateFact(employee)
		end
	end
end
