defmodule HelloPhoenix.NuvemFiscal.Client do
  @moduledoc "HTTP client para a API da Nuvem Fiscal"

  require Logger

  alias HelloPhoenix.NuvemFiscal.Auth

  ## Public API

  def new do
    config = Application.fetch_env!(:hello_phoenix, :nuvem_fiscal)

    with {:ok, token_map} <- Auth.auth() do
      {:ok,
       Req.new(
         base_url: config[:api_url],
         headers: [
           {"authorization", "Bearer #{token_map["access_token"]}"},
           {"content-type", "application/json"},
           {"accept", "application/json"}
         ],
         receive_timeout: 30_000
       )}
    end
  end
end
