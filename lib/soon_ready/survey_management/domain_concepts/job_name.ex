defmodule SoonReady.SurveyManagement.DomainConcepts.JobName do
  # TODO: Change to add constraints to ensure that the value matches the expected format
  use Ash.Type.NewType, subtype_of: :string
end
