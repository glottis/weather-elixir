defmodule WeatherElixir.Wifi do
  use Agent
  require Logger

  @sleep_interval_ms 6_000_000

  @doc """
  Starts a new agent for the temperature agent
  """
  def start_link(_opts) do
    spawn(fn -> check_wifi_signal() end)
    Agent.start_link(fn -> %{signal: 0} end, name: :wifi)
  end

  @doc """
  Returns the state of the agent
  """
  def get() do
    Agent.get(:wifi, fn state -> state end)
  end

  @doc """
  Check wifi signal if any wlan interfaces are detected
  """
  def check_wifi_signal() do
    with {:ok, interfaces} <- :inet.getiflist(),
         true <- interfaces |> Enum.member?('wlan0'),
         signal =
           "iwconfig wlan0 | grep 'Signal level' | awk -F 'level=' '{ print $2 }' | sed 's/ dBm//'"
           |> String.to_charlist()
           |> :os.cmd()
           |> List.to_string()
           |> String.trim() do
      Agent.update(:wifi, fn _state -> %{signal: signal} end)

      Logger.info("Current wifi signal is: #{signal}")

      Process.sleep(@sleep_interval_ms)

      check_wifi_signal()
    else
      _ -> Logger.info("No wlan0 detected, not trying to fetch wifi signal..!")
    end
  end
end
