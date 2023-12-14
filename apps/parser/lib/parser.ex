defmodule Parser do
  @moduledoc """
  Parser combinator
  """
  @type parsed ::
          {:ok, match :: any(), rest :: String.t()}
          | {:error, message :: String.t()}
  @type parse_result ::
          {:ok, match :: any()}
          | {:error, message :: String.t()}

  @type parser :: (String.t() -> parsed())

  @spec string(String.t()) :: parser()
  def(string(string)) do
    regex(Regex.compile!(Regex.escape(string)))
  end

  @spec digit() :: parser()
  def digit() do
    regex(~r'\d') |> map(&String.to_integer/1)
  end

  @spec integer() :: parser()
  def integer() do
    regex(~r'\d+') |> map(&String.to_integer/1)
  end

  @spec regex(Regex.t()) :: parser()
  def regex(pattern) do
    {:ok, regex} = Regex.compile("^" <> pattern.source)

    fn input when is_binary(input) ->
      case Regex.run(regex, input) do
        [match | _] ->
          {_, rest} =
            input
            |> String.split_at(String.length(match))

          {:ok, match, rest}

        _err ->
          {:error, "mismatched input"}
      end
    end
  end

  @spec map(parser(), (any() -> any())) :: parser()
  def map(parser, f) do
    fn input when is_binary(input) ->
      case parser.(input) do
        {:ok, match, rest} -> {:ok, f.(match), rest}
        err -> err
      end
    end
  end

  @spec or_else(parser(), parser()) :: parser()
  def or_else(one, other) do
    fn input when is_binary(input) ->
      case one.(input) do
        {:error, _} -> other.(input)
        ok -> ok
      end
    end
  end

  @spec and_then(parser(), parser()) :: parser()
  def and_then(one, other) do
    fn input when is_binary(input) ->
      with {:ok, first, rest} <- one.(input),
           {:ok, second, rest} <- other.(rest) do
        {:ok, {first, second}, rest}
      else
        err -> err
      end
    end
  end

  @spec skip_and_then(parser(), parser()) :: parser()
  def skip_and_then(one, other) do
    and_then(one, other) |> map(fn {_first, second} -> second end)
  end

  @spec and_then_skip(parser(), parser()) :: parser()
  def and_then_skip(one, other) do
    and_then(one, other) |> map(fn {first, _second} -> first end)
  end

  @spec repeating(parser()) :: parser()
  def repeating(parser) do
    fn input when is_binary(input) ->
      case do_repeat(parser, input, []) do
        {[], _rest} -> {:error, "mismatched input"}
        {match, rest} -> {:ok, match, rest}
      end
    end
  end

  @spec do_repeat(parser(), String.t(), list()) :: {list(), String.t()}
  defp do_repeat(parser, input, acc) do
    case parser.(input) do
      {:ok, match, rest} -> do_repeat(parser, rest, [match | acc])
      _ -> {acc, input}
    end
  end

  @spec and_then_end(parser()) :: parser()
  def and_then_end(parser) do
    end_fun = fn
      "" -> {:ok, nil, ""}
      _rest -> {:error, "expected EOF"}
    end

    parser |> and_then_skip(end_fun)
  end

  @spec parse(parser(), String.t()) :: parse_result()
  def parse(parser, input) do
    case parser.(input) do
      {:ok, match, _} -> {:ok, match}
      err -> err
    end
  end
end
