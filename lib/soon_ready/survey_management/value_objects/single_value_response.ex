defmodule SoonReady.SurveyManagement.ValueObjects.SingleValueResponse do
  # TODO: :prompt vs :label
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :question_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :response, :ci_string, allow_nil?: false
  end
end
