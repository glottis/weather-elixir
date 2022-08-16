defmodule WeatherElixir do
  use GenServer
  alias Circuits.GPIO
  require Logger

  @wind_sensor_pin 5
  @rain_sensor_pin 6

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, rain_gpio} = GPIO.open(@rain_sensor_pin, :input)
    {:ok, wind_gpio} = GPIO.open(@wind_sensor_pin, :input)

    GPIO.set_interrupts(wind_gpio, :falling)
    GPIO.set_interrupts(rain_gpio, :falling)

    {:ok, {rain_gpio, wind_gpio}}
  end

  def handle_info({:circuits_gpio, @rain_sensor_pin, _timestamp, _value}, state) do
    # Logger.info("Sensor triggered from pin: #{@rain_sensor_pin}")
    WeatherElixir.Rain.update()
    {:noreply, state}
  end

  def handle_info({:circuits_gpio, @wind_sensor_pin, _timestamp, _value}, state) do
    # Logger.info("Sensor triggered from pin: #{@wind_sensor_pin}")
    WeatherElixir.Wind.update()
    {:noreply, state}
  end
end
