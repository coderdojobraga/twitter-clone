defmodule TwitterClone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TwitterCloneWeb.Telemetry,
      TwitterClone.Repo,
      {DNSCluster, query: Application.get_env(:twitter_clone, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TwitterClone.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TwitterClone.Finch},
      # Start a worker by calling: TwitterClone.Worker.start_link(arg)
      # {TwitterClone.Worker, arg},
      # Start to serve requests, typically the last entry
      TwitterCloneWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterClone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TwitterCloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
