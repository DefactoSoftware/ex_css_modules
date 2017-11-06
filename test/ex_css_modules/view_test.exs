defmodule ExCSSModules.ViewTest do
  @example_stylesheet __ENV__.file
                      |> Path.dirname
                      |> Path.join("../support/stylesheet.css")

  use ExUnit.Case

  defmodule ViewModuleTest do
    use ExCSSModules.View, stylesheet: __ENV__.file
                                       |> Path.dirname
                                       |> Path.join("../support/stylesheet.css")
  end

  defmodule EmbeddedViewModuleTest do
    use ExCSSModules.View, stylesheet: __ENV__.file
                                       |> Path.dirname
                                       |> Path.join("../support/stylesheet.css"),
                           embed_stylesheet: true
  end

  describe "stylesheet_definition/0" do
    test "gets the stylesheet string" do
      assert ViewModuleTest.stylesheet_definition
        == Path.expand(@example_stylesheet)
    end

    test "gets the embedded stylesheet" do
      assert EmbeddedViewModuleTest.stylesheet_definition
        == ExCSSModules.stylesheet(@example_stylesheet)
    end
  end

  describe "stylesheet/0" do
    test "calls the stylesheet" do
      assert ViewModuleTest.stylesheet
        == ExCSSModules.stylesheet(@example_stylesheet)
    end
  end

  describe "class_selector/1" do
    test "prepends the class_name with a dot" do
      assert ViewModuleTest.class_selector("title") ==
        ExCSSModules.class_selector(@example_stylesheet, "title")
    end
  end

  describe "class_name/1" do
    test "calls the css/2 method on ExCSSModules" do
      assert ViewModuleTest.class_name("title") ==
        ExCSSModules.class_name(@example_stylesheet, "title")
    end
  end

  describe "class_name/2" do
    test "calls the css/3 method on ExCSSModules" do
      assert ViewModuleTest.class_name("title", true) ==
        ExCSSModules.class_name(@example_stylesheet, "title", true)
      assert ViewModuleTest.class_name("title", false) ==
        ExCSSModules.class_name(@example_stylesheet, "title", false)
    end
  end

  describe "class/1" do
    test "calls the class/2 method on ExCSSModules" do
      assert ViewModuleTest.class("title") ==
        ExCSSModules.class(@example_stylesheet, "title")
    end
  end

  describe "class/2" do
    test "calls the class/3 method on ExCSSModules" do
      assert ViewModuleTest.class("title", true) ==
        ExCSSModules.class(@example_stylesheet, "title", true)
      assert ViewModuleTest.class("title", false) ==
        ExCSSModules.class(@example_stylesheet, "title", false)
    end
  end
end
