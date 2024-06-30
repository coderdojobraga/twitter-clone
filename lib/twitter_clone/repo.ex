defmodule TwitterClone.Repo do
  use Ecto.Repo,
    otp_app: :twitter_clone,
    adapter: Ecto.Adapters.Postgres
end
