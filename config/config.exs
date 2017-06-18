# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :melange,
  ecto_repos: [Melange.Repo]

# Configures the endpoint
config :melange, Melange.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n0zOfx6fXdKxk4WF3j9gIhv0Y3n5dPBNVoxa/BbguYRs/sZcfHtJn7fuxGyUFaXE",
  render_errors: [view: Melange.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Melange.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Melange",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "ZtyM7wp3sjyFchPgMltULUNOdP/84k21HqgRZ1/+/EhYWUvH+RfES7E+z+Msyf2l",
  serializer: Melange.Web.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
