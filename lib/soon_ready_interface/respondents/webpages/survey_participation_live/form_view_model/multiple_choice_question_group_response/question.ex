# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse.Question do
#   use Ash.Resource, data_layer: :embedded

#   attributes do
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :prompt, :string, allow_nil?: false
#     attribute :options, {:array, :string}, allow_nil?: false
#   end

#   actions do
#     defaults [:create, :read, :update, :destroy]
#   end

#   code_interface do
#     define_for SoonReadyInterface.Respondents.Setup.Api

#     define :create
#   end
# end
