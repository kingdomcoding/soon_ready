# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form do
#   use Phoenix.Component
#   import Phoenix.HTML.Form
#   use PhoenixHTMLHelpers

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

#   attr :label, :string, required: true
#   attr :field, Phoenix.HTML.FormField, required: true
#   attr :rest, :global

#   def text_field(assigns) do
#     ~H"""
#     <div>
#       <p><%= @label %></p>
#       <%= text_input(@field.form, @field.field, Keyword.new(@rest)) %>
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

#   attr :field, Phoenix.HTML.FormField, required: true

#   def checkbox(assigns) do
#     ~H"""
#     <%= checkbox(@field.form, @field.field) %>
#     """
#   end

#   slot :inner_block, required: true

#   def submit(assigns) do
#     ~H"""
#     <button name="submit"><%= render_slot(@inner_block) %></button>
#     """
#   end

#   attr :rest, :global
#   def thrash_button(assigns) do
#     ~H"""
#     <button type="button" {@rest} class="text-primary-700 border border-primary-700 hover:bg-primary-700 hover:text-white focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm p-2.5 text-center inline-flex items-center dark:border-primary-500 dark:text-primary-500 dark:hover:text-white dark:focus:ring-primary-800 dark:hover:bg-primary-500">
#       <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
#         <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14m-9 3v8m4-8v8M10 3h4a1 1 0 0 1 1 1v3H9V4a1 1 0 0 1 1-1ZM6 7h12v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7Z"/>
#       </svg>
#       <span class="sr-only"><%= render_slot(@inner_block) %></span>
#     </button>
#     """
#   end

#   slot :title, required: true
#   slot :thrash_button, required: true
#   slot :text_input, required: true
#   def card_header(assigns) do
#     ~H"""
#     <div class="flex justify-between my-2">
#       <h3 class="text-lg font-semibold items-center"><%= render_slot(@title) %></h3>

#       <%= for button <- @thrash_button do %>
#         <.thrash_button phx-click={button.click} phx-value-name={button.name} phx-target={button.target}>
#           <%= render_slot(button) %>
#         </.thrash_button>
#       <% end %>
#     </div>

#     <%= for text_input <- @text_input do %>
#       <.text_input
#         field={text_input.field}
#         placeholder={text_input.placeholder}
#         class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
#       />
#     <% end %>
#     """
#   end

#   attr :rest, :global
#   slot :checkbox
#   slot :text_input, required: true
#   slot :thrash_button, required: true
#   def card_field(assigns) do
#     ~H"""
#     <div class="flex justify-between">
#       <%= for checkbox <- @checkbox do %>
#         <.checkbox field={checkbox.field} />
#       <% end %>
#       <%= for text_input <- @text_input do %>
#         <%= text_input(text_input.field.form, text_input.field.field, [
#           {:placeholder, text_input.placeholder},
#           {:class, "block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"}
#           | Keyword.new(@rest)])
#         %>
#       <% end %>

#       <%= for button <- @thrash_button do %>
#         <.thrash_button phx-click={button.click} phx-value-name={button.name} phx-target={button.target}>
#           <%= render_slot(button) %>
#         </.thrash_button>
#       <% end %>
#     </div>

#     <%= for text_input <- @text_input do %>
#       <.errors field={text_input.field} />
#     <% end %>
#     """
#   end

#   slot :header, required: true
#   slot :body, required: true
#   slot :add_button, required: true
#   def card(assigns) do
#     ~H"""
#     <div class="w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800">
#       <div class="p-4 lg:p-8">
#         <%= render_slot(@header) %>
#       </div>
#       <hr>
#       <div class="p-4 lg:p-8 flex flex-col gap-2">
#         <%= render_slot(@body) %>

#         <%= for button <- @add_button do %>
#           <button name={button.name} phx-click={button.action} phx-target={button.target} phx-value-name={button.name} type="button" class="p-2 text-primary-600 hover:underline hover:border-primary-500 rounded-lg border border-gray-300 shadow-sm">
#             <%= render_slot(button) %>
#           </button>
#           <.errors field={button.field} />
#         <% end %>
#       </div>
#     </div>
#     """
#   end

#   attr :form_field, :atom, required: true
#   attr :target, :any
#   attr :rest, :global
#   slot :add_button, required: true
#   slot :submit, required: true

#   def card_form(assigns) do
#     ~H"""
#     <.form :let={f} phx-target={@target} {@rest}>
#       <div class="flex gap-4">
#         <%= render_slot(@inner_block, f) %>

#         <div>
#           <%= for button <- @add_button do %>
#             <button class="text-primary-600 hover:underline mb-auto p-4 lg:p-8 w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800" type="button" phx-click={button.action} phx-target={@target}>
#               <%= render_slot(button) %>
#             </button>
#             <.errors field={f[button.form_field]} />
#           <% end %>
#         </div>
#       </div>

#       <button type="submit" name="submit" class="w-full mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
#         <%= render_slot(@submit) %>
#       </button>
#     </.form>
#     """
#   end

# end
