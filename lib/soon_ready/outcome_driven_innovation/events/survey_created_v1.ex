defmodule SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationRequestedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
    Market,
    JobStep,
  }
  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.Survey.{
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion,
  }

  attributes do
    attribute :project_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, ScreeningQuestion}
    attribute :demographic_questions, {:array, DemographicQuestion}
    attribute :context_questions, {:array, ContextQuestion}
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.OutcomeDrivenInnovation
    define :new
  end
end
