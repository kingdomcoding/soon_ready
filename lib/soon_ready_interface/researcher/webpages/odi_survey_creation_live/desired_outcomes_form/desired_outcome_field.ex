defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm.DesiredOutcomeField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.QuantifyingNeeds.DomainDataTypes.OutcomeStatement

  attributes do
    attribute :value, OutcomeStatement, allow_nil?: false
  end
end
