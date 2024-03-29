# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo_backend,
  ecto_repos: [TodoBackend.Repo]

# Configures the endpoint
config :todo_backend, TodoBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Jr2ipy+jfCAmN1/kaON/KJ30LmBxV0UY4ZaPwtwrw3Vz5J3ZPm1ZUMUh07KxZcED",
  render_errors: [view: TodoBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TodoBackend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


# Guardian config
config :todo_backend, TodoBackend.Guardian,
       issuer: "todo_backend",
       secret_key: "qZw4lknb3fEs42t/MozOsAN+J+0tpzgQuvT7vqwteTsUmYqYWbeMvrbO3IiScFhG"
