defmodule WeatherElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather_elixir,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WeatherElixir.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_spi, "~> 1.3"},
      {:circuits_gpio, "~> 1.0"},
      {:tz, "~> 0.21.1"}
    ]
  end
end
