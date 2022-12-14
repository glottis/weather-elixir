defmodule WeatherElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather_elixir,
      version: "0.1.0",
      elixir: "~> 1.9",
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
      {:jason, "~> 1.4"},
      {:emqtt, github: "emqx/emqtt", tag: "1.4.4", system_env: [{"BUILD_WITHOUT_QUIC", "1"}]},
      {:ds18b20_1w, "~> 0.1.2"},
      {:circuits_spi, "~> 1.3"},
      {:circuits_gpio, "~> 1.0"},
      {:tz, "~> 0.21.1"}
    ]
  end
end
