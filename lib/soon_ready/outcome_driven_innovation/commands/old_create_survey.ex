# defmodule SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey do
#   use Ash.Resource,
#     data_layer: :embedded

#   alias SoonReady.Application
#   alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
#     Market,
#     JobStep,
#   }
#   alias SoonReady.SurveyManagement.DomainConcepts.Question

#   attributes do
#     uuid_primary_key :project_id
#     attribute :survey_id, :uuid, allow_nil?: false, default: &Ash.UUID.generate/0
#     attribute :brand, :string
#     attribute :market, Market
#     attribute :job_steps, {:array, JobStep}
#     attribute :screening_questions, {:array, Question}
#     attribute :demographic_questions, {:array, Question}
#     attribute :context_questions, {:array, Question}
#   end

#   actions do
#     defaults [:create, :read]

#     create :dispatch do
#       change fn changeset, context ->
#         Ash.Changeset.after_action(changeset, fn changeset, command ->
#           with :ok <- Application.dispatch(command) do
#             {:ok, command}
#           end
#         end)
#       end
#     end
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :dispatch
#     define :create
#   end
# end
