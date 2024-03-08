defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLiveTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage
  alias SoonReadyInterface.OdiSurveyCreationLive.DesiredOutcomesPageTest, as: DesiredOutcomesPage

  describe "Screening Questions" do
    @screening_questions_params %{"screening_questions" => %{"0" => %{"prompt" => "Screening Question 1", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}, "1" => %{"prompt" => "Screening Question 2", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}}}

    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two screening questions, THEN: Two screening question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)

      _resulting_html = add_two_screening_questions(view)

      assert has_element?(view, ~s{input[name="form[screening_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][prompt]"]})
    end

    test "GIVEN: Two screening questions have been added, WHEN: Researcher tries to add two options each to the screening questions, THEN: Two options field each are added to the screening questions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)

      _resulting_html = add_two_options_each_to_screening_questions(view)

      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][value]"]})
    end

    test "GIVEN: Two options each have been added to two screening questions, WHEN: Researcher tries to submit the screening questions, THEN: The demographic questions page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)

      _resulting_html = submit_screeing_questions_form(view)

      _market_definition_page_path = assert_patch(view)
      _desired_outcomes_page_path = assert_patch(view)
      _screening_questions_page_path = assert_patch(view)
      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/demographic-questions"
      assert has_element?(view, "h2", "Demographic Questions")
      LandingPage.assert_query_params(path)
      MarketDefinitionPage.assert_query_params(path)
      DesiredOutcomesPage.assert_query_params(path)
      assert_screening_questions_page_query_params(path)
    end

    def add_two_screening_questions(view) do
      view
      |> element("button", "Add screening question")
      |> render_click()

      view
      |> element("button", "Add screening question")
      |> render_click()
    end

    def add_two_options_each_to_screening_questions(view) do
      view
      |> element(~s{button[name="form[screening_questions][0]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[screening_questions][0]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[screening_questions][1]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[screening_questions][1]"]}, "Add option")
      |> render_click()

      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][value]"]})

      {:ok, view}
    end

    def submit_screeing_questions_form(view) do
      view
      |> form("form", form: @screening_questions_params)
      |> put_submitter("button[name=submit]")
      |> render_submit()
    end

    def assert_screening_questions_page_query_params(path) do
      %{query: query} = URI.parse(path)
      %{"screening_questions_form" => query_params} = Plug.Conn.Query.decode(query)
      assert SoonReady.Utils.is_equal_or_subset?(@screening_questions_params, query_params)
    end
  end

  describe "Demographic Questions" do
    @demographic_questions_params %{"demographic_questions" => %{"0" => %{"prompt" => "Demographic Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Demographic Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}}

    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two demographic questions, THEN: Two demographic question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)
      submit_screeing_questions_form(view)

      _resulting_html = add_two_demographic_questions(view)

      assert has_element?(view, ~s{input[name="form[demographic_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][1][prompt]"]})
    end

    test "GIVEN: Two demographic questions have been added, WHEN: Researcher tries to add two options each to the demographic questions, THEN: Two options field each are added to the demographic questions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)
      submit_screeing_questions_form(view)
      add_two_demographic_questions(view)

      _resulting_html = add_two_options_each_to_demographic_questions(view)

      assert has_element?(view, ~s{input[name="form[demographic_questions][0][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][0][options][1][value]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][1][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][1][options][1][value]"]})
    end

    test "GIVEN: Two options each have been added to two demographic questions, WHEN: Researcher tries to submit the demographic questions, THEN: The context questions page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)
      submit_screeing_questions_form(view)
      add_two_demographic_questions(view)
      add_two_options_each_to_demographic_questions(view)

      _resulting_html = submit_demographic_questions_form(view)

      _market_definition_page_path = assert_patch(view)
      _desired_outcomes_page_path = assert_patch(view)
      _screening_questions_page_path = assert_patch(view)
      _demographic_questions_page_path = assert_patch(view)
      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/context-questions"
      assert has_element?(view, "h2", "Context Questions")
      LandingPage.assert_query_params(path)
      MarketDefinitionPage.assert_query_params(path)
      DesiredOutcomesPage.assert_query_params(path)
      assert_screening_questions_page_query_params(path)
      assert_demographic_questions_page_query_params(path)
    end

    def add_two_demographic_questions(view) do
      view
      |> element("button", "Add demographic question")
      |> render_click()

      view
      |> element("button", "Add demographic question")
      |> render_click()
    end

    def add_two_options_each_to_demographic_questions(view) do
      view
      |> element(~s{button[name="form[demographic_questions][0]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[demographic_questions][0]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[demographic_questions][1]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[demographic_questions][1]"]}, "Add option")
      |> render_click()
    end

    def submit_demographic_questions_form(view) do
      view
      |> form("form", form: @demographic_questions_params)
      |> put_submitter("button[name=submit]")
      |> render_submit()
    end

    def assert_demographic_questions_page_query_params(path) do
      %{query: query} = URI.parse(path)
      %{"demographic_questions_form" => query_params} = Plug.Conn.Query.decode(query)
      assert SoonReady.Utils.is_equal_or_subset?(@demographic_questions_params, query_params)
    end
  end

  describe "Context Questions" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two context questions, THEN: Two context question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)
      submit_screeing_questions_form(view)
      add_two_demographic_questions(view)
      add_two_options_each_to_demographic_questions(view)
      submit_demographic_questions_form(view)

      _resulting_html = add_two_context_questions(view)

      assert has_element?(view, ~s{input[name="form[context_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][1][prompt]"]})
    end

    test "GIVEN: Two context questions have been added, WHEN: Researcher tries to add two options each to the context questions, THEN: Two options field each are added to the context questions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)
      submit_screeing_questions_form(view)
      add_two_demographic_questions(view)
      add_two_options_each_to_demographic_questions(view)
      submit_demographic_questions_form(view)
      add_two_context_questions(view)

      _resulting_html = add_two_options_each_to_context_questions(view)

      assert has_element?(view, ~s{input[name="form[context_questions][0][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][0][options][1][value]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][1][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][1][options][1][value]"]})
    end

    test "GIVEN: Two options each have been added to two context questions, WHEN: Researcher tries to submit the context questions, THEN: The context questions page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each_to_screening_questions(view)
      submit_screeing_questions_form(view)
      add_two_demographic_questions(view)
      add_two_options_each_to_demographic_questions(view)
      submit_demographic_questions_form(view)
      add_two_context_questions(view)
      add_two_options_each_to_context_questions(view)

      _resulting_html = submit_context_questions_form(view)

      flash = assert_redirect(view, ~p"/")
      assert flash == %{"info" => "Survey published successfully!"}
    end

    def add_two_context_questions(view) do
      view
      |> element("button", "Add context question")
      |> render_click()

      view
      |> element("button", "Add context question")
      |> render_click()
    end

    def add_two_options_each_to_context_questions(view) do
      view
      |> element(~s{button[name="form[context_questions][0]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[context_questions][0]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[context_questions][1]"]}, "Add option")
      |> render_click()

      view
      |> element(~s{button[name="form[context_questions][1]"]}, "Add option")
      |> render_click()
    end

    def submit_context_questions_form(view) do
      view
      |> form("form", form: %{context_questions: %{"0" => %{"prompt" => "Context Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Context Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}})
      |> put_submitter("button[name=submit]")
      |> render_submit()
    end
  end
end