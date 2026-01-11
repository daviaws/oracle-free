defmodule HelloPhoenixWeb.AuthorizationPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    token = Application.fetch_env!(:hello_phoenix, :api)[:client_token]
    auth_header = get_req_header(conn, "authorization") |> List.first()

    case auth_header do
      "Bearer " <> ^token -> conn
      _ -> conn |> send_resp(401, ~s({"error":"unauthorized"})) |> halt()
    end
  end
end
