defmodule WeatherElixir.Wind do
  use Agent
  require Logger

  @doc """
  Starts a new agent for the speed gauge
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{count: 0, vol: 0} end, name: :wind)
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
    # Logger.info("Agent state for rain gauge will reset in #{round(st / 1000 / 3600)} hours")

    # Process.sleep(st)
    # Agent.update(:rain, fn _state -> %{count: 0, vol: 0} end)

    # Logger.info("Agent state for rain gauge reset")

    # reset_agent()
  end

  @doc """
  Updates wind state
  """
  def update() do
    Logger.info("Wind updated")
  end
end
