defmodule ConcatLangTest do
  use ExUnit.Case
  doctest ConcatLang

  test "greets the world" do
    assert ConcatLang.hello() == :world
  end
end
