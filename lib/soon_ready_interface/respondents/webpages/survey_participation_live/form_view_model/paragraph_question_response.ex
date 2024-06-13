# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.ParagraphQuestionResponse do
#   use Ash.Resource, data_layer: :embedded

#   attributes do
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :prompt, :string, allow_nil?: false
#     # TODO: nil is always allowed. Resolve.
#     attribute :response, :string, allow_nil?: true
#   end

#   actions do
#     defaults [:read, :update, :destroy]

#     create :create do
#       primary? true
#       allow_nil_input [:response]
#     end
#   end

#   code_interface do
#     define_for SoonReadyInterface.Respondents.Setup.Api

#     define :create
#   end
# end
