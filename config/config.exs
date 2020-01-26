use Mix.Config

config :uzi, Uzi.Repo,
  database: "uzi_dev",
  username: "root",
  password: nil,
  hostname: "localhost",
  port: 3306,
  pool_size: 10

config :uzi, ecto_repos: [Uzi.Repo]

config :uzi, UziWeb.Endpoint, port: 8081

config :uzi, :callbacks, reply_to_host: "localhost"
# interrupt outgoing request if it took more than 6 sec
config :uzi, :outgoing_requests, timeout_millisec: 6_000

# import_config "#{Mix.env()}.exs"
