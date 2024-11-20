import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spiralbench, SpiralbenchWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "v/7f0v32z/SoGiPVREJctB3E9nF1+nh9UUd31JRJxpGfztZTZDo6EQKaWH6G7AJQ",
  server: false

# In test we don't send emails
config :spiralbench, Spiralbench.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
