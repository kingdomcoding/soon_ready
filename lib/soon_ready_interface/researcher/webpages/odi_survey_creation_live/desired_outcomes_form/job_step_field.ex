# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm.JobStepField do
#   use Ash.Resource, data_layer: :embedded

#   alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.JobStatement
#   alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm.DesiredOutcomeField

#   attributes do
#     attribute :name, JobStatement, allow_nil?: false
#     attribute :desired_outcomes, {:array, DesiredOutcomeField}, allow_nil?: false, constraints: [min_length: 1]
#   end
# end
