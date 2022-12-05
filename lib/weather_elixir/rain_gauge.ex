defmodule WeatherElixir.Rain do
  use Agent
  require Logger

  alias WeatherElixir.Utils
  alias WeatherElixir.Mqtt

  @rain_bucket 0.2794

  @doc """
  Starts a new agent for the rain gauge
  """
  def start_link(_opts) do
    spawn(fn -> reset_agent() end)
    Agent.start_link(fn -> %{count: 0, vol: 0} end, name: :rain)
  end

  @doc """
  Returns the state of the agent
  """
  def get() do
    Agent.get(:rain, fn state -> state end)
  end

  @doc """
  Resets the state of the agent after midnight
  """
  def reset_agent() do
    st = Utils.ms_until_midnight()
    Logger.info("Agent state for rain gauge will reset in #{round(st / 1000 / 3600)} hours")

    Process.sleep(st)
    Agent.update(:rain, fn _state -> %{count: 0, vol: 0} end)

    reset_agent()
  end

  @doc """
  Updates rain state by @rain_bucket
  """
  def update() do
    curr_state = Agent.get(:rain, fn state -> state end)

    new_vol = Float.round(curr_state.vol + @rain_bucket, 2)
    new_count = curr_state.count + 1

    Agent.update(:rain, fn _state -> %{count: new_count, vol: new_vol} end)

    Utils.create_mqtt_payload("Rain", new_vol, "weather-pi-rain") |> Mqtt.publish()
  end
end
