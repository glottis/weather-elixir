defmodule WeatherElixir.Mqtt do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: :mqtt)
  end

  def init([]) do
    emqtt_opts = Application.get_env(:weather_elixir, :emqtt)
    {:ok, pid} = :emqtt.start_link(emqtt_opts)

    st = %{
      pid: pid
    }

    {:ok, _} = :emqtt.connect(pid)

    {:ok, st}
  end

  def handle_cast({:publish, data}, st) do
    {:noreply, st}
  end
end
