defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.LiveComponents.SurveyPage do
  use SoonReadyInterface, :live_component

  import __MODULE__.Components

  alias SoonReady.SurveyManagement.V1.DomainConcepts.{
    Transition,
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    CheckboxQuestion,
    OptionWithCorrectFlag,
    ParagraphQuestion,
    ShortAnswerQuestionGroup,
    MultipleChoiceQuestionGroup,
  }

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm

  @impl true
  def update(assigns, socket) do
    has_mcq_group_question = Enum.any?(assigns.current_page.questions || [], fn question -> question.type == MultipleChoiceQuestionGroup end)

    socket =
      socket
      |> assign(:current_page, assigns.current_page)
      |> assign(:has_mcq_group_question, has_mcq_group_question)

    socket =
      if assigns.current_page.questions do
        form = create_survey_page_form(assigns.current_page)
        assign(socket, :form, AshPhoenix.Form.for_update(form, :submit, domain: SoonReadyInterface.Respondent, forms: [auto?: true]))
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    # <div id="accordion-open" data-accordion="open">
    accordion_attrs =
      if assigns.has_mcq_group_question do
        %{id: "accordion-open", "data-accordion": "open"}
      else
        %{}
      end
    assigns = assign(assigns, :accordion_attrs, accordion_attrs)

    ~H"""
    <div>
      <.page is_wide={@has_mcq_group_question}>
        <:title>
          <%= @current_page.title %>
        </:title>
        <:subtitle>
          <%= @current_page.description %>
        </:subtitle>

        <%= if @current_page.questions do %>
          <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex flex-col gap-2">
            <div {@accordion_attrs}>
              <.inputs_for :let={ff} field={f[:responses]}>
                <%= case ff.source.resource do %>
                  <% SurveyPageForm.ShortAnswerQuestionResponse -> %>
                    <.text_field
                      field={ff[:response]}
                      label={ff.data.prompt}
                      class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                    />
                  <% SurveyPageForm.MultipleChoiceQuestionResponse -> %>
                    <.radio_group
                      field={ff[:response]}
                      label={ff.data.prompt}
                      options={Enum.map(ff.data.options, fn option -> {option, option} end)}
                    />
                  <% SurveyPageForm.CheckboxQuestionResponse -> %>
                    <.checkbox_group
                      field={ff[:responses]}
                      label={ff.data.prompt}
                      options={Enum.map(ff.data.options, fn option -> {option, option} end)}
                    />
                  <% SurveyPageForm.ParagraphQuestionResponse -> %>
                    <.textarea
                      field={ff[:response]}
                      label={ff.data.prompt}
                      class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                    />
                  <% SurveyPageForm.MultipleChoiceQuestionGroupResponse -> %>
                    <.mcq_group
                      form={ff}
                      index={ff.index}
                      title={ff.data.title}
                      questions={ff.data.questions}
                    />
                  <% SurveyPageForm.ShortAnswerQuestionGroupResponse -> %>
                    <.short_answer_group
                      form={ff}
                      group_prompt={ff.data.group_prompt}
                      add_button_label={ff.data.add_button_label}
                      target={@myself}
                    />
                <% end %>
              </.inputs_for>
            </div>

            <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
          </.form>
        <% end %>
      </.page>
    </div>
    """
  end

  @impl true
  def handle_event("validate", params, socket) do
    form_params = Map.get(params, "form", %{})
    validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
    {:noreply, assign(socket, form: validated_form)}
  end

  @impl true
  def handle_event("add-short-answer-group-response", %{"name" => name, "index" => question_index} = _params, socket) do
    {question_index, ""} = Integer.parse(question_index)

    responses_index =
      Enum.at(socket.assigns.form.forms.responses, question_index).forms.responses
      |> Enum.count()

    form = AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[responses]", validate?: socket.assigns.form.errors || false)

    questions = Enum.map(Enum.at(form.data.responses, question_index).value.questions, fn %{id: id, prompt: prompt} -> %{id: id, prompt: prompt} end)

    form = Enum.reduce(questions, form, fn %{id: id, prompt: prompt}, form ->
      AshPhoenix.Form.add_form(form, "#{name}[responses][#{responses_index}][question_responses]", params: %{id: id, prompt: prompt}, validate?: socket.assigns.form.errors || false)
    end)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("remove-short-answer-group-response", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, form} ->
        send(self(), {:transition_from_page, form})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  def create_survey_page_form(%{questions: questions, transitions: page_transitions} = _survey_page) do
    responses =
      questions
      |> Enum.map(fn
        %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} ->
          %{type: "short_answer_question_response", id: id, prompt: prompt}
        %Ash.Union{type: MultipleChoiceQuestion, value: %MultipleChoiceQuestion{id: id, prompt: prompt, options: options}} ->
          options = Enum.map(options, fn
            %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
              value
            %Ash.Union{type: :ci_string, value: value} ->
              value
          end)
          %{type: "multiple_choice_question_response", id: id, prompt: prompt, options: options}
        %Ash.Union{type: CheckboxQuestion, value: %CheckboxQuestion{id: id, prompt: prompt, options: options, correct_answer_criteria: correct_answer_criteria}} ->
          options = Enum.map(options, fn
            %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
              value
            %Ash.Union{type: :ci_string, value: value} ->
              value
          end)
          %{type: "checkbox_question_response", id: id, prompt: prompt, options: options, correct_answer_criteria: correct_answer_criteria}
        %Ash.Union{type: ParagraphQuestion, value: %ParagraphQuestion{id: id, prompt: prompt}} ->
          %{type: "paragraph_question_response", id: id, prompt: prompt}
        %Ash.Union{type: ShortAnswerQuestionGroup, value: %ShortAnswerQuestionGroup{id: id, group_prompt: group_prompt, add_button_label: add_button_label, questions: questions}} ->
          questions = Enum.map(questions, fn %{id: id, prompt: prompt} = _question ->
            %{id: id, prompt: prompt}
          end)
          %{type: "short_answer_question_group_response", id: id, group_prompt: group_prompt, add_button_label: add_button_label, questions: questions}
        %Ash.Union{type: MultipleChoiceQuestionGroup, value: %MultipleChoiceQuestionGroup{id: id, title: title, prompts: prompts, questions: questions}} ->
          prompt_responses = Enum.map(prompts, fn %{id: id, prompt: prompt} ->
            question_responses = Enum.map(questions, fn %{id: id, prompt: prompt, options: options} ->
              options = Enum.map(options, fn
                %Ash.Union{value: option, type: :ci_string} -> option
              end)
              %{id: id, prompt: prompt, options: options}
            end)
            %{id: id, prompt: prompt, question_responses: question_responses}
          end)

          prompts = Enum.map(prompts, fn %{id: id, prompt: prompt} = _prompt -> %{id: id, prompt: prompt} end)
          questions = Enum.map(questions, fn %{id: id, prompt: prompt, options: options} = _question ->
            options = Enum.map(options, fn
              %Ash.Union{value: option, type: :ci_string} -> option
            end)
            %{id: id, prompt: prompt, options: options}
          end)
          %{type: "multiple_choice_question_group_response", id: id, title: title, prompts: prompts, questions: questions, prompt_responses: prompt_responses}
      end)

      SurveyPageForm.create!(%{page_transitions: page_transitions, responses: responses})
  end
end
