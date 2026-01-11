defmodule HelloPhoenix.NuvemFiscal.Auth do
  @moduledoc "HTTP client para a API da Nuvem Fiscal"

  require Logger

  alias HelloPhoenix.OAuth.Store

  @store_key :nuvem_fiscal

  ## Public API

  def auth do
    case Store.get(@store_key) do
      {:ok, token_map} ->
        {:ok, token_map}

      {:error, :not_found} ->
        fetch_and_store_token()
    end
  end

  def fetch_and_store_token do
    config = Application.fetch_env!(:hello_phoenix, :nuvem_fiscal)

    req =
      Req.new(
        url: config[:auth_url],
        method: :post,
        headers: [
          {"Content-Type", "application/x-www-form-urlencoded"},
          {"Accept", "application/json"}
        ],
        form: [
          grant_type: config[:grant_type],
          client_id: config[:client_id],
          client_secret: config[:client_secret],
          scope: config[:scope]
        ]
      )

    case Req.request(req) do
      {:ok, %{status: 200, body: token_map}} ->
        Logger.info("[NuvemFiscal.Client] authorized")
        Store.put(@store_key, token_map)
        {:ok, token_map}

      {:ok, %{status: status, body: body}} ->
        Logger.error("[NuvemFiscal.Client] not authorized #{inspect(body, limit: :infinity)}")
        {:error, {:auth_failed, status, body}}

      {:error, reason} ->
        Logger.error("[NuvemFiscal.Client] request error #{inspect(reason, limit: :infinity)}")
        {:error, reason}
    end
  end
end
