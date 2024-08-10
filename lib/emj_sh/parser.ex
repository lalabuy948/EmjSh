defmodule EmjSh.Parser do
  def process_file(file_path) do
    File.stream!(file_path)
    |> Stream.filter(&String.contains?(&1, "fully-qualified"))
    |> Stream.map(&process_line/1)
    |> Enum.filter(& &1)
    |> Enum.join(" ")
  end

  defp process_line(line) do
    line
    |> String.trim()
    |> get_emoji_char()
  end

  defp get_emoji_char(line) do
    if String.length(line) >= 79 do
      String.at(line, 79)
    else
      nil
    end
  end
end
