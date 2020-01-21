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

config :uzi, :callbacks, host: "localhost", port: 8081

# import_config "#{Mix.env()}.exs"
