# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :roommates,
  ecto_repos: [Roommates.Repo]

# Configures the endpoint
config :roommates, Roommates.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QOLCxAFL8Q3nbh0o7QmJ2XE4/ahRp8c7r4q/nklc0kvVewHmKcvlDOYHdCBeLkCQ",
  render_errors: [view: Roommates.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Roommates.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Ueberauth's providers
config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [profile_fields: "name,email,picture"]}
  ]

# Configure credentials for Facebook API
config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
