defmodule SoonReadyInterface.Respondents.Setup.Api do
  use Ash.Api

  resources do
    resource SoonReadyInterface.Respondents.ReadModels.OdiSurveys
  end
end
