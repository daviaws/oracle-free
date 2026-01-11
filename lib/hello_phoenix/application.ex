defmodule HelloPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    HelloPhoenix.OAuth.Store.open()

    children = [
      HelloPhoenixWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:hello_phoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloPhoenix.PubSub},
      # Start a worker by calling: HelloPhoenix.Worker.start_link(arg)
      # {HelloPhoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      HelloPhoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
