defmodule HelloPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :hello_phoenix,
    adapter: Ecto.Adapters.SQLite3,
    after_connect: {Exqlite.Connection, :configure, [journal_mode: :wal]}
end
