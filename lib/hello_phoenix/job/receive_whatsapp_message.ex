defmodule HelloPhoenix.Job.ReceiveWhatsappMessage do
  use Oban.Worker,
    queue: :default,
    max_attempts: 3,
    unique: true

  alias HelloPhoenix.Repo
  alias HelloPhoenix.Whatsapp.Message

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args, inserted_at: inserted_at}) do
    Logger.info("[Job.ReceiveWhatsappMessage] Received Message ---")

    Message.parse(args, inserted_at)
    |> result()
  end

  defp result({:ok, message}), do: Repo.insert(message)
  defp result({:error, error}), do: {:discard, error}
end
