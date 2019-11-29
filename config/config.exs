# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :test_task,
  ecto_repos: [TestTask.Repo]

# Configures the endpoint
config :test_task, TestTaskWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UrqdbPvU4BdR+TQYr9vzFrOZlPbuFmnglN2/60NctzShZgv2ST3j08HLFag3Acgv",
  render_errors: [view: TestTaskWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestTask.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
