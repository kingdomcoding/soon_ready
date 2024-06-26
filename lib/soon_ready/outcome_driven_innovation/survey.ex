defmodule SoonReady.OutcomeDrivenInnovation.Survey do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.OutcomeDrivenInnovation.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.OutcomeDrivenInnovation.Events.{SurveyCreatedV1, SurveyPublishedV1}

  alias SoonReady.OutcomeDrivenInnovation.Commands.SubmitSurveyResponse
  alias SoonReady.OutcomeDrivenInnovation.Events.SurveyResponseSubmittedV1
  alias SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey

  resources do
    resource PersonalIdentifiableInformationEncryptionKey
  end

  authorization do
    authorize :by_default
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch PublishSurvey, to: __MODULE__, identity: :survey_id

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  defstruct [:survey_id]

  def create_survey(params, actor \\ nil), do: CreateSurvey.dispatch(params, [actor: actor])
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreatedV1.new(%{
      survey_id: command.survey_id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end

  def execute(_aggregate_state, %PublishSurvey{} = command) do
    SurveyPublishedV1.new(%{
      survey_id: command.survey_id
    })
  end

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id} = command) do
    SurveyResponseSubmittedV1.new(%{
      response_id: command.response_id,
      survey_id: command.survey_id,
      participant: command.participant,
      screening_responses: command.screening_responses,
      demographic_responses: command.demographic_responses,
      context_responses: command.context_responses,
      comparison_responses: command.comparison_responses,
      desired_outcome_ratings: command.desired_outcome_ratings
    })
  end

  def apply(state, _event) do
    state
  end
end
