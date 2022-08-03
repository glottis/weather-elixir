defmodule WeatherElixirTest do
  use ExUnit.Case
  doctest WeatherElixir

  test "greets the world" do
    assert WeatherElixir.hello() == :world
  end
end
