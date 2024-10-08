defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm.Response do
  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm.{
    ShortAnswerQuestionResponse,
    MultipleChoiceQuestionResponse,
    CheckboxQuestionResponse,
    ParagraphQuestionResponse,
    ShortAnswerQuestionGroupResponse,
    MultipleChoiceQuestionGroupResponse,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {ShortAnswerQuestionResponse, [type: ShortAnswerQuestionResponse, tag: :type, tag_value: "short_answer_question_response"]},
    {MultipleChoiceQuestionResponse, [type: MultipleChoiceQuestionResponse, tag: :type, tag_value: "multiple_choice_question_response"]},
    {CheckboxQuestionResponse, [type: CheckboxQuestionResponse, tag: :type, tag_value: "checkbox_question_response"]},
    {ParagraphQuestionResponse, [type: ParagraphQuestionResponse, tag: :type, tag_value: "paragraph_question_response"]},
    {ShortAnswerQuestionGroupResponse, [type: ShortAnswerQuestionGroupResponse, tag: :type, tag_value: "short_answer_question_group_response"]},
    {MultipleChoiceQuestionGroupResponse, [type: MultipleChoiceQuestionGroupResponse, tag: :type, tag_value: "multiple_choice_question_group_response"]},
  ]]
end
