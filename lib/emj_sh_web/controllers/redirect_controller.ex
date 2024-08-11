defmodule EmjShWeb.RedirectController do
  use EmjShWeb, :controller
  alias EmjSh.Shortener

  def handle(conn, %{"short" => value}) do
    case Shortener.get(value) do
      nil -> redirect(conn, to: "/404")
      url -> redirect(conn, external: url)
    end
  end
end
