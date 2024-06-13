# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.Response do
#   alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.{
#     ShortAnswerQuestionResponse,
#     MultipleChoiceQuestionResponse,
#     ParagraphQuestionResponse,
#     MultipleChoiceQuestionGroupResponse,
#   }

#   use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
#     {ShortAnswerQuestionResponse, [type: ShortAnswerQuestionResponse, tag: :type, tag_value: "short_answer_question_response"]},
#     {MultipleChoiceQuestionResponse, [type: MultipleChoiceQuestionResponse, tag: :type, tag_value: "multiple_choice_question_response"]},
#     {ParagraphQuestionResponse, [type: ParagraphQuestionResponse, tag: :type, tag_value: "paragraph_question_response"]},
#     {MultipleChoiceQuestionGroupResponse, [type: MultipleChoiceQuestionGroupResponse, tag: :type, tag_value: "multiple_choice_question_group_response"]},
#   ]]
# end
