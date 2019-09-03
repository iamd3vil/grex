defmodule GrexTest do
  use ExUnit.Case
  doctest Grex

  test "greets the world" do
    assert Grex.hello() == :world
  end
end
