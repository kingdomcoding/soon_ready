defmodule SoonReady.QuantifyNeeds.SurveyResponse.Commands.SubmitSurveyResponse do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.QuantifyNeeds.SurveyResponse.ValueObjects.{Participant, Response, JobStep}

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :participant, Participant, allow_nil?: false
    attribute :screening_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :demographic_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :context_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :comparison_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :desired_outcome_ratings, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
  end

  actions do
    create :dispatch do
      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.SurveyResponse.Api
    define :dispatch
  end
end