defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  @input """
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  """

  test "gets first and last digit from two-digit number" do
    assert Day1.process("12") === 12
  end

  test "gets first and last digit from more than two digits" do
    assert Day1.process("123") === 13
  end

  test "gets first and last digit when mixed within characters" do
    assert Day1.process("acd1def2") === 12
  end

  test "sums up multiple lines" do
    assert Day1.process("12\n34") === 46
  end

  test "matches input" do
    assert Day1.process(@input) === 142
  end

  test "numbers spelled out are digits too" do
    assert Day1.process("one32") === 12
  end

  @input2 """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """
  test "matches second input" do
    assert Day1.process(@input2) === 281
  end

  test "two1nine is 29" do
    assert Day1.process("two1nine") === 29
  end

  test "eightwothree is 83" do
    assert Day1.process("eightwothree") === 83
  end

  test "abcone2threexyz" do
    assert Day1.process("abcone2threexyz") === 13
  end

  test "xtwone3four is 24" do
    assert Day1.process("xtwone3four") === 24
  end

  test "overlapping sequences" do
    assert Day1.process("twone") === 21
  end
end
