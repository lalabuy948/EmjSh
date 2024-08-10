defmodule EmjShWeb.RedirectController do
  use EmjShWeb, :controller
  alias EmjSh.Shortener

  def handle(conn, %{"short" => value}) do
    url = Shortener.get(value)

    # json(conn, %{emj: url})
    redirect(conn, external: url)
  end
end
