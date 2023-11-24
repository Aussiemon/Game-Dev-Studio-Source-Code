local bribeRefused = {}

bribeRefused.id = "bribe_refused_reaction_convo"
bribeRefused.displayText = {
	_T("BRIBE_REFUSE_REACTION_1", "I'm starting to doubt it was a good idea to offer a bribe to those reviewers."),
	_T("BRIBE_REFUSE_REACTION_2", "That bribe offer, the one that got refused, it's going to bite us in the ass later on, right?")
}

function bribeRefused:begin(convoObj)
	bribeRefused.baseClass.begin(self, convoObj)
	conversations:removeTopicToTalkAbout(reviewer.REFUSED_FACT_CONVERSATION_TOPIC)
end

function bribeRefused:isTopicValid(target)
	return conversations:canTalkAboutTopic(reviewer.REFUSED_FACT_CONVERSATION_TOPIC)
end

conversations:registerTopic(bribeRefused)

local bribeRefusedAnswer = {}

bribeRefusedAnswer.id = "bribe_refused_reaction_answer"
bribeRefusedAnswer.displayText = {
	_T("BRIBE_REFUSE_REACTION_ANSWER_1", "Lets hope they don't ruin our reputation"),
	_T("BRIBE_REFUSE_REACTION_ANSWER_2", "Fingers crossed they don't reveal that.")
}
bribeRefusedAnswer.topicID = "bribe_refused_reaction_convo"

conversations:registerAnswer(bribeRefusedAnswer)
