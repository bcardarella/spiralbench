defmodule Spiralbench.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpiralbenchWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:spiralbench, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Spiralbench.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Spiralbench.Finch},
      # Start a worker by calling: Spiralbench.Worker.start_link(arg)
      # {Spiralbench.Worker, arg},
      # Start to serve requests, typically the last entry
      SpiralbenchWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spiralbench.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpiralbenchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
