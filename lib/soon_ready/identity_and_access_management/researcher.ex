defmodule SoonReady.IdentityAndAccessManagement.Researcher do
  use Ash.Resource, data_layer: :embedded
  use Commanded.Commands.Router
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    consistency: :strong,
    name: __MODULE__

  alias SoonReady.IdentityAndAccessManagement.Commands.{
    InitiateResearcherRegistration,
    MarkResearcherRegistrationAsSuccessful,
    MarkResearcherRegistrationAsFailed,
  }
  alias SoonReady.IdentityAndAccessManagement.Events.{
    ResearcherRegistrationInitiatedV1,
    ResearcherRegistrationSucceededV1,
    ResearcherRegistrationFailedV1,
  }

  attributes do
    uuid_primary_key :researcher_id
  end

  code_interface do
    define_for SoonReady.IdentityAndAccessManagement
    define :create
  end

  dispatch InitiateResearcherRegistration, to: __MODULE__, identity: :researcher_id
  dispatch MarkResearcherRegistrationAsSuccessful, to: __MODULE__, identity: :researcher_id
  dispatch MarkResearcherRegistrationAsFailed, to: __MODULE__, identity: :researcher_id

  def execute(_aggregate_state, %InitiateResearcherRegistration{} = command) do
    %{
      researcher_id: researcher_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    } = command

    params = %{
      researcher_id: researcher_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    }

    ResearcherRegistrationInitiatedV1.create(params)
  end

  def execute(_aggregate_state, %MarkResearcherRegistrationAsSuccessful{researcher_id: researcher_id, user_id: user_id} = command) do
    ResearcherRegistrationSucceededV1.create(%{researcher_id: researcher_id, user_id: user_id})
  end

  def execute(_aggregate_state, %MarkResearcherRegistrationAsFailed{researcher_id: researcher_id, error: error} = command) do
    ResearcherRegistrationFailedV1.create(%{researcher_id: researcher_id, error: error})
  end

  def handle(%ResearcherRegistrationInitiatedV1{} = event, _metadata) do
    event =
      event
      |> Map.from_struct()
      |> ResearcherRegistrationInitiatedV1.decrypt!()

    %{
      researcher_id: researcher_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    } = event

    case SoonReady.IdentityAndAccessManagement.Resources.User.register_user_with_password(username, password, password_confirmation) do
      {:ok, %{id: user_id} = user} ->
        {:ok, _command} = MarkResearcherRegistrationAsSuccessful.dispatch(%{researcher_id: researcher_id, user_id: user_id})
      {:error, error} ->
        {:ok, _command} = MarkResearcherRegistrationAsFailed.dispatch(%{researcher_id: researcher_id, error: error})
    end

    :ok
  end

  def apply(state, %ResearcherRegistrationInitiatedV1{researcher_id: researcher_id} = _event) do
    __MODULE__.create(%{researcher_id: researcher_id})
  end

  def apply(state, _event) do
    state
  end
end
