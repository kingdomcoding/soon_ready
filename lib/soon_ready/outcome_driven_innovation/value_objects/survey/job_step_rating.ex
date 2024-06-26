defmodule SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.JobStepRating do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.DesiredOutcomeRating

  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcomeRating}, allow_nil?: false, constraints: [min_length: 1]
  end
end
