defmodule WeatherElixir.Mqtt do
  require Logger

  def child_spec(opts \\ []) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      shutdown: 5_000,
      restart: :permanent,
      type: :worker
    }
  end

  def start_link(opts) do
    pid = spawn_link(__MODULE__, :init, [opts])
    Process.register(pid, :mqtt)
    {:ok, pid}
  end

  def init(_opts) do
    reader()
  end

  def publish(data) do
    send(:mqtt, {:pub, data})
  end

  def check do
    pid = Process.whereis(:mqtt)
    Process.info(pid, :message_queue_len)
  end

  def reader do
    receive do
      {:pub, payload} ->
        topic = "sensors/" <> data["sensor"] <> "/data"
        json = payload |> Jason.encode!()

        System.cmd("mosquitto_pub", ["--topic", topic, "--message", json])

        reader()

      msg ->
        Logger.info("Got #{msg}, wont do anything about it")
        reader()
    end
  end
end
