defmodule SoonReady.SurveyManagement.V1.DomainConcepts.Option do
  alias SoonReady.SurveyManagement.V1.DomainConcepts.OptionWithCorrectFlag

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    # TODO: Change from raw ci_string
    {:ci_string, [type: :ci_string]},
    {OptionWithCorrectFlag, [type: OptionWithCorrectFlag, tag: :type, tag_value: "option_with_correct_flag"]},
  ]]
end
