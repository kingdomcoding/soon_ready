defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ViewModels.ContextQuestionsForm.OptionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :value, :string, allow_nil?: false
  end
end
