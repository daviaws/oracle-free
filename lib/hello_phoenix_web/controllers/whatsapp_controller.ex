defmodule HelloPhoenixWeb.WhatsappController do
  use HelloPhoenixWeb, :controller

  # O Token que você definirá no Painel da Meta
  @verify_token "ReiCientista2026"

  alias HelloPhoenix.Job.ReceiveWhatsappMessage

  require Logger

  # 1. Validação (GET) - O "aperto de mão" da Meta
  def verify(conn, %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => token,
        "hub.challenge" => challenge
      }) do
    if token == @verify_token do
      send_resp(conn, 200, challenge)
    else
      send_resp(conn, 403, "Forbidden")
    end
  end

  # 2. Recepção da mensagem (POST)
  def webhook(conn, params) do
    Logger.info("Received Whatsapp Message! Enqueuing job.")

    ReceiveWhatsappMessage.new(params)
    |> Oban.insert!()

    json(conn, %{status: "ok"})
  end
end
