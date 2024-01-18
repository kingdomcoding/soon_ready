defmodule SoonReady.QuantifyNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyNeeds.SurveyResponse.ValueObjects.{Response, JobStep}

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :survey_id, :uuid
    attribute :hashed_participant, :string
    attribute :screening_responses, {:array, Response}
    attribute :demographic_responses, {:array, Response}
    attribute :context_responses, {:array, Response}
    attribute :comparison_responses, {:array, Response}
    attribute :desired_outcome_ratings, {:array, JobStep}
    attribute :event_version, :integer, allow_nil?: false, default: 1
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.SurveyResponse.Api
    define :new
  end
end
