# defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form do
#   use Phoenix.Component
#   import Phoenix.HTML.Form
#   use PhoenixHTMLHelpers


#   attr :is_wide, :boolean, default: false
#   slot :title, required: true
#   slot :subtitle
#   slot :inner_block, required: true

#   def page(assigns) do
#     # TODO: Subtitle will always be passed. Find new way to filter
#     ~H"""
#     <div class={["py-8 lg:py-16 px-4", unless @is_wide do " mx-auto max-w-screen-md" end]}>
#       <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-center text-gray-900 dark:text-white">
#         <%= render_slot(@title) %>
#       </h2>

#       <%= if @subtitle != [] do %>
#         <p class="mb-8 lg:mb-16 font-light text-center text-gray-500 dark:text-gray-400 sm:text-xl">
#           <%= render_slot(@subtitle) %>
#         </p>
#       <% end %>
#       <%= render_slot(@inner_block) %>
#     </div>
#     """
#   end

#   attr :field, Phoenix.HTML.FormField, required: true

#   def errors(assigns) do
#     ~H"""
#     <%= if @field.errors != [] do %>
#       <%= for error <- @field.errors do %>
#         <p class="text-rose-900 dark:text-rose-400"><%= SoonReadyInterface.CoreComponents.translate_error(error) %></p>
#       <% end %>
#     <% end %>
#     """
#   end

#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :label, :string, required: true
#   attr :options, :list, required: true

#   def radio_group(assigns) do
#     ~H"""
#     <div>
#         <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
#           <%= @label %>
#         </label>
#         <div class="space-y-2">
#           <%= for {label, value} <- @options do %>
#             <div class="flex items-center">
#                 <label class="text-sm font-medium text-gray-900 dark:text-gray-300">
#                   <%= radio_button(@field.form, @field.field, value, class: "w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600") %>
#                   <%= label %>
#                 </label>
#             </div>
#           <% end %>
#         </div>
#     </div>
#     """
#   end

#   attr :label, :string, required: true
#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :rest, :global

#   def textarea(assigns) do
#     ~H"""
#     <div>
#       <p class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><%= @label %></p>
#       <%= textarea(@field.form, @field.field, Keyword.new(@rest)) %>
#       <.errors field={@field} />
#     </div>
#     """
#   end

#   attr :label, :string, required: true
#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :rest, :global

#   def number_field(assigns) do
#     ~H"""
#     <div>
#       <p class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><%= @label %></p>
#       <%= number_input(@field.form, @field.field, Keyword.new(@rest)) %>
#       <.errors field={@field} />
#     </div>
#     """
#   end

#   attr :label, :string, required: true
#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :rest, :global

#   def text_field(assigns) do
#     ~H"""
#     <div>
#     <p class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><%= @label %></p>
#     <%= text_input(@field.form, @field.field, Keyword.new(@rest)) %>
#       <.errors field={@field} />
#     </div>
#     """
#   end

#   attr :placeholder, :string, required: true
#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :rest, :global

#   def text_input(assigns) do
#     ~H"""
#     <div>
#       <%= text_input(@field.form, @field.field, [{:placeholder, @placeholder} | Keyword.new(@rest)]) %>
#       <.errors field={@field} />
#     </div>
#     """
#   end

#   slot :inner_block, required: true

#   def submit(assigns) do
#     ~H"""
#     <button name="submit"><%= render_slot(@inner_block) %></button>
#     """
#   end








#   def rating_section(assigns) do
#     ~H"""
#     <div class="h-full w-full text-sm text-left text-gray-500 dark:text-gray-400">
#       <%= render_slot(@inner_block) %>
#     </div>
#     """
#   end

#   attr :questions, :list, required: true


#   attr :desired_outcomes, :list, required: true
#   attr :importance_options, :list, required: true
#   attr :satisfaction_options, :list, required: true
#   slot :importance_prompt, required: true
#   slot :satisfaction_prompt, required: true

#   def rating_section_header(assigns) do

#     # <div class="lg:col-span-3 px-4 lg:px-3 py-4 font-medium text-gray-900 dark:text-gray-200">
#     # <%= render_slot(@importance_prompt) %>
#     # </div>
#     # <div class="lg:col-span-3 px-4 lg:px-3 py-4 font-medium text-gray-900 dark:text-gray-200">
#     # <%= render_slot(@satisfaction_prompt) %>
#     # </div>



#     # <.header_option_labels options={@importance_options} />
#     # <.header_option_labels options={@satisfaction_options} />
#     ~H"""
#     <div class="sticky top-0 text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">

#       <%!-- TODO: Remove the assumption that there will always be 2 question columns --%>
#       <div class="grid grid-cols-2 lg:grid-cols-8 px-2">
#           <div class="hidden lg:block col-span-2 px-6 py-4 font-medium text-gray-900 dark:text-white">
#           </div>
#           <%= for question <- @questions do %>
#             <div class="lg:col-span-3 px-4 lg:px-3 py-4 font-medium text-gray-900 dark:text-gray-200">
#               <%= question.prompt %>
#             </div>
#           <% end %>
#       </div>

#       <div class="hidden break-words lg:grid lg:grid-cols-8 lg:gap-2 px-2 text-center border-b bg-gray-50 dark:bg-gray-800 dark:border-gray-700">
#           <%!-- TODO: Remove the need for this empty div --%>
#           <div class="col-span-2">
#           </div>
#           <%= for question <- @questions do %>
#             <.header_option_labels options={question.options} />
#           <% end %>
#       </div>

#     </div>
#     """
#   end

#   def header_option_labels(assigns) do
#     ~H"""
#     <div class="col-span-3 grid grid-cols-5 px-3">
#         <%= for option <- (Enum.map(@options, &atom_to_sentence_case_string/1)) do %>
#             <div class="py-4">
#                 <%= option %>
#             </div>
#         <% end %>
#     </div>
#     """
#   end

#   # slot :inner_block, required: true

#   def rating_section_body(assigns) do
#     ~H"""
#     <div>
#       <%= render_slot(@inner_block) %>
#     </div>
#     """
#   end

#   attr :desired_outcome, :string, required: true
#   slot :radio_group do
#     attr :field, Phoenix.HTML.FormField, required: true
#     attr :options, :list, required: true
#   end

#   def outcome_rating(assigns) do
#     ~H"""
#     <div class="lg:hidden border-b bg-gray-50 dark:bg-gray-800 dark:border-gray-700">
#         <div class="px-6 py-4">
#             <%= @desired_outcome %>
#         </div>
#     </div>

#     <div class="grid grid-cols-2 px-2 py-2 lg:grid-cols-8 lg:gap-2 bg-white border-b dark:bg-gray-900 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
#       <div class="hidden lg:block col-span-2 px-6 py-4 font-medium text-gray-900 dark:text-white">
#           <%= @desired_outcome %>
#       </div>

#       <%= render_slot(@inner_block) %>

#       <%= for radio_group <- @radio_group do %>
#       <div class="lg:col-span-3 lg:grid lg:items-center px-4 lg:px-0 py-4">
#         <ul class="lg:grid lg:grid-cols-5 px-3 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
#           <%= for option_value <- radio_group.options do %>
#             <.radio_button field={radio_group.field} value={option_value} label={atom_to_sentence_case_string(option_value)} checked={radio_group.field.value == option_value} />
#           <% end %>
#         </ul>

#         <.errors field={radio_group.field} />
#         <%!-- <.error :for={msg <- Enum.map(radio_group.field.errors, &translate_error(&1))}><%= msg %></.error> --%>
#       </div>

#       <% end %>
#     </div>
#     """
#   end

#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :options, :list, required: true
#   def rating_radio_group(assigns) do
#     ~H"""
#     <div class="lg:col-span-3 lg:grid lg:items-center px-4 lg:px-0 py-4">
#       <ul class="lg:grid lg:grid-cols-5 px-3 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
#         <%= for option_value <- @options do %>
#           <.radio_button field={@field} value={option_value} label={atom_to_sentence_case_string(option_value)} checked={@field.value == option_value} />
#         <% end %>
#       </ul>

#       <.errors field={@field} />
#     </div>
#     """
#   end

#   def radio_button(assigns) do
#     ~H"""
#     <li class="w-full border-b border-gray-200 rounded-t-lg dark:border-gray-600">
#         <div class="flex items-center pl-3 lg:pl-0">
#             <input id={"#{@field.id}_#{@value}"} type="radio" value={@value} checked={@checked} name={@field.name} class="w-4 h-4 lg:mx-auto text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500">
#             <label for={"#{@field.id}_#{@value}"} class="lg:hidden w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"><%= @label %></label>
#         </div>
#     </li>
#     """
#   end

#   defp atom_to_sentence_case_string(atom) do
#     atom
#     |> to_string()
#     |> String.replace("_", " ")
#     |> String.capitalize()
#   end
# end
