defmodule SoonReady.Repo.Migrations.RenameIds do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    rename table(:quantifying_needs__survey_response__encryption__ciphers), :id, to: :response_id
  end

  def down do
    rename table(:quantifying_needs__survey_response__encryption__ciphers), :response_id, to: :id
  end
end
