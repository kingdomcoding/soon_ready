# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive do
#   use SoonReadyInterface, :live_view

#   require Logger

#   alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.{
#     LandingPageForm,
#     MarketDefinitionForm,
#     DesiredOutcomesForm,
#     ScreeningQuestionsForm,
#     DemographicQuestionsForm,
#     ContextQuestionsForm
#   }

#   def layout(assigns) do
#     ~H"""
#     <main class="dark:text-white">
#       <.flash_group flash={@flash} />
#       <header>
#         <nav class="bg-white border-gray-200 px-4 lg:px-6 py-4 dark:bg-gray-800">
#           <div class="flex flex-wrap justify-center items-center mx-auto max-w-screen-xl">
#             <a href={~p"/"} class="flex items-center">
#               <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">😎 SoonReady</span>
#             </a>
#           </div>
#         </nav>
#       </header>
#       <section class="bg-white dark:bg-gray-900">
#         <%= @inner_content %>
#       </section>
#     </main>
#     """
#   end

#   def mount(_params, _session, socket) do
#     current_user = Map.get(socket.assigns, :current_user)

#     case current_user do
#       %{is_researcher: true} ->
#         socket = assign(socket, :actor, current_user)
#         {:ok, socket, layout: {__MODULE__, :layout}}
#       _ ->
#         socket =
#           socket
#           |> redirect(to: ~p"/sign-in")
#           |> put_flash(:error, "A signed in researcher is required")
#         {:ok, socket}
#     end
#   end

#   def render(%{live_action: :landing_page} = assigns) do
#     ~H"""
#     <.page>
#       <:title>
#         Welcome to the ODI Survey Creator!
#       </:title>
#       <:subtitle>
#         Are you a researcher trying to create an ODI survey? This is where to get started!
#       </:subtitle>

#       <.live_component module={LandingPageForm} id="landing_page_form" />
#     </.page>
#     """
#   end

#   def render(%{live_action: :market_definition} = assigns) do
#     ~H"""
#     <.page>
#       <:title>
#         Market Definition
#       </:title>

#       <.live_component module={MarketDefinitionForm} id="market_definition_form" />
#     </.page>
#     """
#   end

#   def render(%{live_action: :desired_outcomes} = assigns) do
#     ~H"""
#     <.page is_wide={true}>
#       <:title>
#         Desired Outcomes
#       </:title>

#       <.live_component module={DesiredOutcomesForm} id="desired_outcomes_form" />
#     </.page>
#     """
#   end

#   def render(%{live_action: :screening_questions} = assigns) do
#     ~H"""
#     <.page is_wide={true}>
#       <:title>
#         Screening Questions
#       </:title>

#       <.live_component module={ScreeningQuestionsForm} id="screening_questions_form" />
#     </.page>
#     """
#   end

#   def render(%{live_action: :demographic_questions} = assigns) do
#     ~H"""
#     <.page is_wide={true}>
#       <:title>
#         Demographic Questions
#       </:title>

#       <.live_component module={DemographicQuestionsForm} id="demographic_questions_form" />
#     </.page>
#     """
#   end

#   def render(%{live_action: :context_questions} = assigns) do
#     ~H"""
#     <.page is_wide={true}>
#       <:title>
#         Context Questions
#       </:title>

#       <.live_component module={ContextQuestionsForm} id="context_questions_form" />
#     </.page>
#     """
#   end

#   attr :is_wide, :boolean, default: false
#   slot :title, required: true
#   slot :subtitle
#   slot :inner_block, required: true
#   def page(assigns) do
#     ~H"""
#     <div class={["py-8 lg:py-16 px-4", unless @is_wide do " mx-auto max-w-screen-md" end]}>
#       <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-center text-gray-900 dark:text-white">
#         <%= render_slot(@title) %>
#       </h2>
#       <%= if @subtitle != [] do %>
#         <p class="mb-8 lg:mb-16 font-light text-center text-gray-500 dark:text-gray-400 sm:text-xl">
#           <%= render_slot(@subtitle) %>
#         </p>
#       <% end %>
#       <%= render_slot(@inner_block) %>
#     </div>
#     """
#   end

#   def handle_params(params, _url, socket) do
#     {:noreply, assign(socket, params: params)}
#   end

#   def handle_info({:update_params, new_params}, socket) do
#     params = Map.merge(socket.assigns.params, new_params)
#     {:noreply, assign(socket, :params, params)}
#   end

#   def handle_info({:handle_submission, LandingPageForm}, socket) do
#     {:noreply, push_patch(socket, to: ~p"/odi-survey/create/market-definition?#{socket.assigns.params}")}
#   end

#   def handle_info({:handle_submission, MarketDefinitionForm}, socket) do
#     {:noreply, push_patch(socket, to: ~p"/odi-survey/create/desired-outcomes?#{socket.assigns.params}")}
#   end

#   def handle_info({:handle_submission, DesiredOutcomesForm}, socket) do
#     {:noreply, push_patch(socket, to: ~p"/odi-survey/create/screening-questions?#{socket.assigns.params}")}
#   end

#   def handle_info({:handle_submission, ScreeningQuestionsForm}, socket) do
#     {:noreply, push_patch(socket, to: ~p"/odi-survey/create/demographic-questions?#{socket.assigns.params}")}
#   end

#   def handle_info({:handle_submission, DemographicQuestionsForm}, socket) do
#     {:noreply, push_patch(socket, to: ~p"/odi-survey/create/context-questions?#{socket.assigns.params}")}
#   end

#   def handle_info({:handle_submission, ContextQuestionsForm}, socket) do
#     normalized_params = normalize(socket.assigns.params)
#     |> IO.inspect()

#     {:ok, %{project_id: project_id} = _command} = SoonReady.OutcomeDrivenInnovation.create_project(%{brand_name: normalized_params.brand_name})
#     {:ok, _command} = SoonReady.OutcomeDrivenInnovation.define_market(%{project_id: project_id, market: normalized_params.market})
#     {:ok, _command} = SoonReady.OutcomeDrivenInnovation.define_needs(%{project_id: project_id, job_steps: normalized_params.job_steps})

#     {:ok, %{survey_id: survey_id} = _command} = SoonReady.OutcomeDrivenInnovation.create_survey(%{
#       project_id: project_id,
#       screening_questions: normalized_params.screening_questions,
#       demographic_questions: normalized_params.demographic_questions,
#       context_questions: normalized_params.context_questions,
#       raw_screening_questions: normalized_params.raw_screening_questions,
#       raw_demographic_questions: normalized_params.raw_demographic_questions,
#       raw_context_questions: normalized_params.raw_context_questions,
#     })

#     socket =
#       socket
#       |> push_redirect(to: ~p"/")
#       |> put_flash(:info, "Survey published successfully!")
#     {:noreply, socket}

#     # SoonReady.OutcomeDrivenInnovation.create_survey(normalized_params, socket.assigns.actor)

#     # case SoonReady.OutcomeDrivenInnovation.create_survey(normalized_params, socket.assigns.actor) do
#     #   {:ok, %{project_id: _project_id} = _command} ->
#     #     socket =
#     #       socket
#     #       |> push_redirect(to: ~p"/")
#     #       |> put_flash(:info, "Survey published successfully!")
#     #     {:noreply, socket}
#     #   {:error, error} ->
#     #     socket =
#     #       socket
#     #       |> put_flash(:error, "Survey publishing failed. Please try again or contact support.")

#     #       Logger.error("Survey publishing failed: #{inspect(error)}")
#     #     {:noreply, socket}
#     # end

#     # TODO: Wait for SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationSucceededV1 with this project_id to confirm?
#   end

#   defp normalize(params) do
#     screening_questions = Enum.map(params["screening_questions_form"]["screening_questions"], fn {_index, screening_question} ->
#       %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: screening_question["prompt"],
#         options: Enum.map(screening_question["options"], fn {_index, option} ->
#           %{type: "option_with_correct_flag", value: option["value"], correct?: option["is_correct_option"] == "true"}
#         end)
#       }
#     end)

#     demographic_questions = Enum.map(params["demographic_questions_form"]["demographic_questions"], fn {_index, demographic_question} ->
#       %{type: "multiple_choice_question", prompt: demographic_question["prompt"],
#         options: Enum.map(demographic_question["options"], fn {_index, option} -> option["value"] end)
#       }
#     end)

#     context_questions = Enum.map(params["context_questions_form"]["context_questions"], fn {_index, context_question} ->
#       %{type: "multiple_choice_question", prompt: context_question["prompt"],
#         options: Enum.map(context_question["options"], fn {_index, option} -> option["value"] end)
#       }
#     end)

#     %{
#       brand_name: params["landing_page_form"]["brand_name"],
#       market: %{job_executor: params["market_definition_form"]["job_executor"],
#                 job_to_be_done: params["market_definition_form"]["job_to_be_done"]},
#       job_steps: Enum.map(params["desired_outcomes_form"]["job_steps"], fn {_index, job_step} ->
#         %{name: job_step["name"],
#           desired_outcomes: Enum.map(job_step["desired_outcomes"], fn {_index, desired_outcome} -> desired_outcome["value"] end)
#         }
#       end),
#       screening_questions: screening_questions,
#       demographic_questions: demographic_questions,
#       context_questions: context_questions,
#       raw_screening_questions: screening_questions,
#       raw_demographic_questions: demographic_questions,
#       raw_context_questions: context_questions,
#     }
#   end
# end
