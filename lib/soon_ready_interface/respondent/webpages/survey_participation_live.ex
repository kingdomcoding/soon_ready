defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive do
  use SoonReadyInterface, :live_view

  require Logger

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.LiveComponents.SurveyPage

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.{
    NicknameForm,
    ScreeningForm,
    ContactDetailsForm,
    DemographicsForm,
    ContextForm,
    ComparisonForm,
    DesiredOutcomeRatingForm
  }
  alias SoonReadyInterface.Respondent.ReadModels.Survey


  alias SoonReady.SurveyManagement.V1.DomainConcepts.{
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    ParagraphQuestion,
    ShortAnswerQuestionGroup,
    MultipleChoiceQuestionGroup,
  }
  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Forms.SurveyPageForm
  alias SoonReady.SurveyManagement.V1.DomainConcepts.PageAction.ChangePage

  def mount(%{"survey_id" => survey_id} = _params, _session, socket) do
    # TODO: Make asyncronous
    {:ok, %{starting_page_id: starting_page_id} = survey} = Survey.get_active(survey_id)

    {:ok, assign(socket, :survey, survey)}
  end

  def handle_params(params, url, %{assigns: %{survey: survey}} = socket) do
    {page_id, socket} =
      case Map.get(params, "page_id") do
        nil ->
          socket = push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/pages/#{survey.starting_page_id}")
          {survey.starting_page_id, socket}
        page_id ->
          {page_id, socket}
      end

    current_page = get_page(survey, page_id)

    {:noreply, assign(socket, params: params, current_page: current_page)}
  end

  def get_page(%{pages: pages} = _survey, page_id) do
    pages
    |> Enum.filter(fn %{id: id} = _page -> page_id == id end)
    |> Enum.at(0)
  end

  def render(assigns) do
    ~H"""
    <.live_component id="survey_page" module={SurveyPage} current_page={@current_page} />
    """
  end

  def handle_info({:transition_from_page, %{transition: %{destination_page_id: destination_page_id, submit_response?: submit_response?}} = form}, socket) do
    params =
      form
      |> extract_query_params(socket.assigns.current_page)
      |> deep_merge(socket.assigns.params)

    if submit_response? do
      params
      |> normalize_response(socket.assigns.survey)
      |> SoonReadyInterface.Respondent.submit_survey_response()
      |> case do
        {:ok, _aggregate} ->
          socket =
            socket
            |> put_flash(:info, "Thank you for participating in our survey!")
            |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{destination_page_id}")

            {:noreply, socket}
        {:error, error} ->
          Logger.error("DEBUG: #{inspect(error)}")
          socket = put_flash(socket, :error, "Something went wrong. Please try again or contact support.")
          {:noreply, socket}
      end
    else
      socket =
        socket
        |> assign(:params, params)
        |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{destination_page_id}?#{params}")

      {:noreply, socket}
    end
  end

  def extract_query_params(%SurveyPageForm{responses: responses}, %{id: page_id} = _current_page) do
    responses =
      responses
      |> Enum.reduce(%{}, fn
        %{type: type, value: %{id: question_id, response: response}}, question_params when type in [
          SurveyPageForm.ShortAnswerQuestionResponse,
          SurveyPageForm.ParagraphQuestionResponse,
          SurveyPageForm.MultipleChoiceQuestionResponse,
        ] ->
          Map.put(question_params, question_id, response)
        %{type: SurveyPageForm.CheckboxQuestionResponse, value: %{id: question_id, responses: responses}}, question_params ->
          Map.put(question_params, question_id, responses)
        %{type: SurveyPageForm.ShortAnswerQuestionGroupResponse, value: %{id: group_id, responses: responses}}, question_params ->
          responses = Enum.reduce(responses, %{}, fn %{id: batch_id, question_responses: question_responses}, responses_params ->
            question_responses = Enum.reduce(question_responses, %{}, fn %{id: question_id, response: response}, question_responses_params ->
              Map.put(question_responses_params, question_id, response)
            end)
            Map.put(responses_params, batch_id, question_responses)
          end)
          Map.put(question_params, group_id, responses)
        %{type: SurveyPageForm.MultipleChoiceQuestionGroupResponse, value: %{id: question_id, prompt_responses: prompt_responses}}, question_params ->
          response = Enum.reduce(prompt_responses, %{}, fn %{id: prompt_id, question_responses: question_responses}, prompt_response_params ->
            prompt_response = Enum.reduce(question_responses, %{}, fn %{id: question_response_id, response: response}, question_response_params ->
              Map.put(question_response_params, question_response_id, response)
            end)
            Map.put(prompt_response_params, prompt_id, prompt_response)
          end)
          Map.put(question_params, question_id, response)
      end)
    %{"pages" => %{page_id => %{"responses" => responses}}}
  end

  defp deep_merge(map1, map2) do
    Map.merge(map1, map2, fn _key, submap1, submap2 -> deep_merge(submap1, submap2) end)
  end

  def normalize_response(params, survey) do
    questions =
      Enum.reduce(survey.pages, [], fn
        %{questions: nil}, acc ->
          acc
        %{questions: questions}, acc ->
          Enum.reduce(questions, acc, fn %Ash.Union{value: question} = _question, acc ->
            [question | acc]
          end)
      end)

    responses =
      Enum.reduce(params["pages"], [], fn {_page_id, %{"responses" => page_responses}}, acc ->
        Enum.reduce(page_responses, acc, fn {question_id, response}, acc ->
          question = Enum.find(questions, fn question -> question.id == question_id end)

          normalized_response =
            case question do
              %ShortAnswerQuestion{} ->
                %{"type" => "short_answer_question_response", "question_id" => question_id, "response" => response}
              %MultipleChoiceQuestion{} ->
                %{"type" => "multiple_choice_question_response", "question_id" => question_id, "response" => response}
              %ParagraphQuestion{} ->
                %{"type" => "paragraph_question_response", "question_id" => question_id, "response" => response}
              %ShortAnswerQuestionGroup{} ->
                responses = Enum.reduce(response, [], fn {batch_id, batch_response}, responses ->
                  Enum.reduce(batch_response, responses, fn {question_id, question_response}, responses ->
                    [%{"batch_id" => batch_id, "question_id" => question_id, "response" => question_response} | responses]
                  end)
                end)
                %{
                  "type" => "short_answer_question_group_responses",
                  "group_id" => question_id,
                  "responses" => responses,
                }
              %MultipleChoiceQuestionGroup{} ->
                responses = Enum.reduce(response, [], fn {prompt_id, prompt_response}, responses ->
                  Enum.reduce(prompt_response, responses, fn {question_id, question_response}, responses ->
                    [%{"prompt_id" => prompt_id, "question_id" => question_id, "response" => question_response} | responses]
                  end)
                end)
                %{
                  "type" => "multiple_choice_question_group_responses",
                  "group_id" => question_id,
                  "responses" => responses,
                }

            end
          [normalized_response | acc]
        end)
      end)

    %{"survey_id" => params["survey_id"], "responses" => responses}
  end
end
