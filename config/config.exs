# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cpap,
  namespace: CPAP,
  ecto_repos: [CPAP.Repo]

# Configures the endpoint
config :cpap, CPAP.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4XmoR3Y4wcGAohR3hpp6ClHnaDcN6TDGiMwYCDpraPDl07aufCGeTkG4W0vaFv6h",
  render_errors: [view: CPAP.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CPAP.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
