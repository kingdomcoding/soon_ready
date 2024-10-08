defmodule SoonReadyInterface.Researcher do
  use Ash.Domain

  resources do
    resource SoonReadyInterface.Researcher.Commands.CreateSurvey do
      define :create_survey, action: :dispatch
    end

    resource SoonReadyInterface.Researcher.Commands.Aggregate
  end
end
