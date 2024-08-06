defmodule SoonReady.IdentityAndAccessManagement.Resources.User do
  use Ash.Resource,
    domain: SoonReady.IdentityAndAccessManagement,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication],
    authorizers: [Ash.Policy.Authorizer]

  alias SoonReady.IdentityAndAccessManagement.Resources.Researcher

  attributes do
    uuid_primary_key :id
    attribute :username, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  relationships do
    has_one :researcher, SoonReady.IdentityAndAccessManagement.Resources.Researcher
  end

  calculations do
    calculate :is_researcher, :boolean, fn
      [%{researcher: %Researcher{}}] = _users, _context ->
        {:ok, [true]}
      _users, _context ->
        {:ok, [false]}
    end
  end

  changes do
    change load(:is_researcher)
    change load(:researcher)
  end

  preparations do
    prepare fn query, _context ->
      query
      |> Ash.Query.load(:is_researcher)
      |> Ash.Query.load(:researcher)
    end
  end

  actions do
    defaults [:read]

    read :get do
      get_by [:id]
    end

    destroy :delete do
      change set_context(%{private: %{ash_authentication?: true}})
    end
  end

  authentication do
    strategies do
      password :password do
        identity_field :username
      end
    end

    tokens do
      enabled? true
      token_resource SoonReady.IdentityAndAccessManagement.Resources.Token
      signing_secret fn _, _ ->
        Application.fetch_env(:soon_ready, :token_signing_secret)
      end
    end
  end

  postgres do
    identity_index_names unique_username: "iam__resources__users_unique_username_index"
    table "identity_and_access_management__resources__users"
    repo SoonReady.Repo
  end

  identities do
    identity :unique_username, [:username]
  end

  code_interface do
    define :get, args: [:id]
    define :read
    define :delete
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      forbid_if always()
    end
  end

  def register_user_with_password(username, password, password_confirmation) do
    SoonReady.IdentityAndAccessManagement.Resources.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.action(:register, %{"username" => username, "password" => password, "password_confirmation" => password_confirmation})
  end

  def sign_in_with_password(username, password) do
    SoonReady.IdentityAndAccessManagement.Resources.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.action(:sign_in, %{"username" => username, "password" => password})
  end
end
