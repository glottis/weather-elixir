import Config
config :tz, reject_time_zone_periods_before_year: 2022
config :elixir, :time_zone_database, Tz.TimeZoneDatabase
