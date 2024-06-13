# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel do
#   use SoonReadyInterface, :live_component
#   use Ash.Resource, data_layer: :embedded
#   import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form
#   import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Layout

#   alias SoonReady.SurveyManagement.DomainConcepts.{
#     Transition,
#     ShortAnswerQuestion,
#     MultipleChoiceQuestion,
#     OptionWithCorrectFlag,
#     ParagraphQuestion,
#     MultipleChoiceQuestionGroup,
#   }

#   alias SoonReady.SurveyManagement.DomainConcepts.Transition.{Always, ResponseEquals, AnyTrue, AllTrue}
#   alias __MODULE__.Response

#   attributes do
#     attribute :responses, {:array, Response}
#     attribute :page_transitions, {:array, Transition}
#   end

#   calculations do
#     calculate :transition, Transition, fn resource, _context ->
#       transition = Enum.find(resource.page_transitions, fn transition -> transition_condition_fulfilled(resource, transition.condition) end)
#       {:ok, transition}
#     end
#   end

#   actions do
#     defaults [:create, :read, :update]

#     update :submit do
#       change load(:transition)
#     end
#   end

#   code_interface do
#     define_for SoonReadyInterface.Respondents.Setup.Api
#     define :create
#   end

#   def transition_condition_fulfilled(_resource, %{type: Always}) do
#     true
#   end

#   def transition_condition_fulfilled(%{responses: responses} = _resource, %{type: ResponseEquals, value: %{question_id: question_id, value: value}}) do
#     Enum.any?(responses, fn response -> response.value.id == question_id && to_string(response.value.response) == to_string(value) end)
#   end

#   def transition_condition_fulfilled(resource, %{type: AnyTrue, value: %{conditions: conditions}}) do
#     Enum.any?(conditions, fn condition -> transition_condition_fulfilled(resource, condition) end)
#   end

#   def transition_condition_fulfilled(resource, %{type: AllTrue, value: %{conditions: conditions}}) do
#     Enum.all?(conditions, fn condition -> transition_condition_fulfilled(resource, condition) end)
#   end

#   @impl true
#   def update(assigns, socket) do
#     view_model = create_response_view_model(assigns.current_page)

#     socket =
#       socket
#       |> assign(:has_mcq_group_question, assigns.has_mcq_group_question)
#       |> assign(:current_page, assigns.current_page)
#       |> assign(:form, AshPhoenix.Form.for_update(view_model, :submit, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
#         responses: [
#           type: :list,
#           data: view_model.responses,
#           update_action: :update,
#           forms: [
#             prompt_responses: [
#               type: :list,
#               data: fn
#                 %AshPhoenix.Form.WrappedValue{value: %{type: __MODULE__.MultipleChoiceQuestionGroupResponse}} = question -> question.value.value.prompt_responses
#                 _question -> []
#               end,
#               update_action: :update,
#               forms: [
#                 question_responses: [
#                   type: :list,
#                   data: fn prompt_response -> prompt_response.question_responses end,
#                   update_action: :update,
#                 ]
#               ],
#             ]
#           ],
#           transform_params: fn form, params, _arg3 ->
#             case form.data.value do
#               %Ash.Union{type: __MODULE__.ShortAnswerQuestionResponse, value: %{id: id, prompt: prompt}} ->
#                 params
#                 |> Map.put("type", "short_answer_question_response")
#                 |> Map.put("id", id)
#                 |> Map.put("prompt", prompt)
#               %Ash.Union{type: __MODULE__.MultipleChoiceQuestionResponse, value: %{id: id, prompt: prompt, options: options}} ->
#                 params
#                 |> Map.put("type", "short_answer_question_response")
#                 |> Map.put("id", id)
#                 |> Map.put("prompt", prompt)
#                 |> Map.put("options", options)
#               %Ash.Union{type: __MODULE__.ParagraphQuestionResponse, value: %{id: id, prompt: prompt}} ->
#                 params
#                 |> Map.put("type", "paragraph_question_response")
#                 |> Map.put("id", id)
#                 |> Map.put("prompt", prompt)
#               %Ash.Union{type: __MODULE__.MultipleChoiceQuestionGroupResponse, value: %{id: id, title: title, prompts: prompts, questions: questions}} ->
#                 params
#                 |> Map.put("type", "multiple_choice_question_group_response")
#                 |> Map.put("id", id)
#                 |> Map.put("title", title)
#                 |> Map.put("prompts", prompts)
#                 |> Map.put("questions", questions)
#             end
#           end
#         ]
#       ]))

#     {:ok, socket}
#   end

#   @impl true
#   def render(assigns) do
#     # <div id="accordion-open" data-accordion="open">
#     accordion_attrs =
#       if assigns.has_mcq_group_question do
#         %{id: "accordion-open", "data-accordion": "open"}
#       else
#         %{}
#       end
#     assigns = assign(assigns, :accordion_attrs, accordion_attrs)
#     ~H"""
#     <div>
#       <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex flex-col gap-2">
#         <div {@accordion_attrs}>
#           <.inputs_for :let={ff} field={f[:responses]}>
#             <%= case ff.data.value.type do %>
#               <% __MODULE__.ShortAnswerQuestionResponse -> %>
#                 <.text_field
#                   field={ff[:response]}
#                   label={ff.data.value.value.prompt}
#                   class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
#                 />
#               <% __MODULE__.MultipleChoiceQuestionResponse -> %>
#                 <.radio_group
#                   field={ff[:response]}
#                   label={ff.data.value.value.prompt}
#                   options={Enum.map(ff.data.value.value.options, fn option -> {option, option} end)}
#                 />
#               <% __MODULE__.ParagraphQuestionResponse -> %>
#                 <.textarea
#                   field={ff[:response]}
#                   label={ff.data.value.value.prompt}
#                   class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
#                 />
#               <% __MODULE__.MultipleChoiceQuestionGroupResponse -> %>
#                 <.mcq_group
#                   form={ff}
#                   index={ff.index}
#                   title={ff.data.value.value.title}
#                   questions={ff.data.value.value.questions}
#                 />
#             <% end %>
#           </.inputs_for>
#         </div>

#         <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
#       </.form>
#     </div>
#     """
#   end

#   def mcq_group(assigns) do
#     # TODO: How do I handle index?

#     # TODO: Rename ODI related component, attr and slot names
#     IO.inspect(assigns)
#     ~H"""
#     <.accordion index={@index}>
#       <:title><%= @title %></:title>

#       <.rating_section>
#         <.rating_section_header questions={@questions} />

#         <.rating_section_body>
#           <.inputs_for :let={prompt_form} field={@form[:prompt_responses]}>
#             <.outcome_rating desired_outcome={prompt_form.data.prompt}>
#               <.inputs_for :let={question_form} field={prompt_form[:question_responses]}>
#                 <.rating_radio_group field={question_form[:response]} options={question_form.data.options} />
#               </.inputs_for>
#             </.outcome_rating>
#           </.inputs_for>
#         </.rating_section_body>
#       </.rating_section>
#     </.accordion>
#     """
#   end

#   def create_response_view_model(%{questions: questions, transitions: page_transitions} = _survey_page) do
#     responses =
#       questions
#       |> Enum.map(fn
#         %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} ->
#           %{type: "short_answer_question_response", id: id, prompt: prompt}
#         %Ash.Union{type: MultipleChoiceQuestion, value: %MultipleChoiceQuestion{id: id, prompt: prompt, options: options}} ->
#           options = Enum.map(options, fn
#             %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
#               value
#             %Ash.Union{type: :ci_string, value: value} ->
#               value
#           end)
#           %{type: "multiple_choice_question_response", id: id, prompt: prompt, options: options}
#         %Ash.Union{type: ParagraphQuestion, value: %ParagraphQuestion{id: id, prompt: prompt}} ->
#           %{type: "paragraph_question_response", id: id, prompt: prompt}
#         %Ash.Union{type: MultipleChoiceQuestionGroup, value: %MultipleChoiceQuestionGroup{id: id, title: title, prompts: prompts, questions: questions}} ->
#           prompt_responses = Enum.map(prompts, fn %{id: id, prompt: prompt} ->
#             question_responses = Enum.map(questions, fn %{id: id, prompt: prompt, options: options} ->
#               options = Enum.map(options, fn
#                 %Ash.Union{value: option, type: :ci_string} -> option
#               end)
#               %{id: id, prompt: prompt, options: options}
#             end)
#             %{id: id, prompt: prompt, question_responses: question_responses}
#           end)

#           prompts = Enum.map(prompts, fn %{id: id, prompt: prompt} = _prompt -> %{id: id, prompt: prompt} end)
#           questions = Enum.map(questions, fn %{id: id, prompt: prompt, options: options} = _question ->
#             options = Enum.map(options, fn
#               %Ash.Union{value: option, type: :ci_string} -> option
#             end)
#             %{id: id, prompt: prompt, options: options}
#           end)
#           %{type: "multiple_choice_question_group_response", id: id, title: title, prompts: prompts, questions: questions, prompt_responses: prompt_responses}
#       end)

#       __MODULE__.create!(%{page_transitions: page_transitions, responses: responses})
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
#       {:ok, view_model} ->
#         send(self(), {:transition_from_page, view_model})

#         {:noreply, socket}

#       {:error, form_with_error} ->
#         {:noreply, assign(socket, form: form_with_error)}
#     end
#   end
# end
