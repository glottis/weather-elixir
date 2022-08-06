defmodule WeatherElixir.Wind do
  use Agent
  require Logger

  @wind_speed 2.4
  @anemometer_factor 1.18
  @wind_interval_ms 5000
  @radius_m 0.09
  @wind_rotations 2.0

  @doc """
  Starts a new agent for the wind speed gauge
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{count: 0, max: 0} end, name: :wind)
  end

  @doc """
  Returns the state of the agent
  """
  def get() do
    Agent.get(:wind, fn state -> state end)
  end

  @doc """
  Resets the state of the agent after midnight
  """
  def reset_agent() do
    Process.sleep(@wind_interval_ms)

    state = get()

    circumference_m = 2 * :math.pi() * @radius_m
    fixed_count = state.count / @wind_rotations
    dist_m = circumference_m * fixed_count
    speed = dist_m / (@wind_interval_ms / 1000)
    Logger.info("Current wind speed is: #{speed * @anemometer_factor}m/s")

    Agent.update(:wind, fn _state -> Map.put(state, "count", 0) end)

    reset_agent()
  end

  @doc """
  Updates wind state
  """
  def update() do
    curr_state = get()

    Agent.update(:wind, fn state -> Map.put(state, "count", curr_state[:count] + 1) end)
    Logger.info("Wind updated")
  end
end
