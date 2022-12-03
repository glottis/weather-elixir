import Config
config :tz, reject_time_zone_periods_before_year: 2022
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :WeatherElixir, :emqtt,
  host: System.get_env("MQTT_HOST"),
  port: System.get_env("MQTT_PORT"),
  clientid: "weather_pi",
  clean_start: false,
  username: System.get_env("MQTT_USER"),
  password: System.get_env("MQTT_USER_PW"),
  ssl: true,
  ssl_opts: [
    server_name_indication: System.get_env("MQTT_SNI"),
    cacertfile: System.get_env("CACERT")
  ],
  name: :emqtt
