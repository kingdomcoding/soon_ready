# defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.Survey.ContextQuestion do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   attributes do
#     attribute :prompt, :string, allow_nil?: false
#     attribute :options, {:array, :string}, allow_nil?: false, constraints: [min_length: 2]
#   end
# end
