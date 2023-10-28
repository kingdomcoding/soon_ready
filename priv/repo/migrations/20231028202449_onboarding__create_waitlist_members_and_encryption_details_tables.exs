defmodule SoonReady.Repo.Migrations.OnboardingCreateWaitlistMembersAndEncryptionDetailsTables do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:onboarding__read_models__waitlist_members, primary_key: false) do
      add :person_id, :uuid, null: false, primary_key: true
      add :email, :text
    end

    create table(:onboarding__personally_identifiable_information__encryption_details,
             primary_key: false
           ) do
      add :person_id, :uuid, null: false, primary_key: true
      add :cloak_key, :text
    end
  end

  def down do
    drop table(:onboarding__personally_identifiable_information__encryption_details)

    drop table(:onboarding__read_models__waitlist_members)
  end
end