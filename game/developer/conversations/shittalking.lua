local shittalking = {}

shittalking.id = "shittalking_convo"
shittalking.displayText = {
	_T("SHITTALKING_CONVO_1", "What is our boss even doing? We've started so many games, but finished so little."),
	_T("SHITTALKING_CONVO_2", "I wonder what's our boss thinking? It's like we're prototyping all the time, but nothing happens."),
	_T("SHITTALKING_CONVO_3", "When will our boss stop scrapping so many games? I'm faily sure we had at least one good game in the works.")
}
shittalking.MINIMUM_GAMES = 5
shittalking.RELEASED_TO_STARTED_GAMES_RATIO = 0.33

function shittalking:isTopicValid(target)
	if target:isPlayerCharacter() then
		return false
	end
	
	local startedGames = studio:getFact(gameProject.STARTED_GAMES_FACT) or 0
	
	if startedGames < shittalking.MINIMUM_GAMES then
		return false
	end
	
	local releasedGames = studio:getFact(gameProject.FINISHED_GAMES_FACT) or 0
	
	return releasedGames / startedGames <= shittalking.RELEASED_TO_STARTED_GAMES_RATIO
end

conversations:registerTopic(shittalking)

local shittalkingAnswer = {}

shittalkingAnswer.id = "shittalking_answer"
shittalkingAnswer.displayText = {
	_T("SHITTALKING_CONVO_ANSWER_1", "I think our boss doesn't have a clue as to what he's doing."),
	_T("SHITTALKING_CONVO_ANSWER_2", "I'm starting to think our boss is more of a businessman rather than a gamer."),
	_T("SHITTALKING_CONVO_ANSWER_3", "I'm beginning to doubt the fact that our boss plays games.")
}
shittalkingAnswer.topicID = "shittalking_convo"

conversations:registerAnswer(shittalkingAnswer)
