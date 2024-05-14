defmodule SoonReady.SurveyManagement do
  use Ash.Api

  alias SoonReady.SurveyManagement.Commands.{CreateSurvey, PublishSurvey, SubmitSurveyResponse}
  alias SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey

  resources do

  end

  authorization do
    authorize :by_default
  end

  def create_survey(params, actor \\ nil), do: CreateSurvey.dispatch(params, [actor: actor])
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch
end