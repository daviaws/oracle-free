# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :hello_phoenix,
  ecto_repos: [HelloPhoenix.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :hello_phoenix, HelloPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: HelloPhoenixWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: HelloPhoenix.PubSub,
  live_view: [signing_salt: "nXpiCCQD"]

config :hello_phoenix, Oban,
  # log: :debug,
  engine: Oban.Engines.Lite,
  queues: [default: 1],
  repo: HelloPhoenix.Repo,
  poll_interval: :timer.seconds(5)

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :hello_phoenix, HelloPhoenix.Mailer, adapter: Swoosh.Adapters.Local

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
