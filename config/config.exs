import Config
config :tz, reject_time_zone_periods_before_year: 2022
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :weather_elixir, :emqtt,
  host: System.fetch_env!("MQTT_HOST") |> String.to_charlist(),
  port: System.fetch_env!("MQTT_PORT") |> String.to_integer(),
  clientid: System.fetch_env!("MQTT_USER"),
  username: System.fetch_env!("MQTT_USER"),
  password: System.fetch_env!("MQTT_USER_PW"),
  ssl: true,
  ssl_opts: [
    server_name_indication: System.fetch_env!("MQTT_SNI") |> String.to_charlist(),
    cacertfile: System.fetch_env!("CACERT")
  ],
  name: :emqtt
