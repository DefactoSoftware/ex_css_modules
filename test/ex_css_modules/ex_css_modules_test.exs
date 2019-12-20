defmodule ExCSSModulesTest do
  use ExUnit.Case

  @example_stylesheet __ENV__.file
                      |> Path.dirname()
                      |> Path.join("../support/stylesheet.css")

  doctest ExCSSModules, import: true
end
