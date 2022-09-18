defmodule WeatherElixir.Utils do
  @full_day_ms 3600 * 24 * 1000

  @doc """
  Returns milliseconds until midnight, default Europe/Stockholm tz
  """
  def ms_until_midnight(tz \\ "Europe/Stockholm") do
    {:ok, dt} = DateTime.now(tz)
    {:ok, t} = Time.new(dt.hour, dt.minute, dt.second, dt.microsecond)
    @full_day_ms - abs(Time.diff(~T[00:00:00], t, :millisecond))
  end

  @doc """
  Convert input to volts
  """
  def convert_volts(input) do
    (input / 1023 * 3.3) |> Float.round(1)
  end

  @doc """
  Lookup wind direction from volt value
  """
  def lookup_wind_direction(volt) do
    case volt do
      0.4 -> "N"
      1.4 -> "NNE"
      1.2 -> "NE"
      2.8 -> "ENE"
      2.7 -> "E"
      2.9 -> "ESE"
      2.2 -> "SE"
      2.5 -> "SSE"
      1.8 -> "S"
      2.0 -> "SSW"
      0.7 -> "SW"
      0.8 -> "WSW"
      0.1 -> "W"
      0.3 -> "WNW"
      0.2 -> "NW"
      0.6 -> "NNW"
      _ -> "N/A"
    end
  end
end
