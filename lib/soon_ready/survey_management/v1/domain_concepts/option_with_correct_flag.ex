defmodule SoonReady.SurveyManagement.V1.DomainConcepts.OptionWithCorrectFlag do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :value, :ci_string, allow_nil?: false, public?: true
    attribute :correct?, :boolean, allow_nil?: false, public?: true
  end
end
