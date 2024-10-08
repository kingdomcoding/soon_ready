defmodule SoonReadyInterface.Researcher.Commands.Aggregate do
  use Ash.Resource, domain: SoonReadyInterface.Researcher
  use Commanded.Commands.Router

  alias SoonReadyInterface.Researcher.Commands.CreateSurvey
  alias SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.{
    ProjectCreated,
    MarketDefined,
    NeedsDefined,
  }

  alias SoonReady.SurveyManagement.V1.DomainEvents.{SurveyCreated, SurveyPublished}

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.{
    Market,
    JobStep,
  }

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
  end

  actions do
    default_accept [
      :project_id,
      :market,
      :job_steps,
    ]
    defaults [:create, :read, :update]
  end

  code_interface do
    define :create
    define :update
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :project_id

  def execute(aggregate_state, %CreateSurvey{} = command) do
    %{
      project_id: project_id,
      survey_id: survey_id,
      brand_name: brand_name,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
      survey: survey,
      trigger: trigger,
    } = command

    with {:ok, project_created_event} <- ProjectCreated.new(%{project_id: project_id, brand_name: brand_name}),
          {:ok, market_defined_event} <- MarketDefined.new(%{project_id: project_id, market: market}),
          {:ok, needs_defined_event} <- NeedsDefined.new(%{project_id: project_id, job_steps: job_steps}),
          {:ok, survey_created_event} <- SurveyCreated.new(%{survey_id: survey.survey_id, starting_page_id: survey.starting_page_id, pages: survey.pages, trigger: trigger}),
          {:ok, survey_published_event} <- SurveyPublished.new(%{survey_id: survey.survey_id, starting_page_id: survey.starting_page_id, pages: survey.pages, trigger: trigger})
    do
      [project_created_event, market_defined_event, needs_defined_event, survey_created_event, survey_published_event]
    end
  end

  def apply(state, _event) do
    state
  end
end
