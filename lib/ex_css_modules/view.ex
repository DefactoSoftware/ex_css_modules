defmodule ExCSSModules.View do
  @moduledoc """
  Implements the ExCSSModule functions into a view.
  """

  @doc """
  Use the ExCSSModules.View on a view which defines the JSON for CSS Modules
  as an external resource.

  If adds the following functions to the View:
  - stylesheet/0 - same as ExCSSModules.stylesheet/1 with the stylesheet predefined
  - class/1 - same as ExCSSModules.class/2 with the stylesheet predefined
  - class_name/1 - same as ExCSSModules.class_name/2 with the stylesheet predefined
  - class_name/2 - same as ExCSSModules.class_name/3 with the stylesheet predefined
  - class_selector/1 - same as ExCSSModules.class_selector/2 with the stylesheet predefined
  """
  defmacro __using__(opts \\ []) do
    quote do
      @external_resource unquote(opts[:stylesheet]) <> ".json"
      @stylesheet ExCSSModules.read_stylesheet(unquote(opts[:stylesheet]))

      def stylesheet, do: ExCSSModules.stylesheet(@stylesheet)

      def class(key), do: ExCSSModules.class(@stylesheet, key)

      def class_name(key), do: ExCSSModules.class_name(@stylesheet, key)
      def class_name(key, value), do:
        ExCSSModules.class_name(@stylesheet, key, value)

      def class_selector(key), do: ExCSSModules.class_selector(@stylesheet, key)
    end
  end
end
