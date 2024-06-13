# defmodule SoonReadyInterface.Public.Webpages.HomepageLive do
#   use SoonReadyInterface, :live_view

#   alias SoonReady.Onboarding.Commands.JoinWaitlist

#   def mount(_params, _session, socket) do
#     form =  AshPhoenix.Form.for_create(JoinWaitlist, :create, api: SoonReady.Onboarding.Setup.Api)
#     {:ok, assign(socket, :form, form)}
#   end

#   def local_header(assigns) do
#     ~H"""
#     <header>
#       <nav class="bg-white border-gray-200 px-4 lg:px-6 py-4 dark:bg-gray-800">
#         <div class="flex flex-wrap justify-center items-center mx-auto max-w-screen-xl">
#           <a href={~p"/"} class="flex items-center">
#             <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">😎 SoonReady</span>
#           </a>
#         </div>
#       </nav>
#     </header>
#     """
#   end

#   slot :waitlist_form, required: true

#   def hero(assigns) do
#     ~H"""
#     <section class="px-4 lg:px-16 text-center lg:text-left">
#       <div class="grid max-w-screen-xl px-4 py-8 mx-auto lg:gap-12 xl:gap-0 lg:py-16 lg:grid-cols-12">
#         <div class="mr-auto place-self-center lg:col-span-7 xl:col-span-8">
#           <h1 class="max-w-2xl mb-4 text-4xl font-extrabold tracking-tight leading-none md:text-5xl xl:text-6xl dark:text-white">
#             Building the future, one product launch at a time...
#           </h1>
#           <p class="max-w-2xl mb-6 font-light text-gray-500 lg:mb-8 md:text-lg lg:text-xl dark:text-gray-400">
#             SoonReady is home for innovators who are on the journey to launch successful products and services. Join other innovators on our waitlist.
#           </p>
#           <%= render_slot(@waitlist_form) %>
#         </div>
#         <div class="lg:mt-0 lg:col-span-5 xl:col-span-4 lg:flex">
#           <img src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/hero/mobile-app.svg" alt="phone illustration">
#         </div>
#       </div>
#     </section>
#     """
#   end

#   attr :field, Phoenix.HTML.FormField, required: true

#   def email_input(assigns) do
#     assigns = assign(assigns, :errors, Enum.map(assigns.field.errors, &translate_error(&1)))
#     ~H"""
#     <input
#       id={@field.id}
#       name={@field.name}
#       type="text"
#       inputmode="email"
#       value={@field.value}
#       class={[
#         "block md:w-96 w-full p-3 text-sm text-gray-900",
#         "border border-gray-300 rounded-lg bg-gray-50 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600",
#         "dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 text-center lg:text-left",
#         @errors != [] && "border-rose-400 dark:border-rose-400 focus:border-rose-400"

#       ]}
#       placeholder="Provide your email to get updates..."
#     >
#     """
#   end

#   attr :field, Phoenix.HTML.FormField, required: true

#   def error_message(assigns) do
#     assigns = assign(assigns, :errors, Enum.map(assigns.field.errors, &translate_error(&1)))
#     ~H"""
#     <.error :for={msg <- @errors}><%= msg %></.error>
#     """
#   end

#   def render(assigns) do
#     ~H"""
#     <.local_header />
#     <.hero>
#       <:waitlist_form>
#         <.form :let={f} for={@form} phx-change="validate" phx-submit="submit">
#           <div class="flex flex-wrap lg:flex-nowrap items-center mb-3">
#             <div class="relative w-full lg:w-auto mb-3 lg:mb-0 lg:mr-3">
#               <label for="member_email" class="hidden mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Email address</label>
#               <.email_input field={f[:email]} />
#               <div class="lg:hidden">
#                 <.error_message field={f[:email]} />
#               </div>
#             </div>
#             <div class="w-full lg:w-auto">
#               <input type="submit" value="Join our waitlist" class="w-full px-5 py-3 text-sm font-medium text-center text-white rounded-lg cursor-pointer bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800" name="member_submit" id="member_submit">
#             </div>
#           </div>
#           <div class="hidden lg:block">
#             <.error_message field={f[:email]} />
#           </div>
#         </.form>
#       </:waitlist_form>
#     </.hero>
#     """
#   end

#   def handle_event("validate", %{"form" => form_data}, socket) do
#     validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_data, errors: socket.assigns.form.errors || false)
#     {:noreply, assign(socket, form: validated_form)}
#   end

#   def handle_event("submit", %{"form" => form_data}, socket) do
#     validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_data, errors: socket.assigns.form.errors || false)

#     case AshPhoenix.Form.submit(validated_form) do
#       {:ok, join_waitlist_command} ->
#         case SoonReady.Application.dispatch(join_waitlist_command) do
#           :ok ->
#             socket =
#               socket
#               |> put_flash(:info, "Awesome! You've joined other innovators on our waitlist 😎")
#               |> redirect(to: ~p"/")
#             {:noreply, socket}
#           {:error, _error} ->
#             socket =
#               socket
#               |> assign(form: validated_form)
#               |> put_flash(:error, "Oops! Some error stopped us from adding you to our waitlist. Please contact our administrators.")
#             {:noreply, socket}
#         end
#       {:error, form_with_errors} ->
#         {:noreply, assign(socket, form: form_with_errors)}
#     end
#   end
# end
