# defmodule SoonReady.OutcomeDrivenInnovation.Commands.DefineMarket do
#   use Ash.Resource,
#     data_layer: :embedded

#   alias SoonReady.Application
#   alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.Market

#   attributes do
#     attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :market, Market
#   end

#   actions do
#     defaults [:create, :read]

#     create :dispatch do
#       change fn changeset, context ->
#         Ash.Changeset.after_action(changeset, fn changeset, command ->
#           with :ok <- Application.dispatch(command) do
#             {:ok, command}
#           end
#         end)
#       end
#     end
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :dispatch
#     define :create
#   end
# end
