defmodule HelloPhoenixWeb.Router do
  use HelloPhoenixWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorized_api do
    plug :accepts, ["json"]
    plug HelloPhoenixWeb.AuthorizationPlug
  end

  scope "/", HelloPhoenixWeb do
    pipe_through :api

    get "/", VersionController, :index
    get "/health", VersionController, :index
    get "/healthz", VersionController, :index
    get "/version", VersionController, :index

    get "/whatsapp", WhatsappController, :verify
    post "/whatsapp", WhatsappController, :webhook
  end

  scope "/", HelloPhoenixWeb do
    pipe_through :authorized_api

    get "/cnpj/:cnpj", CnpjController, :show
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hello_phoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HelloPhoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
