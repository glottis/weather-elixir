defmodule WeatherElixir.Wind do
  use Agent
  require Logger

  @anemometer_factor 1.18
  @avg_wind_interval_ms 3_600_000
  @wind_interval_ms 5000
  @radius_m 0.09
  @wind_rotations 2.0

  @doc """
  Starts a new agent for the wind speed gauge
  """
  def start_link(_opts) do
    spawn(fn -> calc_wind_speed() end)
    spawn(fn -> calc_avg_wind_speed() end)
    Agent.start_link(fn -> %{count: 0, max: 0, enteries: []} end, name: :wind)
  end

  @doc """
  Returns the state of the agent
  """
  def get() do
    Agent.get(:wind, fn state -> state end)
  end

  @doc """
  Calculates avg wind speed for a period of @avg_wind_interval_ms in ms
  """
  def calc_avg_wind_speed() do
    Process.sleep(@avg_wind_interval_ms)

    state = get()
    list_len = length(state[:entries])

    case list_len > 0 do
      true ->
        avg_wind = Enum.sum(state[:entries]) / list_len

        Agent.update(:wind, fn state -> %{state | entries: []} end)
        Logger.info("Avg wind speed is: #{avg_wind}m/s")
        calc_avg_wind_speed()

      _ ->
        calc_avg_wind_speed()
    end
  end

  def calc_wind_speed() do
    Process.sleep(@wind_interval_ms)

    state = get()
    count = state[:count]

    case count > 0 do
      true ->
        circumference_m = 2 * :math.pi() * @radius_m
        fixed_count = state[:count] / @wind_rotations
        dist_m = circumference_m * fixed_count
        speed = (dist_m / (@wind_interval_ms / 1000) * @anemometer_factor) |> Float.round(1)

        new_max = if speed > state[:max], do: speed, else: state[:max]

        Agent.update(:wind, fn state ->
          %{state | max: new_max, count: 0, entries: [speed | state[:entries]]}
        end)

        Logger.info("Current wind speed is: #{speed}m/s")

        calc_wind_speed()

      false ->
        calc_wind_speed()
    end
  end

  @doc """
  Updates wind state
  """
  def update() do
    curr_state = get()

    Agent.update(:wind, fn state -> Map.put(state, :count, curr_state[:count] + 1) end)
  end
end
