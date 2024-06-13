# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.PromptResponse do
#   use Ash.Resource, data_layer: :embedded

#   alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.{Prompt, QuestionResponse}

#   attributes do
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :prompt, :string, allow_nil?: false
#     attribute :question_responses, {:array, QuestionResponse}, allow_nil?: false
#   end

#   actions do
#     defaults [:create, :read, :update, :destroy]
#   end

#   code_interface do
#     define_for SoonReadyInterface.Respondents.Setup.Api

#     define :create
#   end
# end
