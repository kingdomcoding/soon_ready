defmodule SoonReady.IdentityAndAccessManagement.Resources.Researcher do
  use Ash.Resource,
    domain: SoonReady.IdentityAndAccessManagement,
    data_layer: AshPostgres.DataLayer

  alias SoonReady.IdentityAndAccessManagement.DomainEvents.ResearcherRegistrationSucceededV1

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false
    attribute :user_id, :uuid, allow_nil?: false
  end

  relationships do
    belongs_to :user, SoonReady.IdentityAndAccessManagement.Resources.User do
      define_attribute? false
      source_attribute :user_id
    end
  end

  actions do
    default_accept [:id, :user_id]
    defaults [:create, :read]

    read :get do
      get_by [:id]

      prepare fn query, _context ->
        Ash.Query.load(query, [:user])
      end
    end
  end

  code_interface do
    define :create
    define :get, args: [:id]
  end

  postgres do
    repo SoonReady.Repo
    table "identity_and_access_management__resources__researchers"
  end
end
