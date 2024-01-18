defmodule SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.DemographicsPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReady.SurveyManagement.Commands.PublishOdiSurvey

  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.ScreeningQuestionsPageTest, as: ScreeningPage
  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.ContactDetailsPageTest, as: ContactDetailsPage

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
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their demographic details, THEN: The context page is displayed", %{conn: conn} do
    with {:ok, command} <- PublishOdiSurvey.dispatch(@survey_params),
          {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{command.survey_id}"),
          _ <- LandingPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- ScreeningPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- ContactDetailsPage.submit_response(view),
          _ <- assert_patch(view)
    do
      resulting_html = submit_response(view, @form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{command.survey_id}/context"
      assert resulting_html =~ "Context"
      assert_query_params(path)
    else
      {:error, error} ->
        flunk("Error: #{inspect(error)}")
      _ ->
        flunk("An unexpected error occurred")
    end
  end

  def submit_response(view, params \\ @form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params(path, params \\ @form_params) do
    %{query: query} = URI.parse(path)
    %{"demographics_form" => query_params} = Plug.Conn.Query.decode(query)
    assert SoonReady.Utils.is_equal_or_subset?(params, query_params)
  end
end