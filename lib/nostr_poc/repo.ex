defmodule NostrPoc.Repo do
  use Ecto.Repo,
    otp_app: :nostr_poc,
    adapter: Ecto.Adapters.SQLite3
end
