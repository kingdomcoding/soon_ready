defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.ContextForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.ReadModels.ActiveOdiSurveys
  alias __MODULE__.Question

  attributes do
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update]

    create :from_read_model do
      argument :survey, ActiveOdiSurveys, allow_nil?: false

      change fn changeset, _context ->
        read_model = Ash.Changeset.get_argument(changeset, :survey)

        questions = Enum.map(read_model.context_questions, fn context_question ->
          Question.create!(%{
            prompt: context_question.prompt,
            options: context_question.options
          })
        end)
        Ash.Changeset.change_attribute(changeset, :questions, questions)
      end
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :from_read_model do
      args [:survey]
    end
  end
end