defmodule SoonReadyInterface.Admin.Webpages.ResearcherRegistrationLive do
  use SoonReadyInterface, :live_view

  alias SoonReadyInterface.Admin.Webpages.ResearcherRegistrationLive.Forms.RegisterResearcherForm

  def mount(_params, _session, socket) do
    form = AshPhoenix.Form.for_create(RegisterResearcherForm, :create, domain: SoonReadyInterface.Admin.Domain)

    {:ok, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <.simple_form :let={f} for={@form} phx-change="validate" phx-submit="submit">
      <.input field={f[:first_name]} label="First Name"/>
      <.input field={f[:last_name]} label="Last Name"/>
      <.input field={f[:username]} label="Username" />
      <.input field={f[:password]} label="Password"/>
      <.input field={f[:password_confirmation]} label="Password Confirmation"/>

      <:actions>
        <.button>Save</.button>
      </:actions>
    </.simple_form>
    """
  end

  def handle_event("validate", params, socket) do
    form_params = Map.get(params, "form", %{})
    validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
    {:noreply, assign(socket, form: validated_form)}
  end

  def handle_event("submit", params, socket) do
    form_params = Map.get(params, "form", %{})
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, form} ->
        %{
          first_name: first_name,
          last_name: last_name,
          username: username,
          password: password,
          password_confirmation: password_confirmation
        } = form

        params = %{
          first_name: first_name,
          last_name: last_name,
          username: username,
          password: password,
          password_confirmation: password_confirmation
        }

        {:ok, command} = SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher.dispatch(params)

        socket =
          socket
          |> push_navigate(to: ~p"/")
          |> put_flash(:info, "#{command.username} registered!")

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end
end
