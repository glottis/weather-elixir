defmodule WeatherElixir.Temperature do
  use Agent
  require Ds18b20_1w

  alias WeatherElixir.Utils
  @temperature_interval_ms 300_000

  @doc """
  Starts a new agent for the temperature agent
  """
  def start_link(_opts) do
    spawn(fn -> read_temperature() end)
    Agent.start_link(fn -> %{temperature: 0} end, name: :temperature)
  end

  @doc """
  Returns the state of the agent
  """
  def get() do
    Agent.get(:temperature, fn state -> state end)
  end

  @doc """
  Reads the temperature sensor(s) and stores them into the agent
  """
  def read_temperature() do
    [{:ok, _sensor, temp}] = Ds18b20_1w.read_sensors()

    Agent.update(:temperature, fn _state -> %{temperature: temp} end)

    payload, topic = Utils.create_mqtt_payload("Temperature", temp, "ds18b20-temperature")
    Tortoise.publish(:temp, topic, payload)
    Process.sleep(@temperature_interval_ms)

    read_temperature()
  end
end
