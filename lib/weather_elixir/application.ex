defmodule WeatherElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: WeatherElixir.Worker.start_link(arg)
      {Tortoise.Connection,
       [
         client_id: System.fetch_env!("MQTT_USER"),
         user_name: System.fetch_env!("MQTT_USER"),
         password: System.fetch_env!("MQTT_USER_PW"),
         handler: {Tortoise.Handler.Logger, []},
         server:
           {Tortoise.Transport.SSL,
            host: System.fetch_env!("MQTT_HOST") |> String.to_charlist(),
            port: System.fetch_env!("MQTT_PORT") |> String.to_integer(),
            cacertfile: System.fetch_env!("CACERT"),
            server_name_indication: System.fetch_env!("MQTT_SNI") |> String.to_charlist()
       }]},
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
