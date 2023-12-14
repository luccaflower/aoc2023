defmodule ParserTest do
  use ExUnit.Case
  doctest Parser
  import Parser

  test "parses string literal" do
    assert string("te") |> parse("test") === {:ok, "te"}
  end

  test "error when no match" do
    assert string("te") |> parse("nottest")
  end

  test "parses repeating" do
    {:ok, result} =
      string("te")
      |> repeating()
      |> parse("tetetest")

    assert Enum.join(result) === "tetete"
  end

  test "applies mapping" do
    {:ok, result} =
      string("1")
      |> map(&String.to_integer/1)
      |> parse("1")

    assert result === 1
  end

  test "either or" do
    {:ok, result} =
      string("1")
      |> or_else(string("2"))
      |> parse("2")

    assert result === "2"
  end

  test "and then" do
    {:ok, result} =
      string("1")
      |> and_then(string("2"))
      |> parse("12")

    assert result === {"1", "2"}
  end

  test "skip and then" do
    {:ok, result} =
      string("1")
      |> skip_and_then(string("2"))
      |> parse("12")

    assert result === "2"
  end
end
