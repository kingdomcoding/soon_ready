defmodule SoonReady.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  use Commanded.Application,
    otp_app: :soon_ready,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: SoonReady.EventStore
    ],
    default_dispatch_opts: [
      consistency: Application.get_env(:soon_ready, :consistency, :eventual)
    ]

  router SoonReady.OutcomeDrivenInnovation.ResearchProject
  router SoonReady.SurveyManagement.Survey
  router SoonReady.IdentityAndAccessManagement.Researcher

  router SoonReady.Onboarding.Commands.Router

  @impl true
  def start(_type, _args) do
    children = [
      SoonReadyInterface.Telemetry,
      SoonReady.Repo,
      {DNSCluster, query: Application.get_env(:soon_ready, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SoonReady.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SoonReady.Finch},
      # Start a worker by calling: SoonReady.Worker.start_link(arg)
      # {SoonReady.Worker, arg},
      # Start to serve requests, typically the last entry
      SoonReadyInterface.Endpoint,

      {AshAuthentication.Supervisor, otp_app: :soon_ready},

      # Cloak Encryption
      SoonReady.Vault,

      # Commanded
      __MODULE__,
      SoonReady.Onboarding.Setup.Supervisor,
      SoonReady.OutcomeDrivenInnovation.Supervisor,
      SoonReady.SurveyManagement.Supervisor,
      SoonReady.IdentityAndAccessManagement.Supervisor,

      # SoonReadyInterface.Respondents.Setup.Supervisor,
      # SoonReadyInterface.Researcher.Supervisor,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SoonReady.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SoonReadyInterface.Endpoint.config_change(changed, removed)
    :ok
  end
end
