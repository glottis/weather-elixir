defmodule WeatherElixir.Mqtt do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    emqtt_opts = Application.get_env(:WeatherElixir, :emqtt)
    {:ok, pid} = :emqtt.start_link(emqtt_opts)

    st = %{
      pid: pid
    }

    {:ok, _} = :emqtt.connect(pid)

    {:ok, st}
  end
end
