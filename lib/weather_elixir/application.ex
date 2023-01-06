defmodule WeatherElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    children = [
      # Starts a worker by calling: WeatherElixir.Worker.start_link(arg)
      {Tortoise.Connection, [
        client_id: Application.get_env(:weather_elixir, :clientid),
        user_name: Application.get_env(:weather_elixir, :username),
        password: Application.get_env(:weather_elixir, :password),
        server: {Tortoise.Transport.SSL,
          host: Application.get_env(:weather_elixir, :host),
          port: Application.get_env(:weather_elixir, :port),
          cacertfile: Application.get_env(:weather_elixir, :ca),
          server_name_indication: Application.get_env(:weather_elixir, :sni)
          },
        handler: {Tortoise.Handler.Logger, []}
      ]}
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
