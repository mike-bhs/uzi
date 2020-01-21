defmodule Uzi.MixProject do
  use Mix.Project

  def project do
    [
      app: :uzi,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Uzi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.1.1"},
      {:jason, "~> 1.1"},
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:ecto_sql, "~> 3.2.2"},
      {:myxql, "~> 0.3"}
    ]
  end
end
