defmodule SoonReadyInterface.Admin.Webpages.ResearcherRegistrationLiveTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  test "WHEN: An Administrator tries to register a researcher, THEN: The researcher is registered", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/secret-admin/register-researcher")

    view
    |> form("form", form: %{
      "first_name" => "first_name",
      "last_name" => "last_name",
      "username" => "john.doe",
      "password" => "password",
      "password_confirmation" => "password",
    })
    |> render_submit()

    %{"info" => flash_message} = assert_redirect(view, ~p"/")

    assert flash_message == "john.doe registered!"
  end
end
