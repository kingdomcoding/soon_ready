# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.QuestionResponse do
#   use Ash.Resource, data_layer: :embedded

#   alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.Question

#   attributes do
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :prompt, :string, allow_nil?: false
#     attribute :options, {:array, :string}, allow_nil?: false
#     # attribute :question, Question, allow_nil?: false
#     # TODO: Nilable?
#     attribute :response, :string
#   end

#   actions do
#     defaults [:create, :read, :update, :destroy]
#   end

#   code_interface do
#     define_for SoonReadyInterface.Respondents.Setup.Api

#     define :create
#   end
# end
