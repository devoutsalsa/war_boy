defmodule WarBoy.MixProject do
  use Mix.Project

  def project do
    [
      app: :war_boy,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WarBoy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # HTTP client
      {:httpoison, ">= 0.0.0"},

      # JSON decover
      {:jason, ">= 0.0.0"},

      # HTTP Server
      {:plug_cowboy, ">= 0.0.0"}
    ]
  end
end
