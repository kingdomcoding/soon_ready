# defmodule SoonReadyInterface.Respondents.ReadModels.Survey do
#   # TODO: Restore to postgres
#   # use Ash.Resource, data_layer: AshPostgres.DataLayer
#   use Ash.Resource, data_layer: Ash.DataLayer.Ets
#   use Commanded.Event.Handler,
#     application: SoonReady.Application,
#     name: "#{__MODULE__}",
#     consistency: Application.get_env(:soon_ready, :consistency, :eventual)

#   alias SoonReady.SurveyManagement.Events.{SurveyCreatedV1, SurveyPublishedV1}
#   alias SoonReady.SurveyManagement.DomainConcepts.SurveyPage

#   attributes do
#     attribute :id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :starting_page_id, :uuid, allow_nil?: false
#     attribute :pages, {:array, SurveyPage}
#     attribute :is_active, :boolean, allow_nil?: false, default: false
#   end

#   actions do
#     defaults [:create, :read, :update]

#     read :get do
#       get_by :id
#     end

#     read :get_active do
#       get_by :id
#       filter expr(is_active == true)
#     end
#   end

#   code_interface do
#     define_for SoonReadyInterface.Respondents.Setup.Api

#     define :create

#     define :read

#     define :get do
#       args [:id]
#     end

#     define :get_active do
#       args [:id]
#     end

#     define :update
#   end

#   # # TODO: Check all postgres names for issues
#   # postgres do
#   #   repo SoonReady.Repo
#   #   table "respondents__read_models__survey"
#   # end


#   # TODO: Check
#   def handle(%SurveyCreatedV1{} = event, _metadata) do
#     %{
#       survey_id: survey_id,
#       starting_page_id: starting_page_id,
#       pages: pages,
#     } = event

#     with {:ok, _active_odi_survey} <- __MODULE__.create(%{
#       id: survey_id,
#       starting_page_id: starting_page_id,
#       pages: pages,
#     }) do
#       :ok
#     end
#   end

#   # TODO: Check
#   def handle(%SurveyPublishedV1{survey_id: survey_id} = _event, _metadata) do
#     # TODO: Refactor this not to need query?
#     with {:ok, survey} <- __MODULE__.get(survey_id),
#           {:ok, _odi_survey} <- __MODULE__.update(survey, %{is_active: true})
#     do
#       :ok
#     end
#   end
# end
