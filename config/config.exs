import Config
config :tz, reject_time_zone_periods_before_year: 2024
config :elixir, :time_zone_database, Tz.TimeZoneDatabase
