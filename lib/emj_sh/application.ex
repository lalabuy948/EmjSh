defmodule EmjSh.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias EmjSh.Cleaner

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EmjShWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:emj_sh, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EmjSh.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EmjSh.Finch},
      # Start a worker by calling: EmjSh.Worker.start_link(arg)
      # {EmjSh.Worker, arg},
      # Start to serve requests, typically the last entry
      EmjShWeb.Endpoint,
      Cleaner
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EmjSh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EmjShWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def init_mnesia(nodes \\ [node()]) do
    if path = Application.get_env(:mnesia, :dir) do
      :ok = File.mkdir_p!(path)
    end

    Memento.stop()
    Memento.Schema.create(nodes)
    Memento.start()

    Memento.Table.create!(EmjSh.Short, disc_copies: nodes)
  end
end
