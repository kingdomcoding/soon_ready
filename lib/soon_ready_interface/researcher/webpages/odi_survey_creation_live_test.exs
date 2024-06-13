# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLiveTest do
#   use SoonReadyInterface.ConnCase
#   import Phoenix.LiveViewTest

#   alias SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
#   alias SoonReadyInterface.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage

#   @timeout 300

#   @landing_page_query_params %{"brand_name" => "Big Brand Co"}
#   @market_definition_query_params %{job_executor: "Person", job_to_be_done: "Do what persons do"}
#   @desired_outcome_query_params %{"job_steps" => %{"0" => %{"name" => "Job Step 1", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}, "1" => %{"name" => "Job Step 2", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}}}
#   @screening_questions_params %{"screening_questions" => %{"0" => %{"prompt" => "Screening Question 1", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}, "1" => %{"prompt" => "Screening Question 2", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}}}
#   @demographic_questions_params %{"demographic_questions" => %{"0" => %{"prompt" => "Demographic Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Demographic Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}}

#   def submit_landing_page_form(view) do
#     view
#     |> form("form", form: @landing_page_query_params)
#     |> put_submitter("button[name=submit]")
#     |> render_submit()
#   end

#   def assert_landing_page_query_params(path) do
#     %{query: query} = URI.parse(path)
#     %{"landing_page_form" => query_params} = Plug.Conn.Query.decode(query)
#     assert query_params == @landing_page_query_params
#   end

#   def submit_market_definition_form(view) do
#     view
#     |> form("form", form: @market_definition_query_params)
#     |> put_submitter("button[name=submit]")
#     |> render_submit()
#   end

#   def assert_market_definition_page_query_params(path) do
#     %{query: query} = URI.parse(path)
#     %{"market_definition_form" => %{
#       "job_executor" => job_executor,
#       "job_to_be_done" => job_to_be_done
#     }} = Plug.Conn.Query.decode(query)
#     assert job_executor == @market_definition_query_params[:job_executor]
#     assert job_to_be_done == @market_definition_query_params[:job_to_be_done]
#   end

#   def add_two_job_steps(view) do
#     view
#     |> element("button", "Add Job Step")
#     |> render_click()

#     view
#     |> element("button", "Add Job Step")
#     |> render_click()
#   end

#   def add_two_desired_outcomes_each(view) do
#     view
#     |> element(~s{button[name="form[job_steps][0]"]}, "Add Desired Outcome")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[job_steps][0]"]}, "Add Desired Outcome")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[job_steps][1]"]}, "Add Desired Outcome")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[job_steps][1]"]}, "Add Desired Outcome")
#     |> render_click()
#   end

#   def submit_desired_outcomes_form(view) do
#     view
#     |> form("form", form: @desired_outcome_query_params)
#     |> put_submitter("button[name=submit]")
#     |> render_submit()
#   end

#   def assert_desired_outcomes_page_query_params(path) do
#     %{query: query} = URI.parse(path)
#     %{"desired_outcomes_form" => query_params} = Plug.Conn.Query.decode(query)
#     assert SoonReady.Utils.is_equal_or_subset?(@desired_outcome_query_params, query_params)
#   end

#   def add_two_screening_questions(view) do
#     view
#     |> element("button", "Add screening question")
#     |> render_click()

#     view
#     |> element("button", "Add screening question")
#     |> render_click()
#   end

#   def add_two_options_each_to_screening_questions(view) do
#     view
#     |> element(~s{button[name="form[screening_questions][0]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[screening_questions][0]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[screening_questions][1]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[screening_questions][1]"]}, "Add option")
#     |> render_click()

#     assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][is_correct_option]"]})
#     assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][value]"]})

#     assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][is_correct_option]"]})
#     assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][value]"]})

#     assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][is_correct_option]"]})
#     assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][value]"]})

#     assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][is_correct_option]"]})
#     assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][value]"]})

#     {:ok, view}
#   end

#   def submit_screeing_questions_form(view) do
#     view
#     |> form("form", form: @screening_questions_params)
#     |> put_submitter("button[name=submit]")
#     |> render_submit()
#   end

#   def assert_screening_questions_page_query_params(path) do
#     %{query: query} = URI.parse(path)
#     %{"screening_questions_form" => query_params} = Plug.Conn.Query.decode(query)
#     assert SoonReady.Utils.is_equal_or_subset?(@screening_questions_params, query_params)
#   end

#   def add_two_demographic_questions(view) do
#     view
#     |> element("button", "Add demographic question")
#     |> render_click()

#     view
#     |> element("button", "Add demographic question")
#     |> render_click()
#   end

#   def add_two_options_each_to_demographic_questions(view) do
#     view
#     |> element(~s{button[name="form[demographic_questions][0]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[demographic_questions][0]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[demographic_questions][1]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[demographic_questions][1]"]}, "Add option")
#     |> render_click()
#   end

#   def submit_demographic_questions_form(view) do
#     view
#     |> form("form", form: @demographic_questions_params)
#     |> put_submitter("button[name=submit]")
#     |> render_submit()
#   end

#   def assert_demographic_questions_page_query_params(path) do
#     %{query: query} = URI.parse(path)
#     %{"demographic_questions_form" => query_params} = Plug.Conn.Query.decode(query)
#     assert SoonReady.Utils.is_equal_or_subset?(@demographic_questions_params, query_params)
#   end

#   def add_two_context_questions(view) do
#     view
#     |> element("button", "Add context question")
#     |> render_click()

#     view
#     |> element("button", "Add context question")
#     |> render_click()
#   end

#   def add_two_options_each_to_context_questions(view) do
#     view
#     |> element(~s{button[name="form[context_questions][0]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[context_questions][0]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[context_questions][1]"]}, "Add option")
#     |> render_click()

#     view
#     |> element(~s{button[name="form[context_questions][1]"]}, "Add option")
#     |> render_click()
#   end

#   def submit_context_questions_form(view) do
#     view
#     |> form("form", form: %{context_questions: %{"0" => %{"prompt" => "Context Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Context Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}})
#     |> put_submitter("button[name=submit]")
#     |> render_submit()
#   end

#   setup %{conn: conn} do
#     params = %{
#       first_name: "John",
#       last_name: "Doe",
#       username: "john.doe",
#       password: "outatime1985",
#       password_confirmation: "outatime1985",
#     }
#     {:ok, %{researcher_id: researcher_id} = command} = SoonReady.IdentityAndAccessManagement.initiate_researcher_registration(params)
#     {:ok, %{user: user}} = SoonReady.IdentityAndAccessManagement.get_researcher(researcher_id)

#     conn =
#       conn
#       |> Phoenix.ConnTest.init_test_session(%{})
#       |> AshAuthentication.Plug.Helpers.store_in_session(user)

#     %{conn: conn}
#   end

#   describe "Landing Page" do
#     test "WHEN: Researcher tries to visit the survey creation url, THEN: The landing page is displayed", %{conn: conn} do
#       {:ok, _view, html} = live(conn, ~p"/odi-survey/create")

#       assert html =~ "Welcome to the ODI Survey Creator!"
#     end

#     test "GIVEN: Researcher has visited the survey creation url, WHEN: Researcher tries to submit a brand name for the survey, THEN: The market definition page is displayed", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")

#       _resulting_html = submit_landing_page_form(view)

#       path = assert_patch(view)
#       assert path =~ ~p"/odi-survey/create/market-definition"
#       assert has_element?(view, "h2", "Market Definition")
#       assert_landing_page_query_params(path)
#     end
#   end

#   describe "Market Definition" do
#     test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to submit market definition details, THEN: The desrired outcomes page is displayed", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)

#       _resulting_html = submit_market_definition_form(view)

#       _market_definition_page_path = assert_patch(view)
#       path = assert_patch(view)
#       assert path =~ ~p"/odi-survey/create/desired-outcomes"
#       assert has_element?(view, "h2", "Desired Outcomes")
#       assert_landing_page_query_params(path)
#       assert_market_definition_page_query_params(path)
#     end
#   end

#   describe "Desired Outcomes" do
#     test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two job steps, THEN: Two job step fields should be on the page", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)

#       resulting_html = add_two_job_steps(view)

#       assert resulting_html =~ "Job Step 1"
#       assert has_element?(view, ~s{input[name="form[job_steps][0][name]"]})
#       assert resulting_html =~ "Job Step 2"
#       assert has_element?(view, ~s{input[name="form[job_steps][1][name]"]})
#     end

#     test "GIVEN: Two job steps have been added, WHEN: Researcher tries to add two desired outcomes each to both job steps, THEN: Two desired outcome fields are added to the first job step", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)

#       _resulting_html = add_two_desired_outcomes_each(view)

#       assert has_element?(view, ~s{input[name="form[job_steps][0][desired_outcomes][0][value]"]})
#       assert has_element?(view, ~s{input[name="form[job_steps][0][desired_outcomes][1][value]"]})
#       assert has_element?(view, ~s{input[name="form[job_steps][1][desired_outcomes][0][value]"]})
#       assert has_element?(view, ~s{input[name="form[job_steps][1][desired_outcomes][1][value]"]})
#     end

#     test "GIVEN: Two desired outcome fields each have been added to two job steps, WHEN: Researcher tries to submit the desired outceoms, THEN: The screening question page is displayed", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)

#       _resulting_html = submit_desired_outcomes_form(view)

#       _market_definition_page_path = assert_patch(view)
#       _desired_outcomes_page_path = assert_patch(view)
#       path = assert_patch(view)
#       assert path =~ ~p"/odi-survey/create/screening-questions"
#       assert has_element?(view, "h2", "Screening Questions")
#       assert_landing_page_query_params(path)
#       assert_market_definition_page_query_params(path)
#       assert_desired_outcomes_page_query_params(path)
#     end
#   end

#   describe "Screening Questions" do
#     test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two screening questions, THEN: Two screening question fields are added", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)

#       _resulting_html = add_two_screening_questions(view)

#       assert has_element?(view, ~s{input[name="form[screening_questions][0][prompt]"]})
#       assert has_element?(view, ~s{input[name="form[screening_questions][1][prompt]"]})
#     end

#     test "GIVEN: Two screening questions have been added, WHEN: Researcher tries to add two options each to the screening questions, THEN: Two options field each are added to the screening questions", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)

#       _resulting_html = add_two_options_each_to_screening_questions(view)

#       assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][is_correct_option]"]})
#       assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][value]"]})

#       assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][is_correct_option]"]})
#       assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][value]"]})

#       assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][is_correct_option]"]})
#       assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][value]"]})

#       assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][is_correct_option]"]})
#       assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][value]"]})
#     end

#     test "GIVEN: Two options each have been added to two screening questions, WHEN: Researcher tries to submit the screening questions, THEN: The demographic questions page is displayed", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)

#       _resulting_html = submit_screeing_questions_form(view)

#       _market_definition_page_path = assert_patch(view)
#       _desired_outcomes_page_path = assert_patch(view)
#       _screening_questions_page_path = assert_patch(view)
#       path = assert_patch(view)
#       assert path =~ ~p"/odi-survey/create/demographic-questions"
#       assert has_element?(view, "h2", "Demographic Questions")
#       assert_screening_questions_page_query_params(path)
#     end
#   end

#   describe "Demographic Questions" do
#     test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two demographic questions, THEN: Two demographic question fields are added", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)
#       submit_screeing_questions_form(view)

#       _resulting_html = add_two_demographic_questions(view)

#       assert has_element?(view, ~s{input[name="form[demographic_questions][0][prompt]"]})
#       assert has_element?(view, ~s{input[name="form[demographic_questions][1][prompt]"]})
#     end

#     test "GIVEN: Two demographic questions have been added, WHEN: Researcher tries to add two options each to the demographic questions, THEN: Two options field each are added to the demographic questions", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)
#       submit_screeing_questions_form(view)
#       add_two_demographic_questions(view)

#       _resulting_html = add_two_options_each_to_demographic_questions(view)

#       assert has_element?(view, ~s{input[name="form[demographic_questions][0][options][0][value]"]})
#       assert has_element?(view, ~s{input[name="form[demographic_questions][0][options][1][value]"]})
#       assert has_element?(view, ~s{input[name="form[demographic_questions][1][options][0][value]"]})
#       assert has_element?(view, ~s{input[name="form[demographic_questions][1][options][1][value]"]})
#     end

#     test "GIVEN: Two options each have been added to two demographic questions, WHEN: Researcher tries to submit the demographic questions, THEN: The context questions page is displayed", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)
#       submit_screeing_questions_form(view)
#       add_two_demographic_questions(view)
#       add_two_options_each_to_demographic_questions(view)

#       _resulting_html = submit_demographic_questions_form(view)

#       _market_definition_page_path = assert_patch(view)
#       _desired_outcomes_page_path = assert_patch(view)
#       _screening_questions_page_path = assert_patch(view)
#       _demographic_questions_page_path = assert_patch(view)
#       path = assert_patch(view)
#       assert path =~ ~p"/odi-survey/create/context-questions"
#       assert has_element?(view, "h2", "Context Questions")
#       assert_landing_page_query_params(path)
#       assert_market_definition_page_query_params(path)
#       assert_desired_outcomes_page_query_params(path)
#       assert_screening_questions_page_query_params(path)
#       assert_demographic_questions_page_query_params(path)
#     end
#   end

#   describe "Context Questions" do
#     test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two context questions, THEN: Two context question fields are added", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)
#       submit_screeing_questions_form(view)
#       add_two_demographic_questions(view)
#       add_two_options_each_to_demographic_questions(view)
#       submit_demographic_questions_form(view)

#       _resulting_html = add_two_context_questions(view)

#       assert has_element?(view, ~s{input[name="form[context_questions][0][prompt]"]})
#       assert has_element?(view, ~s{input[name="form[context_questions][1][prompt]"]})
#     end

#     test "GIVEN: Two context questions have been added, WHEN: Researcher tries to add two options each to the context questions, THEN: Two options field each are added to the context questions", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)
#       submit_screeing_questions_form(view)
#       add_two_demographic_questions(view)
#       add_two_options_each_to_demographic_questions(view)
#       submit_demographic_questions_form(view)
#       add_two_context_questions(view)

#       _resulting_html = add_two_options_each_to_context_questions(view)

#       assert has_element?(view, ~s{input[name="form[context_questions][0][options][0][value]"]})
#       assert has_element?(view, ~s{input[name="form[context_questions][0][options][1][value]"]})
#       assert has_element?(view, ~s{input[name="form[context_questions][1][options][0][value]"]})
#       assert has_element?(view, ~s{input[name="form[context_questions][1][options][1][value]"]})
#     end

#     test "GIVEN: Two options each have been added to two context questions, WHEN: Researcher tries to submit the context questions, THEN: The context questions page is displayed", %{conn: conn} do
#       {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
#       submit_landing_page_form(view)
#       submit_market_definition_form(view)
#       add_two_job_steps(view)
#       add_two_desired_outcomes_each(view)
#       submit_desired_outcomes_form(view)
#       add_two_screening_questions(view)
#       add_two_options_each_to_screening_questions(view)
#       submit_screeing_questions_form(view)
#       add_two_demographic_questions(view)
#       add_two_options_each_to_demographic_questions(view)
#       submit_demographic_questions_form(view)
#       add_two_context_questions(view)
#       add_two_options_each_to_context_questions(view)

#       _resulting_html = submit_context_questions_form(view)

#       _market_definition_page_path = assert_patch(view)
#       _desired_outcomes_page_path = assert_patch(view)
#       _screening_questions_page_path = assert_patch(view)
#       _demographic_questions_page_path = assert_patch(view)
#       _context_questions_page_path = assert_patch(view)

#       flash = assert_redirect(view, ~p"/", @timeout)
#       assert flash == %{"info" => "Survey published successfully!"}
#     end
#   end
# end
