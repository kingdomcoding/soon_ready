defmodule SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher do
  use Ash.Resource, domain: SoonReady.IdentityAndAccessManagement

  alias SoonReady.IdentityAndAccessManagement.Resources.{User, Researcher}

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :user_id, :uuid, allow_nil?: false
    attribute :first_name, :ci_string, allow_nil?: false
    attribute :last_name, :ci_string, allow_nil?: false
    attribute :username, :ci_string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
    attribute :password_confirmation, :string, allow_nil?: false
  end

  validations do
    validate confirm(:password, :password_confirmation)
  end

  actions do
    default_accept [
      :first_name,
      :last_name,
      :username,
      :password,
      :password_confirmation,
    ]

    create :dispatch do
      primary? true

      change fn changeset, _context ->
        researcher_id = Ash.UUID.generate()
        username = Ash.Changeset.get_attribute(changeset, :username)
        password = Ash.Changeset.get_attribute(changeset, :password)
        password_confirmation = Ash.Changeset.get_attribute(changeset, :password_confirmation)

        {:ok, %{id: user_id} = user} = User.register_user_with_password(username, password, password_confirmation)

        with {:error, _error} <- Researcher.create(%{id: researcher_id, user_id: user_id}) do
          :ok = User.delete(user)
        end

        changeset
        |> Ash.Changeset.change_attribute(:researcher_id, researcher_id)
        |> Ash.Changeset.change_attribute(:user_id, user_id)
      end

      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- SoonReady.Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define :dispatch
  end
end
