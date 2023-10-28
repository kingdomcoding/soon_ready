defmodule SoonReady.Onboarding.Commands.JoinWaitlist do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.Validations.EmailIsUnique
  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined

  attributes do
    uuid_primary_key :person_id
    attribute :email, EmailAddress, allow_nil?: false
  end

  validations do
    validate {EmailIsUnique, email_field: :email}
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end

  def execute(%{__struct__: __MODULE__, person_id: person_id, email: email} = _command, _aggregate_state) do
    WaitlistJoined.create!(%{person_id: person_id, email: email})
  end
end
