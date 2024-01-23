defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.LandingPageForm do
  use SoonReadyInterface, :live_component

  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :brand_name, :string, allow_nil?: false
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-submit="submit" phx-target={@myself}>
        <Doggo.input
          field={f[:brand_name]}
          label="What's the brand name for this survey?"
        />
        <Doggo.button type="submit" name="submit">Start Your Adventure</Doggo.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(_assigns, socket) do
    socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, _view_model} ->
        send(self(), {:update_params, %{"landing_page_form" => form_params}})
        send(self(), {:handle_submission, __MODULE__})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end
end
