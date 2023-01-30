# ConcatLang

Linguagem que concatena strings.
```ex
iex(1)> ConcatLang.run("\"Parsers\" $$ \" são \" $$ \"irados\"")
"Parsers são irados"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `concat_lang` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:concat_lang, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/concat_lang](https://hexdocs.pm/concat_lang).

