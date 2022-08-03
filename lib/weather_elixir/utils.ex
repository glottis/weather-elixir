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
end
