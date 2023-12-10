defmodule Day1 do
  def run do
    file = File.read!("INPUT.txt") |> String.trim()
    IO.puts(process(file))
  end

  def process(string) do
    string
    |> String.split()
    |> Enum.filter(&(String.trim(&1) !== ""))
    |> Enum.map(&convert_numbers/1)
    |> Enum.map(&first_and_last/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp convert_numbers("one" <> rest), do: "1" <> convert_numbers("ne" <> rest)
  defp convert_numbers("two" <> rest), do: "2" <> convert_numbers("wo" <> rest)
  defp convert_numbers("three" <> rest), do: "3" <> convert_numbers("hree" <> rest)
  defp convert_numbers("four" <> rest), do: "4" <> convert_numbers("our" <> rest)
  defp convert_numbers("five" <> rest), do: "5" <> convert_numbers("ive" <> rest)
  defp convert_numbers("six" <> rest), do: "6" <> convert_numbers("ix" <> rest)
  defp convert_numbers("seven" <> rest), do: "7" <> convert_numbers("even" <> rest)
  defp convert_numbers("eight" <> rest), do: "8" <> convert_numbers("ight" <> rest)
  defp convert_numbers("nine" <> rest), do: "9" <> convert_numbers("ine" <> rest)

  defp convert_numbers(<<num::utf8>> <> rest) when num in ~c'123456789' do
    <<num::utf8>> <> convert_numbers(rest)
  end

  defp convert_numbers(<<_::utf8>> <> rest) do
    convert_numbers(rest)
  end

  defp convert_numbers(""), do: ""

  defp first_and_last(string), do: String.first(string) <> String.last(string)
end
