defmodule SoonReady.SurveyManagement.V1.DomainConcepts.ShortAnswerQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :prompt, :ci_string, allow_nil?: false, public?: true
    attribute :required?, :boolean, allow_nil?: false, public?: true, default: true
  end
end
