defmodule WarBoyTest do
  use ExUnit.Case
  doctest WarBoy

  test "greets the world" do
    assert WarBoy.hello() == :world
  end
end
