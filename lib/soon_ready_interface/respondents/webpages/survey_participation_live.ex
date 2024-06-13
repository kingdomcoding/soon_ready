# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive do
#   use SoonReadyInterface, :live_view
#   import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form

#   require Logger

#   alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.{
#     NicknameForm,
#     ScreeningForm,
#     ContactDetailsForm,
#     DemographicsForm,
#     ContextForm,
#     ComparisonForm,
#     DesiredOutcomeRatingForm
#   }
#   alias SoonReadyInterface.Respondents.ReadModels.Survey


#   alias SoonReady.SurveyManagement.DomainConcepts.{
#     ShortAnswerQuestion,
#     MultipleChoiceQuestion,
#     ParagraphQuestion,
#     MultipleChoiceQuestionGroup,
#   }
#   alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel
#   alias SoonReady.SurveyManagement.DomainConcepts.PageAction.ChangePage

#   def mount(%{"survey_id" => survey_id} = _params, _session, socket) do
#     # TODO: Make asyncronous
#     {:ok, %{starting_page_id: starting_page_id} = survey} = Survey.get_active(survey_id)

#     {:ok, assign(socket, :survey, survey)}
#   end

#   def handle_params(params, url, %{assigns: %{survey: survey}} = socket) do
#     {page_id, socket} =
#       case Map.get(params, "page_id") do
#         nil ->
#           socket = push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/pages/#{survey.starting_page_id}")
#           {survey.starting_page_id, socket}
#         page_id ->
#           {page_id, socket}
#       end

#     current_page = get_page(survey, page_id)

#     has_mcq_group_question = Enum.any?(current_page.questions || [], fn question -> question.type == MultipleChoiceQuestionGroup end)

#     {:noreply, assign(socket, params: params, current_page: current_page, has_mcq_group_question: has_mcq_group_question)}
#   end

#   def render(assigns) do
#     ~H"""
#     <.page is_wide={@has_mcq_group_question}>
#       <:title>
#         <%= @current_page.title %>
#       </:title>
#       <:subtitle>
#         <%= @current_page.description %>
#       </:subtitle>

#       <%= if @current_page.questions do %>
#         <.live_component module={FormViewModel} current_page={@current_page} has_mcq_group_question={@has_mcq_group_question} id="form_view_model" />
#       <% end %>
#     </.page>
#     """
#   end

#   def get_page(%{pages: pages} = _survey, page_id) do
#     pages
#     |> Enum.filter(fn %{id: id} = _page -> page_id == id end)
#     |> Enum.at(0)
#   end

#   def handle_info({:transition_from_page, %{transition: %{destination_page_id: destination_page_id, submit_response?: submit_response?}} = view_model}, socket) do
#     socket.assigns.params

#     params =
#       view_model
#       |> extract_query_params(socket.assigns.current_page)
#       |> deep_merge(socket.assigns.params)

#     if submit_response? do
#       params
#       |> normalize_response(socket.assigns.survey)
#       |> SoonReady.SurveyManagement.submit_response()
#       |> case do
#         {:ok, _aggregate} ->
#           socket =
#             socket
#             |> put_flash(:info, "Thank you for participating in our survey!")
#             |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{destination_page_id}")

#             {:noreply, socket}
#         {:error, error} ->
#           Logger.error("DEBUG: #{inspect(error)}")
#           socket = put_flash(socket, :error, "Something went wrong. Please try again or contact support.")
#           {:noreply, socket}
#       end
#     else
#       socket =
#         socket
#         |> assign(:params, params)
#         |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{destination_page_id}?#{params}")

#       {:noreply, socket}
#     end
#   end

#   def extract_query_params(%FormViewModel{responses: responses}, %{id: page_id} = _current_page) do
#     responses =
#       responses
#       |> Enum.reduce(%{}, fn
#         %{type: type, value: %{id: question_id, response: response}}, question_params when type in [
#           FormViewModel.ShortAnswerQuestionResponse,
#           FormViewModel.ParagraphQuestionResponse,
#         ] ->
#           Map.put(question_params, question_id, response)
#         %{type: FormViewModel.MultipleChoiceQuestionGroupResponse, value: %{id: question_id, prompt_responses: prompt_responses}}, question_params ->
#           response = Enum.reduce(prompt_responses, %{}, fn %{id: prompt_id, question_responses: question_responses}, prompt_response_params ->
#             prompt_response = Enum.reduce(question_responses, %{}, fn %{id: question_response_id, response: response}, question_response_params ->
#               Map.put(question_response_params, question_response_id, response)
#             end)
#             Map.put(prompt_response_params, prompt_id, prompt_response)
#           end)
#           Map.put(question_params, question_id, response)
#       end)
#     %{"pages" => %{page_id => %{"responses" => responses}}}
#     # %{"page_responses" => %{page_id => %{"questions" => responses}}}
#   end

#   # TODO: Avoid collision
#   defp deep_merge(map1, map2) do
#     Map.merge(map1, map2, fn _key, submap1, submap2 -> deep_merge(submap1, submap2) end)
#   end

#   def normalize_response(params, survey) do
#     questions =
#       Enum.reduce(survey.pages, [], fn
#         %{questions: nil}, acc ->
#           acc
#         %{questions: questions}, acc ->
#           Enum.reduce(questions, acc, fn %Ash.Union{value: question} = _question, acc ->
#             [question | acc]
#           end)
#       end)

#     responses =
#       Enum.reduce(params["pages"], [], fn {_page_id, %{"responses" => page_responses}}, acc ->
#         Enum.reduce(page_responses, acc, fn {question_id, response}, acc ->
#           question = Enum.find(questions, fn question -> question.id == question_id end)

#           normalized_response =
#             case question do
#               # TODO: Simplify to simple maps
#               %ShortAnswerQuestion{} ->
#                 %{"response" => response}
#                 |> Map.put("question_id", question_id)
#                 |> Map.put("type", "short_answer_question_response")
#               %MultipleChoiceQuestion{} ->
#                 %{"response" => response}
#                 |> Map.put("question_id", question_id)
#                 |> Map.put("type", "multiple_choice_question_response")
#               %ParagraphQuestion{} ->
#                 %{"response" => response}
#                 |> Map.put("question_id", question_id)
#                 |> Map.put("type", "paragraph_question_response")
#               %MultipleChoiceQuestionGroup{} ->
#                 responses = Enum.reduce(response, [], fn {prompt_id, prompt_response}, responses ->
#                   Enum.reduce(prompt_response, responses, fn {question_id, question_response}, responses ->
#                     [%{"prompt_id" => prompt_id, "question_id" => question_id, "response" => question_response} | responses]
#                   end)
#                 end)
#                 %{
#                   "type" => "multiple_choice_question_group_responses",
#                   "group_id" => question_id,
#                   "responses" => responses,
#                 }

#             end
#           [normalized_response | acc]
#         end)
#       end)

#     %{"survey_id" => params["survey_id"], "responses" => responses}
#   end
# end
