defmodule WeatherElixir do
  use GenServer
  require Logger

  @rain_sensor_pin 6

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, gpio} = Circuits.GPIO.open(@rain_sensor_pin, :input)
    Circuits.GPIO.set_interrupts(gpio, :falling)

    {:ok, gpio}
  end

  def handle_info({:circuits_gpio, @rain_sensor_pin, _timestamp, _value}, state) do
    Logger.info("Sensor triggered from pin: #{@rain_sensor_pin}")
    WeatherElixir.Rain.update()
    {:noreply, state}
  end
end
