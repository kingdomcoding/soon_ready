# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm do
#   use SoonReadyInterface, :live_component
#   use Ash.Resource, data_layer: :embedded
#   import SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form

#   alias __MODULE__.JobStepField

#   attributes do
#     attribute :job_steps, {:array, JobStepField}, allow_nil?: false, constraints: [min_length: 1]
#   end

#   @impl true
#   def render(assigns) do
#     ~H"""
#     <div>
#       <.card_form :let={f} for={@form} phx-change="validate" phx-submit="submit" target={@myself}>
#         <.inputs_for :let={ff} field={f[:job_steps]}>
#           <.card>
#             <:header>
#               <.card_header>
#                 <:title>Job Step <%= ff.index + 1 %></:title>
#                 <:thrash_button click="remove-job-step" name={"#{ff.name}"} target={@myself}>Remove Job Step</:thrash_button>
#                 <:text_input field={ff[:name]} placeholder="Enter name" />
#               </.card_header>
#             </:header>
#             <:body>
#               <.inputs_for :let={fff} field={ff[:desired_outcomes]}>
#                 <.card_field>
#                   <:text_input field={fff[:value]} placeholder="Desired Outcome" />
#                   <:thrash_button click="remove-desired-outcome" name={"#{fff.name}"} target={@myself}>Remove Desired Outcome</:thrash_button>
#                 </.card_field>
#               </.inputs_for>
#             </:body>
#             <:add_button name={ff.name} action="add-desired-outcome" target={@myself} field={ff[:desired_outcomes]}> Add Desired Outcome </:add_button>
#           </.card>
#         </.inputs_for>

#         <:add_button action="add-job-step" form_field={:job_steps}> Add Job Step </:add_button>
#         <:submit>Proceed</:submit>
#       </.card_form>
#     </div>
#     """
#   end

#   @impl true
#   def update(_assigns, socket) do
#     socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))

#     {:ok, socket}
#   end

#   @impl true
#   def handle_event("validate", params, socket) do
#     form_params = Map.get(params, "form", %{})
#     validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
#     {:noreply, assign(socket, form: validated_form)}
#   end

#   @impl true
#   def handle_event("submit", params, socket) do
#     form_params = Map.get(params, "form", %{})
#     case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
#       {:ok, _view_model} ->
#         send(self(), {:update_params, %{"desired_outcomes_form" => form_params}})
#         send(self(), {:handle_submission, __MODULE__})

#         {:noreply, socket}

#       {:error, form_with_error} ->
#         {:noreply, assign(socket, form: form_with_error)}
#     end
#   end

#   @impl true
#   def handle_event("add-job-step", _params, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, :job_steps, validate?: socket.assigns.form.errors || false))}
#   end

#   @impl true
#   def handle_event("remove-job-step", %{"name" => name}, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
#   end

#   @impl true
#   def handle_event("remove-desired-outcome", %{"name" => name}, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
#   end

#   @impl true
#   def handle_event("add-desired-outcome", %{"name" => name}, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[desired_outcomes]", validate?: socket.assigns.form.errors || false))}
#   end
# end
