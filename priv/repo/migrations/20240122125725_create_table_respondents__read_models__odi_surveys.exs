defmodule SoonReady.Repo.Migrations.CreateTableRespondentsReadModelsOdiSurveys do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:respondents__read_models__odi_surveys, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :brand, :text
      add :market, :map
      add :job_steps, {:array, :map}
      add :screening_questions, {:array, :map}
      add :demographic_questions, {:array, :map}
      add :context_questions, {:array, :map}
      add :is_active, :boolean, null: false, default: false
    end
  end

  def down do
    drop table(:respondents__read_models__odi_surveys)
  end
end
