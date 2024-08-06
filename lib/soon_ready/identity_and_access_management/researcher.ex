defmodule SoonReady.IdentityAndAccessManagement.Researcher do
  use Ash.Resource, domain: SoonReady.IdentityAndAccessManagement
  use Commanded.Commands.Router

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher
  alias SoonReady.IdentityAndAccessManagement.Events.V1.ResearcherRegistered

  attributes do
    uuid_primary_key :researcher_id
  end

  actions do
    defaults [:create, :read]
  end

  code_interface do
    define :create
  end

  dispatch RegisterResearcher, to: __MODULE__, identity: :researcher_id

  def execute(_aggregate_state, %RegisterResearcher{} = command) do
    %{
      researcher_id: researcher_id,
      user_id: user_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    } = command

    params = %{
      researcher_id: researcher_id,
      user_id: user_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    }

    ResearcherRegistered.create(params)
  end

  def apply(state, _event) do
    state
  end
end
