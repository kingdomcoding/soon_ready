defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicsQuestionsForm.DemographicsQuestionField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicsQuestionsForm.OptionField

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, OptionField}, allow_nil?: false, constraints: [min_length: 2]
  end
end