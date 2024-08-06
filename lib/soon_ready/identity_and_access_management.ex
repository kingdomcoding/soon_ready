defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Domain

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher

  resources do
    # Aggregates
    resource SoonReady.IdentityAndAccessManagement.Researcher

    # Resources
    resource SoonReady.IdentityAndAccessManagement.Resources.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
    resource SoonReady.IdentityAndAccessManagement.Resources.Researcher

    # Commands
    resource SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher do
      define :initiate_researcher_registration, action: :dispatch
    end

    # DomainEvents
    resource SoonReady.IdentityAndAccessManagement.Events.V1.ResearcherRegistered
  end
end
