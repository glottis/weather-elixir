defmodule WeatherElixir.Mqtt do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: :mqtt)
  end

  def init([]) do
    emqtt_opts = Application.get_env(:weather_elixir, :emqtt)
    {:ok, pid} = :emqtt.start_link(emqtt_opts)

    state = %{
      pid: pid
    }

    {:ok, state, {:continue, :connect}}
  end

  def get() do
    GenServer.call(:mqtt, :get)
  end

  def publish(data) do
    json = data |> Jason.encode!()
    GenServer.cast(:mqtt, {:publish, json, "sensors/" <> data["sensor"] <> "/data"})
  end

  def handle_continue(:connect, state) do
    {:ok, _} = :emqtt.connect(state.pid)
    {:noreply, state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:publish, payload, topic}, st) do
    :emqtt.publish(st.pid, topic, payload)
    {:noreply, st}
  end
end
