# v0.0.9

## Changed
- The task `:build_stylesheet_definitions_json_task` would run when a stylesheet definitions JSON file was not found. Now it will also run if the JSON file is empty (/DefactoSoftware/ex_css_modules/pull/#113).
- Compilation errors now have a more detailed explanation when the JSON file is not found or empty (/DefactoSoftware/ex_css_modules/pull/#113).

# v0.0.8

## Added
- `:build_stylesheet_definitions_json_task` config option to run a task for building missing stylesheet definitions JSON file when using `:embed_stylsheet` (/DefactoSoftware/ex_css_modules/pull/#112).

# v0.0.7

## Added
- `:embed_by_default` config option to embed stylesheets by default (/DefactoSoftware/ex_css_modules/pull/#67). Thanks @Blond11516!
- `:json_library` config option to specify the JSON library (/DefactoSoftware/ex_css_modules/pull/#75). Thanks @Blond11516!

# v0.0.6

## Added
- Add possibility to call `class/3`, `class_name/3` and `class_selector/2` with an atom as second argument (/DefactoSoftware/ex_css_modules/pull/#22).
- Add typespecs to functions in ExCSSModules module (/DefactoSoftware/ex_css_modules/pull/#22).

# v0.0.5

## Added
- Add `class/2` for conditional checking (/DefactoSoftware/ex_css_modules/pull/#10).

# v0.0.4

## Changed
- The embed option is now evaluated to allow `Mix.env == :prod` and other code that needs to be evaluated (/DefactoSoftware/ex_css_modules/pull/#7).

# v0.0.3

## Changed
- CSS modules are now longer compiled into the code by default. You now have to
  pass `embed_stylesheet: true` to the `__using__` macro to compile the CSS modules in the view.

# v0.0.2

## Changed
- Changes the Mixfile module definition from erroneous ExCell to ExCSSModules

# v0.0.1

## Added
- Initial setup
