defmodule HelloPhoenixWeb.WhatsappController do
  use HelloPhoenixWeb, :controller

  # O Token que você definirá no Painel da Meta
  @verify_token "ReiCientista2026"

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

  # 2. Recepção (POST) - Onde a mensagem cai
  def webhook(conn, params) do
    # Aqui usamos a "petulância" do Elixir para tratar os dados
    # Logando a mensagem para depuração instantânea
    IO.inspect(params, label: "--- INTERFERÊNCIA WHATSAPP DETECTADA ---")

    # TODO: Integrar com sua Arquitetura Cognitiva (Gudwin/Unicamp)
    # Ex: SeuProjeto.Cognition.process_message(params)

    json(conn, %{status: "ok"})
  end
end
