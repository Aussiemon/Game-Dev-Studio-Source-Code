local testConvo = {}

testConvo.id = "new_tech_convo"
testConvo.displayText = "hey have you heard about a new lighting technique called global illumination?"

conversations:registerTopic(testConvo)

local testAnswer = {}

testAnswer.id = "test_convo_answer1a"
testAnswer.displayText = "yeah it looks awesome can't wait to implement it"
testAnswer.topicID = "new_tech_convo"
testAnswer.nextAnswer = "test_convo_answer2a"

function testAnswer:getWeight()
	if timeline:getYear() < 1981 then
		return 0
	end
	
	return 5
end

conversations:registerAnswer(testAnswer)

local testAnswer = {}

testAnswer.id = "test_convo_answer1b"
testAnswer.displayText = "it's good stuff but the hardware is not there yet for it"
testAnswer.topicID = "new_tech_convo"
testAnswer.nextAnswer = "test_convo_answer2b"

function testAnswer:getWeight()
	if timeline:getYear() < 1981 then
		return 5
	end
	
	return 0
end

conversations:registerAnswer(testAnswer)

local testAnswer = {}

testAnswer.id = "test_convo_answer2a"
testAnswer.displayText = "yeah dude I love video games"

conversations:registerAnswer(testAnswer)

local testAnswer = {}

testAnswer.id = "test_convo_answer2b"
testAnswer.displayText = "ah you're right"

conversations:registerAnswer(testAnswer)
