defmodule UziTest do
  use ExUnit.Case
  doctest Uzi

  test "greets the world" do
    assert Uzi.hello() == :world
  end
end
