# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todo_backend,
  ecto_repos: [TodoBackend.Repo]

# Configures the endpoint
config :todo_backend, TodoBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qB5L2DZdCt5qJPsbguuAiTZLD4q+Y3sJ8NnGQE6jWvwl0cMjpqEsbd5tgRv29bAN",
  render_errors: [view: TodoBackendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TodoBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
