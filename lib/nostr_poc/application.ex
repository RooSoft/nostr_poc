defmodule NostrPoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NostrPocWeb.Telemetry,
      # Start the Ecto repository
      NostrPoc.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NostrPoc.PubSub},
      # Start Finch
      {Finch, name: NostrPoc.Finch},
      # Start the Endpoint (http/https)
      NostrPocWeb.Endpoint,
      # Start a worker by calling: NostrPoc.Worker.start_link(arg)
      # {NostrPoc.Worker, arg}
      Nostr.Client
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NostrPoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NostrPocWeb.Endpoint.config_change(changed, removed)

    configure_nostr()

    :ok
  end

  defp configure_nostr() do
    for relay <- Application.fetch_env!(:nostr_poc, :relays) do
      Nostr.Client.add_relay(relay)
    end
  end
end
