defmodule WeatherElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: WeatherElixir.Worker.start_link(arg)
      {WeatherElixir.Mqtt, []},
      {WeatherElixir.Rain, []},
      {WeatherElixir.Wind, []},
      {WeatherElixir.Temperature, []},
      {WeatherElixir.Wifi, []},
      {WeatherElixir, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
