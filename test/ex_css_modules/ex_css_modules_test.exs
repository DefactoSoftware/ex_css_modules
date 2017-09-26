defmodule ExCSSModulesTest do
  use ExUnit.Case

  @example_stylesheet __ENV__.file
                      |> Path.dirname
                      |> Path.join("../support/stylesheet.css")

  describe "read_stylesheet/1" do
    test "reads a valid stylesheet definition" do
      assert ExCSSModules.read_stylesheet(@example_stylesheet) ==
        %{
          "title" => "_namespaced_title",
          "paragraph" => "_namespaced_paragraph"
        }
    end

    test "ignores an invalid stylesheet definition" do
      assert ExCSSModules.read_stylesheet("foobar") == %{}
    end
  end

  describe "class_name/3" do
    test "returns the definition when value is true" do
      assert ExCSSModules.class_name(
        %{"hello" => "world"},
        "hello",
        true
      ) == "world"
    end

    test "returns nil when value is false" do
      assert ExCSSModules.class_name(%{"hello" => "world"}, "hello", false) == nil
    end
  end

  describe "class_name/2" do
    test "use class_name/3 when the key is a tuple" do
      assert ExCSSModules.class_name(%{"hello" => "world"}, "hello", true) ==
        ExCSSModules.class_name(%{"hello" => "world"}, {"hello", true})

      assert ExCSSModules.class_name(%{"hello" => "world"}, "hello", false) ==
        ExCSSModules.class_name(%{"hello" => "world"}, {"hello", false})
    end

    test "accepts a list of values" do
      assert ExCSSModules.class_name(
        %{"hello" => "world", "foo" => "bar"},
        ["hello", "foo"]
      ) == "world bar"
    end

    test "accepts a list of tuples" do
      assert ExCSSModules.class_name(
        %{"hello" => "world", "foo" => "bar"},
        [{"hello", false}, {"foo", true}]
      ) == "bar"
    end

    test "returns the value" do
      assert ExCSSModules.class_name(
        %{"hello" => "world", "foo" => "bar"},
        "hello"
      ) == "world"
    end

    test "defaults to nil" do
      assert ExCSSModules.class_name(%{}, "hello") == nil
    end
  end

  describe "class_name/1" do
    test "returns a map if given a map" do
      assert ExCSSModules.stylesheet(%{}) == %{}
    end

    test "reads a file if given a string" do
      assert ExCSSModules.stylesheet(@example_stylesheet) == %{
        "title" => "_namespaced_title",
        "paragraph" => "_namespaced_paragraph"
      }
    end
  end
end
