defmodule HelloPhoenixWeb.CnpjController do
  use HelloPhoenixWeb, :controller

  alias HelloPhoenix.NuvemFiscal.Cnpj

  def show(conn, %{"cnpj" => cnpj}) do
    case Cnpj.get(cnpj) do
      {:ok, body} ->
        json(conn, body)

      {:error, {:http_error, status, body}} ->
        conn
        |> put_status(status)
        |> json(%{error: body})

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: inspect(reason, limit: :infinity)})
    end
  end
end
