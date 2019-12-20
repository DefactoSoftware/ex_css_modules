defmodule ExCSSModulesTest do
  use ExUnit.Case

  @example_stylesheet __ENV__.file
                      |> Path.dirname()
                      |> Path.join("../support/stylesheet.css")

  doctest ExCSSModules, import: true

  describe "class_selector/2" do
    test "returns the selector if the key is present" do
      assert ExCSSModules.class_selector(@example_stylesheet, "title")
        == "._namespaced_title"
    end

    test "returns nil if the key is not present" do
      assert ExCSSModules.class_selector(@example_stylesheet, "foo")
        == nil
    end

    test "returns a joined string if the key is a list" do
      assert ExCSSModules.class_selector(@example_stylesheet, ["title", "paragraph"])
        == "._namespaced_title._namespaced_paragraph"
    end
  end
end
