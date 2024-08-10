defmodule EmjShWeb.IndexLive do
  use EmjShWeb, :live_view
  alias EmjSh.Shortener

  def render(assigns) do
    ~H"""
    <div class="bg-white flex items-center justify-center min-h-screen">
      <div class="bg-white p-6">
        <h1 class="mb-9 bg-gradient-to-r from-fuchsia-500 to-cyan-500 bg-clip-text text-3xl font-extrabold text-transparent sm:text-5xl">
          Emoji <br /> Shortener
        </h1>

        <div class="flex items-center space-x-2 mb-2">
          <form phx-change="validate" phx-submit="submit">
            <input
              type="url"
              placeholder="https://..."
              value={@url}
              name="input_url"
              class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <button class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">
              ➡️
            </button>
          </form>
        </div>
        <%= if @error do %>
          <p id="errorMessage" class="text-red-500 text-xs mt-1"><%= @error %></p>
        <% end %>

        <%= if @short do %>
          <div class="flex items-center space-x-2 mb-2">
            <input
              type="url"
              id="short-url"
              value={@short}
              class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              disabled
            />

            <button
              id="copy"
              data-to="#short-url"
              phx-hook="Copy"
              class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              📋
            </button>
          </div>
        <% end %>
      </div>
    </div>

    <div class="fixed bottom-4 right-4">
      <button id="btn-confetti" class="btn btn-circle" phx-hook="Confetti">🎉</button>
    </div>

    <div class="fixed bottom-4 left-4">
      <a href="https://x.com/mrpopov_com" target="_blank" rel="noopener noreferrer" class="group">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="28"
          height="28"
          viewBox="0 0 72 72"
          fill="none"
          class="transition-colors duration-300 group-hover:fill-blue-500"
        >
          <path
            d="M40.7568 32.1716L59.3704 11H54.9596L38.7974 29.383L25.8887 11H11L30.5205 38.7983L11 61H15.4111L32.4788 41.5869L46.1113 61H61L40.7557 32.1716H40.7568ZM34.7152 39.0433L32.7374 36.2752L17.0005 14.2492H23.7756L36.4755 32.0249L38.4533 34.7929L54.9617 57.8986H48.1865L34.7152 39.0443V39.0433Z"
            fill="#111827"
          />
        </svg>
      </a>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    assigns = [
      url: "",
      short: nil,
      error: nil
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_params(_unsigned_params, uri, socket),
    do: {:noreply, assign(socket, uri: uri)}

  def handle_event("validate", %{"input_url" => value}, socket) do
    case Shortener.validate_url(value) do
      :ok -> {:noreply, assign(socket, url: value, error: nil)}
      error -> {:noreply, assign(socket, :error, error)}
    end
  end

  def handle_event("submit", %{"input_url" => value}, socket) do
    case Shortener.validate_url(value) do
      :ok ->
        {:noreply,
         assign(socket,
           url: value,
           error: nil,
           short: socket.assigns.uri <> Shortener.shorten(value)
         )}

      error ->
        {:noreply, assign(socket, :error, error)}
    end
  end
end
