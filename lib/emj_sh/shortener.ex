defmodule EmjSh.Shortener do
  alias EmjSh.Emoji
  alias EmjSh.Short

  @seconds_per_day 86_400
  @days_per_month 30
  @short_len 4

  def shorten(url) do
    short = Emoji.random(@short_len)

    Memento.transaction!(fn ->
      Memento.Query.select(Short, {:==, :url, url})
      |> case do
        [] -> write(short, url)
        [%{short: short} | _] -> short
      end
    end)
  end

  def write(short, url) do
    if exists?(short, url) do
      # should be quite rare, but just in case of collision
      write(Emoji.random(@short_len), url)
    else
      Memento.transaction!(fn ->
        %{short: short} =
          Memento.Query.write(%Short{
            short: short,
            url: url,
            created_at: :os.system_time(:seconds)
          })

        short
      end)
    end
  end

  def get(short) do
    Memento.transaction!(fn ->
      case Memento.Query.read(Short, short) do
        %{url: url} -> url
        _ -> nil
      end
    end)
  end

  def delete_expired do
    Memento.transaction!(fn ->
      Memento.Query.delete(Short, {:<, :created_at, timestamp_one_month_ago()})
    end)
  end

  def exists?(short, url) do
    get(short) == url
  end

  def timestamp_one_month_ago do
    current_time_seconds = :os.system_time(:seconds)
    seconds_in_one_month = @seconds_per_day * @days_per_month

    current_time_seconds - seconds_in_one_month
  end

  def validate_url(url) do
    case URI.parse(url) do
      %URI{scheme: nil} ->
        "is missing a scheme (e.g. https)"

      %URI{scheme: "http"} ->
        "must be https"

      %URI{host: nil} ->
        "is missing a host"

      %URI{host: host} ->
        case :inet.gethostbyname(Kernel.to_charlist(host)) do
          {:ok, _} -> nil
          {:error, _} -> "invalid host"
        end
    end
    |> case do
      error when is_binary(error) -> error
      _ -> :ok
    end
  end
end
