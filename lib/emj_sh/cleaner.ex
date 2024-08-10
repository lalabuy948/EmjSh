defmodule EmjSh.Cleaner do
  alias EmjSh.Shortener
  use GenServer

  @four_hours 4 * 60 * 60 * 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    schedule_work()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:work, state) do
    perform_task()
    schedule_work()
    {:noreply, state}
  end

  defp perform_task do
    Shortener.delete_expired()
  end

  defp schedule_work do
    Process.send_after(self(), :work, @four_hours)
  end
end
