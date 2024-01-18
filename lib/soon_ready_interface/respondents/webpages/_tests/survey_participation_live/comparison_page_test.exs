defmodule SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.ComparisonPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReady.SurveyManagement.Commands.PublishOdiSurvey

  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.ScreeningQuestionsPageTest, as: ScreeningPage
  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.ContactDetailsPageTest, as: ContactDetailsPage
  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.DemographicsPageTest, as: DemographicsPage
  alias SoonReadyInterface.Respondents.Webpages.Tests.SurveyParticipationLive.ContextPageTest, as: ContextPage

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
    alternatives_used: "Product 1, Service 2, Platform 3",
    additional_resources_used: "Thing 1, Thing 2",
    amount_spent_annually_in_naira: "1000",
    is_willing_to_pay_more: "Yes",
    extra_amount_willing_to_pay_in_naira: "1000",
  }

  test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their comparison details, THEN: The desired outcome rating page is displayed", %{conn: conn} do
    with {:ok, command} <- PublishOdiSurvey.dispatch(@survey_params),
          {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{command.survey_id}"),
          _ <- LandingPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- ScreeningPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- ContactDetailsPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- DemographicsPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- ContextPage.submit_response(view),
          _ <- assert_patch(view)
    do
      resulting_html = submit_response(view, @form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{command.survey_id}/desired-outcome-ratings"
      assert resulting_html =~ "Desired Outcome Ratings"
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

  def assert_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"comparison_form" => %{
      "alternatives_used" => alternatives_used,
      "additional_resources_used" => additional_resources_used,
      "amount_spent_annually_in_naira" => amount_spent_annually_in_naira,
      "is_willing_to_pay_more" => is_willing_to_pay_more,
      "extra_amount_willing_to_pay_in_naira" => extra_amount_willing_to_pay_in_naira,
    }} = Plug.Conn.Query.decode(query)

    assert alternatives_used == @form_params[:alternatives_used]
    assert additional_resources_used == @form_params[:additional_resources_used]
    assert amount_spent_annually_in_naira == @form_params[:amount_spent_annually_in_naira]
    assert is_willing_to_pay_more == @form_params[:is_willing_to_pay_more]
    assert extra_amount_willing_to_pay_in_naira == @form_params[:extra_amount_willing_to_pay_in_naira]
  end
end