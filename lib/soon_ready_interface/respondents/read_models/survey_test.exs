# defmodule SoonReadyInterface.Respondents.ReadModels.SurveyTest do
#   use SoonReady.DataCase
#   import Commanded.Assertions.EventAssertions

#   alias SoonReady.Application
#   alias SoonReadyInterface.Respondents.ReadModels.Survey
#   alias SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationSucceededV1

#   @survey_params %{
#     brand: "A Big Brand",
#     market: %{
#       job_executor: "Persons",
#       job_to_be_done: "Do what persons do"
#     },
#     job_steps: [
#       %{name: "Job Step 1", desired_outcomes: [
#         "Minimize the time it takes to do A",
#         "Minimize the likelihood that B occurs"
#       ]},
#       %{name: "Job Step 2", desired_outcomes: [
#         "Minimize the time it takes to do C",
#         "Minimize the likelihood that D occurs"
#       ]},
#     ],
#     screening_questions: [
#       %{prompt: "What is the answer to screening question 1?", options: [
#         %{value: "Option 1", is_correct: true},
#         %{value: "Option 2", is_correct: false},
#       ]},
#       %{prompt: "What is the answer to screening question 2?", options: [
#         %{value: "Option 1", is_correct: true},
#         %{value: "Option 2", is_correct: false},
#       ]}
#     ],
#     demographic_questions: [
#       %{prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
#       %{prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
#     ],
#     context_questions: [
#       %{prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
#       %{prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
#     ]
#   }

#   setup do
#     params = %{
#       first_name: "John",
#       last_name: "Doe",
#       username: "john.doe",
#       password: "outatime1985",
#       password_confirmation: "outatime1985",
#     }
#     {:ok, %{researcher_id: researcher_id} = command} = SoonReady.IdentityAndAccessManagement.initiate_researcher_registration(params)
#     {:ok, %{user: user}} = SoonReady.IdentityAndAccessManagement.get_researcher(researcher_id)

#     %{user: user}
#   end

#   test "GIVEN: An ODI survey was created, THEN: The survey is active", %{user: user} do
#     {:ok, %{project_id: project_id}} = SoonReady.OutcomeDrivenInnovation.create_survey(@survey_params, user)

#     assert_receive_event(Application, SurveyCreationSucceededV1,
#       fn event -> event.project_id == project_id end,
#       fn event ->
#         {:ok, survey} = Survey.get_active(event.survey_id)
#         assert survey.id == event.survey_id
#       end
#     )
#   end
# end
