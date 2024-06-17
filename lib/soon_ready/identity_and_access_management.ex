defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Domain

  alias SoonReady.IdentityAndAccessManagement.Commands.InitiateResearcherRegistration

  resources do
    # Aggregates
    resource SoonReady.IdentityAndAccessManagement.Researcher

    # Resources
    resource SoonReady.IdentityAndAccessManagement.Resources.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
    resource SoonReady.IdentityAndAccessManagement.Resources.Researcher

    # Commands
    resource SoonReady.IdentityAndAccessManagement.Commands.InitiateResearcherRegistration
    resource SoonReady.IdentityAndAccessManagement.Commands.MarkResearcherRegistrationAsFailed
    resource SoonReady.IdentityAndAccessManagement.Commands.MarkResearcherRegistrationAsSuccessful

    # Events
    resource SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationFailedV1
    resource SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationInitiatedV1
    resource SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationSucceededV1
  end

  defdelegate initiate_researcher_registration(params), to: InitiateResearcherRegistration, as: :dispatch
  defdelegate get_researcher(researcher_id), to: SoonReady.IdentityAndAccessManagement.Resources.Researcher, as: :get
end
