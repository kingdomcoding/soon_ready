defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.DemographicQuestionsForm.OptionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :value, :string, allow_nil?: false, public?: true
  end
end
