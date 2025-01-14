# ExCSSModules

[CSS Modules](https://github.com/css-modules/css-modules) for Elixir. Build to integrate well with the [Phoenix Framework](http://phoenixframework.org/).

[![Hex.pm](https://img.shields.io/hexpm/v/ex_css_modules.svg)](https://hex.pm/packages/ex_css_modules)
[![CircleCI](https://circleci.com/gh/DefactoSoftware/ex_css_modules/tree/master.svg?style=shield)](https://circleci.com/gh/DefactoSoftware/ex_css_modules)

ExCSSModules defines two ways to read the stylesheet: embedded and read.

If you set the `embed_stylesheet` option to the `use` macro the stylesheet definitions JSON have to be compiled before the application is compiled. This flag is used for production to optimize read times. 

If you don't set the flag or set it to false, the stylesheet definition JSON files are read live from the server which creates a lot of IO for each request.

Additionally, you can pass a task to generate missing stylesheet definitions JSON files when compiling ExCSSModules, to prevent compilation errors when one of the stylesheet definitions JSON might be missing:

```ex
defmodule Mix.Tasks.GenerateMissingJson do
  use Mix.Task

  @impl Mix.Task

  def run(filename) do
    with _exit_code = 0 <-
           Mix.shell().cmd("npx postcss #{filename} --dir ./tmp/postcss --verbose") do
      {:ok, filename <> ".json"}
    else
      _exit_code ->
        relative_path = Path.relative_to_cwd(filename)
        exit("Error generating scoped JSON file ./#{relative_path}.json")
    end
  end
end
```

This task can be passed through the option `build_stylesheet_definitions_json_task`: 

```ex
use ExCSSModules.View,
  namespace: MyApplicationWeb,
  embed_stylesheet: ApplicationSettings.built_for?(:prod),
  build_stylesheet_definitions_json_task: unquote(Mix.Tasks.GenerateMissingJson),
  stylesheet:
    __ENV__.file
    |> Path.dirname()
    |> Path.join("./style.css")
```

## Installation
Install from [Hex.pm](https://hex.pm/packages/ex_css_modules):

```ex
def deps do
  [{:ex_css_modules, "~> 0.0.10"}]
end
```

## Usage
To use ExCSSModules in a view compile the CSS file (e.g. through Brunch or Webpack) and add the following to the view:

```ex
defmodule MyApplication.ExampleView do
  use ExCSSModules.View, stylesheet: Path.relative_to_cwd("assets/css/views/example.css")
end
```

This allows you to use the `class` and `class_name` functions in the template and views as followed:

**CSS:**
```css
.title {
  font-size: huge;
}
```

**Template:**
```eex
  <h1 <%= class "title" %>>Hello world</h1>
```

**Output:**
```eex
  <h1 class="_2313dsc-title">Hello world</h1>
```

**Please note that `class` cannot be used in `heex` templates as the HTML
validation engine does not allow it.**

## Advanced usage

### Phoenix.View
ExCSSModules is made for the Phoenix framework and can be easily be automatically be added to your view definition in `web.ex`. At [Defacto](https://github.com/DefactoSoftware) we automatically parse the View name and extract the correct stylesheet from it:

```ex
def view() do
  quote do
    use Phoenix.View, root: "lib/my_application_web/templates",
                      namespace: MyApplicationWeb
    use ExCSSModules.View, namespace: MyApplicationWeb,
                           stylesheet: Path.join(
                            "assets/css/templates",
                            __MODULE__
                            |> Module.split
                            |> Enum.map(&Phoenix.Naming.underscore/1)
                            |> Enum.join("/")
                            |> String.replace_suffix("_view", ".css")
                           )
    ...
  end
end
```

### JSON library selection

ExCSSModules needs to parse JSON files in order to read the mappings between the base classnames and the autogenerated
ones. You can specify which JSON parsing library you wish to use through the `:json_library` config option. If your
project uses Phoenix, it is recommended to use the same library for both Phoenix and ExCSSModules. ExCSSModules uses
[Poison](https://hex.pm/packages/poison) by default.

### ExCell
ExCSSModules works perfectly with [ExCell](https://github.com/DefactoSoftware/ex_cell). By adding the following to your `web.ex` definition for cells you can automatically add the stylesheet in the same directory as your ExCell Cell:
```ex
def cell() do
  quote do
    use ExCell.Cell, namespace: MyApplicationWeb
    use ExCSSModules.View, namespace: MyApplicationWeb,
                           stylesheet: __ENV__.file
                                      |> Path.dirname
                                      |> Path.join("./style.css")
    ...
  end
end
```

### Configuration options

- `embed_by_default`: Global configuration for the `:embed_stylesheet` option of [ExCssModules.View](./lib/view.ex). Can still be overridden by the use option. Useful for configuring different defaults in development and production. Defaults to false.
