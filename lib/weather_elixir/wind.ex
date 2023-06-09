defmodule WeatherElixir.Wind do
  use Agent
  alias WeatherElixir.Utils

  @avg_wind_interval_ms 3_600_000
  @wind_interval_ms 5000
  @wind_speed_m_s_second 0.67

  @doc """
  Starts a new agent for the wind speed gauge
  """
  def start_link(_opts) do
    spawn(fn -> calc_wind_speed() end)
    spawn(fn -> calc_avg_wind_speed() end)
    Agent.start_link(fn -> %{count: 0, max: 0, direction: "", entries: []} end, name: :wind)
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
        speed =
          (count * @wind_speed_m_s_second / (@wind_interval_ms / 1000))
          |> Float.round(1)

        speed = if speed > 30, do: 0, else: speed
        new_max = if speed > state[:max], do: speed, else: state[:max]

        Agent.update(:wind, fn state ->
          %{state | max: new_max, count: 0, entries: [speed | state[:entries]]}
        end)

        {payload, topic} = Utils.create_mqtt_payload("Speed", speed, "weather-pi-wind-speed")
        Tortoise.publish("weather-pi", topic, payload)
        calc_wind_speed()

      false ->
        calc_wind_speed()
    end
  end

  @doc """
  Updates wind speed state
  """
  def update_speed() do
    curr_state = get()

    Agent.update(:wind, fn state -> Map.put(state, :count, curr_state[:count] + 1) end)
  end

  @doc """
  Updates wind direction state
  """
  def update_direction(input) do
    direction = input |> Utils.convert_volts() |> Utils.lookup_wind_direction()

    curr_state = get()

    if curr_state[direction] != direction && direction != "N/A" do
      Agent.update(:wind, fn state -> Map.put(state, :direction, direction) end)

      {payload, topic} =
        Utils.create_mqtt_payload("Direction", direction, "weather-pi-wind-direction")

      Tortoise.publish("weather-pi", topic, payload)
    end
  end
end
