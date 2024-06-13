# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.LandingPageForm do
#   use SoonReadyInterface, :live_component
#   use Ash.Resource, data_layer: :embedded
#   import SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form

#   attributes do
#     attribute :brand_name, :string, allow_nil?: false
#   end

#   @impl true
#   def render(assigns) do
#     ~H"""
#     <div>
#       <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex gap-2">
#         <div class="w-full">
#           <.text_input
#             field={f[:brand_name]}
#             placeholder="What's the brand name for this survey?"
#             class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
#           />
#         </div>
#         <button type="submit" name="submit" class="flex-none py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 sm:w-fit hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Start Your Adventure</button>
#       </.form>
#     </div>
#     """
#   end

#   @impl true
#   def update(_assigns, socket) do
#     socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api))

#     {:ok, socket}
#   end

#   @impl true
#   def handle_event("validate", params, socket) do
#     form_params = Map.get(params, "form", %{})
#     validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
#     {:noreply, assign(socket, form: validated_form)}
#   end

#   @impl true
#   def handle_event("submit", %{"form" => form_params}, socket) do
#     case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
#       {:ok, _view_model} ->
#         send(self(), {:update_params, %{"landing_page_form" => form_params}})
#         send(self(), {:handle_submission, __MODULE__})

#         {:noreply, socket}

#       {:error, form_with_error} ->
#         {:noreply, assign(socket, form: form_with_error)}
#     end
#   end
# end
