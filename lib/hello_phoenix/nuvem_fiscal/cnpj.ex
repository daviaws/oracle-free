defmodule HelloPhoenix.NuvemFiscal.Cnpj do
  require Logger

  alias HelloPhoenix.NuvemFiscal.Client

  # Public API

  def get(cnpj) when is_binary(cnpj) do
    with {:ok, req} <- Client.new(),
         {:ok, %{status: 200, body: body}} <-
           Req.get(req, url: "/cnpj/#{normalize_cnpj(cnpj)}") do
      Logger.info("[HelloPhoenix.NuvemFiscal.Cnpj] cpnj successfully requested")

      {:ok, body}
    else
      {:ok, %{status: status, body: body}} ->
        Logger.error(
          "[HelloPhoenix.NuvemFiscal.Cnpj] http error #{inspect(body, limit: :infinity)}"
        )

        {:error, {:http_error, status, body}}

      error ->
        Logger.error("[HelloPhoenix.NuvemFiscal.Cnpj] error #{inspect(error, limit: :infinity)}")
        error
    end
  end

  defp normalize_cnpj(cnpj) do
    String.replace(cnpj, ~r/\D/, "")
  end
end
