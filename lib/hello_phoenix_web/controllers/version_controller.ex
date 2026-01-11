defmodule HelloPhoenixWeb.VersionController do
  use HelloPhoenixWeb, :controller

  @project Mix.Project.config()

  def index(conn, _params) do
    version_info = %{
      app: @project[:app],
      version: @project[:version],
      elixir: System.version(),
      phoenix: Application.spec(:phoenix, :vsn) |> to_string()
    }

    json(conn, version_info)
  end
end
