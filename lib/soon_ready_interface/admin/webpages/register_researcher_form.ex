# defmodule SoonReadyInterface.Admin.Webpages.RegisterResearcherForm do
#   use Ash.Resource

#   alias SoonReady.IdentityAndAccessManagement.Commands.InitiateResearcherRegistration

#   attributes do
#     uuid_primary_key :researcher_id
#     attribute :first_name, :string, allow_nil?: false
#     attribute :last_name, :string, allow_nil?: false
#     attribute :username, :string, allow_nil?:  false
#     attribute :password, :string, allow_nil?: false
#     attribute :password_confirmation, :string, allow_nil?: false
#   end

#   actions do
#     create :submit do
#       primary? true

#       change fn changeset, context ->
#         Ash.Changeset.after_action(changeset, fn _changeset, resource ->
#           %{
#             researcher_id: researcher_id,
#             first_name: first_name,
#             last_name: last_name,
#             username: username,
#             password: password,
#             password_confirmation: password_confirmation
#           } = resource

#           params = %{
#             researcher_id: researcher_id,
#             first_name: first_name,
#             last_name: last_name,
#             username: username,
#             password: password,
#             password_confirmation: password_confirmation
#           }

#           with :ok <- InitiateResearcherRegistration.dispatch(params) do
#             {:ok, resource}
#           end
#         end)
#       end
#     end
#   end
# end
