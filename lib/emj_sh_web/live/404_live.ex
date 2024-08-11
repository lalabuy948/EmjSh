defmodule EmjShWeb.NotFoundLive do
  use EmjShWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="bg-white flex items-center justify-center min-h-screen">
      <div class="bg-white p-6 text-center">
        <h1 class="mb-9 bg-gradient-to-r from-fuchsia-500 to-cyan-500 bg-clip-text text-3xl font-extrabold text-transparent sm:text-5xl">
          404 <br />
          <a href="/" class="text-xs mt-1">home 🔙</a>
        </h1>
      </div>
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
    {:ok, socket}
  end
end
