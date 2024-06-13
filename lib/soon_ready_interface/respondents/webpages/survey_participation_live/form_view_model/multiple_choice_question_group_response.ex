# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.MultipleChoiceQuestionGroupResponse do
#   use Ash.Resource, data_layer: :embedded

#   alias __MODULE__.{Prompt, Question, PromptResponse}

#   attributes do
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :title, :string, allow_nil?: false
#     attribute :prompts, {:array, Prompt}, allow_nil?: false
#     attribute :questions, {:array, Question}, allow_nil?: false
#     # TODO: nil is always allowed. Resolve.
#     attribute :prompt_responses, {:array, PromptResponse}, allow_nil?: true
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
