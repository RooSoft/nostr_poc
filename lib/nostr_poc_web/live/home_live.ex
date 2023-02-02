defmodule NostrPocWeb.HomeLive do
  use NostrPocWeb, :live_view
  require Logger

  @event_topic "event"
  @pubkey <<0xEFC83F01C8FB309DF2C8866B8C7924CC8B6F0580AFDDE1D6E16E2B6107C2862C::256>>

  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, {:ok, subscription_pid}} = Nostr.Client.subscribe_profile(@pubkey)

    IO.inspect("IN HOME LIVE")

    {
      :ok,
      socket
      |> Map.put(:subscription_pid, subscription_pid)
      |> assign(:profile, nil)
    }
  end

  @impl true
  def handle_info(event, %{subscription_pid: subscription_pid} = socket) do
    Nostr.Client.unsubscribe(subscription_pid)
    |> IO.inspect(label: "unsubscription result")

    {
      :noreply,
      socket
      |> assign(:profile, event)
    }
  end
end
