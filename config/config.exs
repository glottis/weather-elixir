import Config
config :tz, reject_time_zone_periods_before_year: 2022
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :weather_elixir, :emqtt,
  host: System.get_env("MQTT_HOST") |> String.to_charlist(),
  port: System.get_env("MQTT_PORT") |> String.to_integer(),
  clientid: System.get_env("MQTT_USER"),
  username: System.get_env("MQTT_USER"),
  password: System.get_env("MQTT_USER_PW"),
  ssl: true,
  ssl_opts: [
    server_name_indication: System.get_env("MQTT_SNI") |> String.to_charlist(),
    cacertfile: System.get_env("CACERT")
  ],
  name: :emqtt
