# defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.Survey.HashedParticipant do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   attributes do
#     attribute :nickname_hash, :string, allow_nil?: false
#     attribute :email_hash, :string, allow_nil?: false
#     attribute :phone_number_hash, :string, allow_nil?: false
#   end

#   actions do
#     defaults [:create, :read]
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :create
#   end
# end
