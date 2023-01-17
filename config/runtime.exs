import Config

config :weather_elixir,
  host: System.fetch_env!("MQTT_HOST") |> String.to_charlist(),
  port: System.fetch_env!("MQTT_PORT") |> String.to_integer(),
  sni: System.fetch_env!("MQTT_SNI") |> String.to_charlist(),
  ca: System.fetch_env!("CACERT"),
  clientid: System.fetch_env!("MQTT_USER"),
  username: System.fetch_env!("MQTT_USER"),
  password: System.fetch_env!("MQTT_USER_PW")