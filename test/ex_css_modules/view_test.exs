defmodule ExCSSModules.ViewTest do
  @example_stylesheet __ENV__.file
                      |> Path.dirname()
                      |> Path.join("../support/stylesheet.css")

  use ExUnit.Case

  defmodule ViewModule.Test do
    use ExCSSModules.View,
      stylesheet:
        __ENV__.file
        |> Path.dirname()
        |> Path.join("../support/stylesheet.css")
  end

  defmodule ViewModule.Embedded.Test do
    use ExCSSModules.View,
      stylesheet:
        __ENV__.file
        |> Path.dirname()
        |> Path.join("../support/stylesheet.css"),
      embed_stylesheet: true
  end

  defmodule ViewModule.StylesheetDefinitions.EmptyObject.Test do
    use ExCSSModules.View,
      stylesheet:
        __ENV__.file
        |> Path.dirname()
        |> Path.join("../support/stylesheet_definitions_with_empty_object.css")
  end

  defmodule ViewModule.StylesheetDefinitions.EmptyFile.Test do
    use ExCSSModules.View,
      stylesheet:
        __ENV__.file
        |> Path.dirname()
        |> Path.join("../support/empty_file.css")
  end

  defmodule ViewModule.StylesheetDefinitions.NoFile.Test do
    use ExCSSModules.View,
      stylesheet:
        __ENV__.file
        |> Path.dirname()
        |> Path.join("../support/no_stylesheet_definition.css")
  end

  describe "stylesheet_definition/0" do
    test "gets the stylesheet string" do
      assert ViewModule.Test.stylesheet_definition() ==
               Path.expand(@example_stylesheet)
    end

    test "gets the embedded stylesheet" do
      assert ViewModule.Embedded.Test.stylesheet_definition() ==
               ExCSSModules.stylesheet(@example_stylesheet)
    end
  end

  describe "stylesheet/0" do
    test "calls the stylesheet" do
      assert ViewModule.Test.stylesheet() ==
               ExCSSModules.stylesheet(@example_stylesheet)
    end

    test "returns an empty map if the stylesheet definitions json file contains just an empty object" do
      assert ViewModule.StylesheetDefinitions.EmptyObject.Test.stylesheet() == %{}
    end

    test "returns an empty map if the stylesheet definitions json file is empty" do
      assert ViewModule.StylesheetDefinitions.EmptyFile.Test.stylesheet() == %{}
    end

    test "returns an empty map if the stylesheet definitions json file does not exist" do
      assert ViewModule.StylesheetDefinitions.NoFile.Test.stylesheet() == %{}
    end
  end

  describe "class_selector/1" do
    test "prepends the class_name with a dot" do
      assert ViewModule.Test.class_selector("title") ==
               ExCSSModules.class_selector(@example_stylesheet, "title")
    end
  end

  describe "class_name/1" do
    test "calls the css/2 method on ExCSSModules" do
      assert ViewModule.Test.class_name("title") ==
               ExCSSModules.class_name(@example_stylesheet, "title")
    end
  end

  describe "class_name/2" do
    test "calls the css/3 method on ExCSSModules" do
      assert ViewModule.Test.class_name("title", true) ==
               ExCSSModules.class_name(@example_stylesheet, "title", true)

      assert ViewModule.Test.class_name("title", false) ==
               ExCSSModules.class_name(@example_stylesheet, "title", false)
    end
  end

  describe "class/1" do
    test "calls the class/2 method on ExCSSModules" do
      assert ViewModule.Test.class("title") ==
               ExCSSModules.class(@example_stylesheet, "title")
    end
  end

  describe "class/2" do
    test "calls the class/3 method on ExCSSModules" do
      assert ViewModule.Test.class("title", true) ==
               ExCSSModules.class(@example_stylesheet, "title", true)

      assert ViewModule.Test.class("title", false) ==
               ExCSSModules.class(@example_stylesheet, "title", false)
    end
  end
end
