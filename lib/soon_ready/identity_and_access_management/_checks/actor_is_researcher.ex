defmodule SoonReady.IdentityAndAccessManagement.Checks.ActorIsResearcher do
  use Ash.Policy.SimpleCheck

  alias SoonReady.IdentityAndAccessManagement.Resources.User

  def describe(_) do
    "actor is a researcher"
  end

  def match?(%User{is_researcher: true}, _context, _opts) do
    true
  end

  def match?(_actor, _context, _opts) do
    false
  end
end
