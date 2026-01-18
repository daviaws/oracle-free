defmodule HelloPhoenix.Job.ReceiveWhatsappMessage do
  use Oban.Worker,
    queue: :default,
    max_attempts: 3,
    unique: true

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    IO.puts("--- [Job.ReceiveWhatsappMessage] Received Message: #{inspect(args, pretty: true, limit: :infinity)} ---")

    :ok
  end
end
