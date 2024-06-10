defmodule SoonReady.SurveyManagement.Events.SurveyCreatedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.{SurveyPage, Trigger}

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :starting_page_id, :uuid, allow_nil?: false
    attribute :pages, {:array, :map}
    attribute :trigger, Trigger
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.SurveyManagement
    define :new
  end
end
