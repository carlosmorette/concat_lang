defmodule ConcatLang do
  def run(input) do
    input
    |> tokenize()
    |> parse()
  end

  def tokenize(input), do: tokenize(input, [])

  def tokenize("", accumulator), do: accumulator

  def tokenize(input, accumulator) do
    case match_input(input) do
      {regex, :CONCAT_SYMBOL} ->
        regex
        |> Regex.split(input)
        |> List.last()
        |> tokenize(accumulator ++ [%{id: :CONCAT_SYMBOL}])

      {regex, :STRING} ->
        str_value =
          regex
          |> Regex.run(input)
          |> List.last()

        regex
        |> Regex.split(input)
        |> List.last()
        |> tokenize(accumulator ++ [%{id: :STRING, value: str_value}])

      {regex, :SPACE} ->
        regex
        |> Regex.split(input)
        |> List.last()
        |> tokenize(accumulator)
    end
  end

  def match_input(input) do
    cond do
      Regex.match?(~r/^\$\$/, input) ->
        {~r/^\$\$/, :CONCAT_SYMBOL}

      Regex.match?(~r/^\".*?\"/, input) ->
        {~r/^\".*?\"/, :STRING}

      Regex.match?(~r/^\s/, input) ->
        {~r/^\s/, :SPACE}
    end
  end

  def parse(tokens) do
    parse_program(tokens)
  end

  def parse_program(tokens) do
    {tokens, first_str} = expect_and_get!(tokens, :STRING)
    tokens = expect!(tokens, :CONCAT_SYMBOL)
    {tokens, second_str} = expect_and_get!(tokens, :STRING)
    result = first_str <> second_str

    do_parse_expression(tokens, result)
  end

  def do_parse_expression(tokens, left) do
    if match(tokens, :CONCAT_SYMBOL) do
      tokens = expect!(tokens, :CONCAT_SYMBOL)
      {tokens, second_str} = expect_and_get!(tokens, :STRING)
      result = left <> second_str

      do_parse_expression(tokens, result)
    else
      clean_str(left)
    end
  end

  def expect!([%{id: expected_id} | rest_tokens], expected_id),
    do: rest_tokens

  def expect_and_get!([%{id: expected_id, value: value} | rest_tokens], expected_id),
    do: {rest_tokens, value}

  def clean_str(str), do: String.replace(str, ~r/[\"]/, "")

  def match([%{id: expected_id} | _rest_tokens], expected_id), do: true
  def match(_tokens, _expected_id), do: false

  def next([_firt_token | rest_tokens]), do: rest_tokens
end
