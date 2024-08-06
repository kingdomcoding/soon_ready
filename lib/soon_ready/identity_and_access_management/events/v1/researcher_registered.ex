defmodule SoonReady.IdentityAndAccessManagement.Events.V1.ResearcherRegistered do
  use Ash.Resource,
    domain: SoonReady.IdentityAndAccessManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  require Logger
  alias SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :user_id, :uuid, allow_nil?: false, public?: true
    attribute :first_name_hash, :string, allow_nil?: false, public?: true
    attribute :last_name_hash, :string, allow_nil?: false, public?: true
    attribute :username_hash, :string, allow_nil?:  false, public?: true
    attribute :password_hash, :string, allow_nil?: false, public?: true
    attribute :password_confirmation_hash, :string, allow_nil?: false, public?: true
  end

  actions do
    defaults [:read]

    create :create do
      accept [:researcher_id, :user_id]

      primary? true

      argument :first_name, :ci_string, allow_nil?: false
      argument :last_name, :ci_string, allow_nil?: false
      argument :username, :ci_string, allow_nil?:  false
      argument :password, :string, allow_nil?: false
      argument :password_confirmation, :string, allow_nil?: false

      change fn changeset, _context ->
        researcher_id = Ash.Changeset.get_attribute(changeset, :researcher_id)

        with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.generate(%{id: researcher_id}) do
          changeset =
            changeset
            |> encrypt(:first_name, :first_name_hash, encryption_key)
            |> encrypt(:last_name, :last_name_hash, encryption_key)
            |> encrypt(:username, :username_hash, encryption_key)
            |> encrypt(:password, :password_hash, encryption_key)
            |> encrypt(:password_confirmation, :password_confirmation_hash, encryption_key)
        end
      end
    end

    create :decrypt do
      accept [
        :researcher_id,
        :user_id,
        :first_name_hash,
        :last_name_hash,
        :username_hash,
        :password_hash,
        :password_confirmation_hash,
      ]
    end
  end

  calculations do
    calculate :encryption_key, :string, fn [record], _context ->
      with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.researcher_id) do
        {:ok, [encryption_key]}
      end
    end

    calculate :first_name, :ci_string, fn [record], _context ->
      case SoonReady.Vault.decrypt(%{key: record.encryption_key, cipher_text: record.first_name_hash}) do
        {:ok, first_name} -> {:ok, [Ash.CiString.new(first_name)]}
        :error -> {:error, :decryption_error}
      end
    end, load: [:encryption_key]

    calculate :last_name, :ci_string, fn [record], _context ->
      case SoonReady.Vault.decrypt(%{key: record.encryption_key, cipher_text: record.last_name_hash}) do
        {:ok, last_name} -> {:ok, [Ash.CiString.new(last_name)]}
        :error -> {:error, :decryption_error}
      end
    end, load: [:encryption_key]

    calculate :username, :ci_string, fn [record], _context ->
      case SoonReady.Vault.decrypt(%{key: record.encryption_key, cipher_text: record.username_hash}) do
        {:ok, username} -> {:ok, [Ash.CiString.new(username)]}
        :error -> {:error, :decryption_error}
      end
    end, load: [:encryption_key]

    calculate :password, :string, fn [record], _context ->
      case SoonReady.Vault.decrypt(%{key: record.encryption_key, cipher_text: record.password_hash}) do
        {:ok, password} -> {:ok, [password]}
        :error -> {:error, :decryption_error}
      end
    end, load: [:encryption_key]

    calculate :password_confirmation, :string, fn [record], _context ->
      case SoonReady.Vault.decrypt(%{key: record.encryption_key, cipher_text: record.password_confirmation_hash}) do
        {:ok, password_confirmation} -> {:ok, [password_confirmation]}
        :error -> {:error, :decryption_error}
      end
    end, load: [:encryption_key]
  end

  changes do
    change load(:first_name)
    change load(:last_name)
    change load(:username)
    change load(:password)
    change load(:password_confirmation)
  end

  preparations do
    prepare fn query, _context ->
      query
      |> Ash.Query.load(:first_name)
      |> Ash.Query.load(:last_name)
      |> Ash.Query.load(:username)
      |> Ash.Query.load(:password)
      |> Ash.Query.load(:password_confirmation)
    end
  end

  def encrypt(changeset, plain_field, cipher_field, encryption_key) do
    plain_text =
      changeset
      |> Ash.Changeset.get_argument(plain_field)
      |> to_string()

    case SoonReady.Vault.encrypt(%{key: encryption_key, plain_text: plain_text}) do
      {:ok, cipher_text} ->
        Ash.Changeset.change_attribute(changeset, cipher_field, cipher_text)
      :error ->
        Logger.warning("Encryption failed -- module: #{inspect(__MODULE__)}, field: #{inspect(plain_field)}, value: #{inspect(plain_text)}")
        Ash.Changeset.add_error(changeset, [field: plain_field, message: "encryption failed", value: plain_text])
    end
  end

  code_interface do
    define :create
    define :decrypt
  end
end
