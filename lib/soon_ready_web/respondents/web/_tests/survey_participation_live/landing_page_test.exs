defmodule SoonReadyWeb.Respondents.Web.Tests.SurveyParticipationLive.LandingPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReady.SurveyManagement.UseCases
  alias SoonReady.SurveyManagement.ValueObjects.OdiSurveyData

  @survey_params %{
    brand: "A Big Brand",
    market: %{
      job_executor: "Persons",
      job_to_be_done: "Do what persons do"
    },
    job_steps: [
      %{name: "Job Step 1", desired_outcomes: [
        "Minimize the time it takes to do A",
        "Minimize the likelihood that B occurs"
      ]},
      %{name: "Job Step 2", desired_outcomes: [
        "Minimize the time it takes to do C",
        "Minimize the likelihood that D occurs"
      ]},
    ],
    screening_questions: [
      %{prompt: "What is the answer to screening question 1?", options: [
        %{value: "Option 1", is_correct: true},
        %{value: "Option 2", is_correct: false},
      ]},
      %{prompt: "What is the answer to screening question 2?", options: [
        %{value: "Option 1", is_correct: true},
        %{value: "Option 2", is_correct: false},
      ]}
    ],
    demographic_questions: [
      %{prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
      %{prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
    ],
    context_questions: [
      %{prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
      %{prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
    ]
  }

  @form_params %{
    nickname: "A Nickname"
  }

  describe "happy path" do
    test "GIVEN: Survey has been published, WHEN: Respondent tries to visit the survey participation url, THEN: The landing page is displayed", %{conn: conn} do
      with {:ok, odi_survey_data} <- OdiSurveyData.new(@survey_params),
            {:ok, use_case_data} <- UseCases.publish_odi_survey(odi_survey_data)
      do
        {:ok, _view, html} = live(conn, ~p"/survey/participate/#{use_case_data.survey_id}")

        assert html =~ "Welcome to our Survey!"
      else
        {:error, error} ->
          flunk("Error publishing survey: #{inspect(error)}")
      end
    end

    test "GIVEN: Respondent has visited the survey participation url, WHEN: Respondent tries to submit a nickname, THEN: The screening questions page is displayed", %{conn: conn} do

      with {:ok, odi_survey_data} <- OdiSurveyData.new(@survey_params),
            {:ok, use_case_data} <- UseCases.publish_odi_survey(odi_survey_data),
            {:ok, view, _html} = live(conn, ~p"/survey/participate/#{use_case_data.survey_id}")
      do
        resulting_html = submit_form(view)

        path = assert_patch(view)
        assert path =~ "/survey/participate/#{use_case_data.survey_id}/screening-questions"
        assert resulting_html =~ "Screening Questions"
        assert_query_params(path)
      else
        {:error, error} ->
          flunk("Error publishing survey: #{inspect(error)}")
      end
    end
  end

  def submit_form(view) do
    view
    |> form("form", form: @form_params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"nickname_form" => %{"nickname" => nickname}} = Plug.Conn.Query.decode(query)
    assert nickname == @form_params[:nickname]
  end
end