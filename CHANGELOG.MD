# v0.0.6

## Added
- Add possiblity to call `class/3`, `class_name/3` and `class_selector/2` with an atom as second argument (#22).
- Add typespecs to functions in ExCSSModules module (#22).

# v0.0.5

## Added
- Add `class/2` for conditional checking (#10).

# v0.0.4

## Changed
- The embed option is now evaluated to allow `Mix.env == :prod` and other code that needs to be evaluated (#7).

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
