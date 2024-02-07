defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ContextForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.ReadModels.OdiSurveys
  alias __MODULE__.Question

  attributes do
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update]

    create :from_read_model do
      argument :survey, OdiSurveys, allow_nil?: false

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

  def normalize(%{__struct__: __MODULE__, questions: questions}) do
    questions
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {question, index}, questions ->
      Map.put(questions, "#{index}", %{
        "prompt" => question.prompt,
        "response" => question.response
      })
    end)
  end
end