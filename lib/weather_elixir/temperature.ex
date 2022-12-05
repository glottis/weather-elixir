defmodule WeatherElixir.Temperature do
  use Agent
  require Logger
  require Ds18b20_1w

  @temperature_interval_ms 60000

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

    Process.sleep(@temperature_interval_ms)

    read_temperature()
  end
end
