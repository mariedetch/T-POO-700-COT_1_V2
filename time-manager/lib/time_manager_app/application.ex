defmodule TimeManagement.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimeManagementWeb.Telemetry,
      TimeManagement.Repo,
      {DNSCluster, query: Application.get_env(:time_manager_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TimeManagement.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TimeManagement.Finch},
      # Start a worker by calling: TimeManagement.Worker.start_link(arg)
      # {TimeManagement.Worker, arg},
      # Start to serve requests, typically the last entry
      TimeManagementWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeManagement.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimeManagementWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
