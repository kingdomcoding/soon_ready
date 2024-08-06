defmodule SoonReadyInterface.Router do
  use SoonReadyInterface, :router
  use AshAuthentication.Phoenix.Router

  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SoonReadyInterface.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
    plug SoonReadyInterface.Common.Plugs.ReturnToPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", SoonReadyInterface.Public.Webpages do
    pipe_through :browser

    sign_in_route()
    sign_out_route AuthController
    auth_routes_for SoonReady.IdentityAndAccessManagement.Resources.User, to: AuthController
    reset_route []
  end

  scope "/", SoonReadyInterface.Public.Webpages do
    pipe_through :browser

    live "/", HomepageLive, :home
  end

  ash_authentication_live_session :researcher_session do
    scope "/", SoonReadyInterface.Researcher.Webpages do
      pipe_through :browser

      live "/odi-survey/create/context-questions", OdiSurveyCreationLive, :context_questions_page
      live "/odi-survey/create/demographic-questions", OdiSurveyCreationLive, :demographic_questions_page
      live "/odi-survey/create/screening-questions", OdiSurveyCreationLive, :screening_questions_page
      live "/odi-survey/create/desired-outcomes", OdiSurveyCreationLive, :desired_outcomes_page
      live "/odi-survey/create/market-definition", OdiSurveyCreationLive, :market_definition_page
      live "/odi-survey/create", OdiSurveyCreationLive, :landing_page
    end
  end

  scope "/", SoonReadyInterface.Respondents.Webpages do
    pipe_through :browser

    live "/survey/participate/:survey_id", SurveyParticipationLive
    live "/survey/participate/:survey_id/pages/:page_id", SurveyParticipationLive
  end

  scope "/secret-admin", SoonReadyInterface.Admin.Webpages do
    pipe_through :browser

    live "register-researcher", ResearcherRegistrationLive
  end


  # Other scopes may use custom stacks.
  # scope "/api", SoonReadyInterface do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:soon_ready, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SoonReadyInterface.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
