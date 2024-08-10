import EmjSh.Application
alias Memento

nodes = [node()]

if path = Application.get_env(:mnesia, :dir) do
  :ok = File.mkdir_p!(path)
end

Memento.stop()
Memento.Schema.create(nodes)
Memento.start()

Memento.Table.create!(EmjSh.Short, disc_copies: nodes)
