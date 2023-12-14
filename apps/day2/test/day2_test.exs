defmodule Day2Test do
  use ExUnit.Case

  test "one blue is possible" do
    assert Day2.process("Game 1: 1 blue") === 1
  end

  test "18 blue is not possible" do
    assert Day2.process("Game 1: 18 blue") === 0
  end
end
