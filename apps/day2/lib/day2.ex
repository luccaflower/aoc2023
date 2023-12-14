defmodule Day2 do
  import Parser

  @bag %{
    red: 12,
    green: 13,
    blue: 14
  }

  def process(string) do
    {:ok, result} =
      string("Game ")
      |> skip_and_then(integer())
      |> and_then_skip(string(": "))
      |> and_then(regex(~r'\w+') |> map(&color_from/1))
      |> parse(string)

    result
  end

  def color_from("red"), do: :red
  def color_from("yellow"), do: :yellow
  def color_from("blue"), do: :blue
  def color_from(s), do: raise(ArgumentError, message: "invalid color, #{s}")
end
