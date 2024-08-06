defmodule SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcherTest do
  use SoonReady.DataCase
  import Commanded.Assertions.EventAssertions

  alias SoonReady.IdentityAndAccessManagement.Events.V1.ResearcherRegistered

  test "WHEN: An Admin tries to register a reseacher, THEN: A researcher is registered" do
    {:ok, command} = SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher.dispatch(%{
      first_name: "First",
      last_name: "Last",
      username: "username",
      password: "password",
      password_confirmation: "password"
    })

    assert_receive_event(SoonReady.Application, ResearcherRegistered,
      fn event -> event.researcher_id == command.researcher_id && event.user_id == command.user_id end,
      fn event ->
        %{
          researcher_id: researcher_id,
          user_id: user_id,
          first_name_hash: first_name_hash,
          last_name_hash: last_name_hash,
          username_hash: username_hash,
          password_hash: password_hash,
          password_confirmation_hash: password_confirmation_hash,
        } = event

        params = %{
          researcher_id: researcher_id,
          user_id: user_id,
          first_name_hash: first_name_hash,
          last_name_hash: last_name_hash,
          username_hash: username_hash,
          password_hash: password_hash,
          password_confirmation_hash: password_confirmation_hash,
        }

        {:ok, event} = ResearcherRegistered.decrypt(params)

        assert event.first_name == command.first_name
        assert event.last_name == command.last_name
        assert event.username == command.username
        assert event.password == command.password
        assert event.password_confirmation == command.password_confirmation
      end
    )
  end
end
