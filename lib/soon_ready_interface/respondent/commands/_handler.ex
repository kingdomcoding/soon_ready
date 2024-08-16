defmodule SoonReadyInterface.Respondent.Commands.Handler do
  use Ash.Resource, domain: SoonReadyInterface.Respondent
  use Commanded.Commands.Router

  alias SoonReady.SurveyManagement.V1.DomainEvents
  alias SoonReady.SurveyManagement.V1.IntegrationEvents

  alias SoonReady.SurveyManagement.V1.DomainEvents.SurveyCreated

  alias SoonReadyInterface.Respondent.Commands.SubmitSurveyResponse
  alias SoonReady.SurveyManagement.V1.DomainEvents.SurveyResponseSubmitted

  alias SoonReady.SurveyManagement.V1.DomainConcepts.{SurveyPage, Trigger}

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :starting_page_id, :uuid, allow_nil?: false, public?: true
    attribute :pages, {:array, SurveyPage}, public?: true
    attribute :trigger, Trigger
  end

  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      :pages,
      :trigger,
    ]
    defaults [:create, :read, :update]
  end

  code_interface do
    define :create
    define :update
  end

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id, raw_responses_data: raw_responses_data} = command) do
    SurveyResponseSubmitted.new(%{
      response_id: response_id,
      survey_id: survey_id,
      responses: raw_responses_data,
    })
  end

  def apply(state, %SurveyCreated{survey_id: survey_id, starting_page_id: starting_page_id, pages: pages, trigger: trigger}) do
    __MODULE__.create!(%{survey_id: survey_id, starting_page_id: starting_page_id, pages: pages, trigger: trigger})
  end

  def apply(state, _event) do
    state
  end
end