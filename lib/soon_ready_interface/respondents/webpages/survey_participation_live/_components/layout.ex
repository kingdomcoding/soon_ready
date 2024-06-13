# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Layout do
#   use Phoenix.Component

#   slot :icon
#   # TODO: Improve component naming
#   # TODO: Add index attr
#   def accordion(assigns) do
#     ~H"""
#     <h2 id={"accordion-open-heading-#{@index}"}>
#       <button
#         type="button"
#         class={"flex items-center justify-between w-full p-5 font-medium text-left border border-b-0 border-gray-200 #{if @index == 0, do: "rounded-t-xl "}focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-800 dark:border-gray-700 hover:bg-gray-100 dark:hover:bg-gray-800 bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white"}
#         data-accordion-target={"#accordion-open-body-#{@index}"}
#         aria-expanded="true"
#         aria-controls={"accordion-open-body-#{@index}"}
#       >
#         <span class="flex items-center">
#           <%= render_slot(@title) %>
#         </span>
#         <svg
#           data-accordion-icon
#           class="w-6 h-6 rotate-180 shrink-0"
#           fill="currentColor"
#           viewBox="0 0 20 20"
#           xmlns="http://www.w3.org/2000/svg"
#         >
#           <path
#             fill-rule="evenodd"
#             d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
#             clip-rule="evenodd"
#           >
#           </path>
#         </svg>
#       </button>
#     </h2>
#     <div
#       id={"accordion-open-body-#{@index}"}
#       aria-labelledby={"accordion-open-heading-#{@index}"}
#     >
#       <div class="p-5 font-light border border-gray-200 dark:border-gray-700 dark:bg-gray-900">
#         <ul class="text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
#           <%= render_slot(@inner_block) %>
#         </ul>
#       </div>
#     </div>
#     """
#   end
# end
