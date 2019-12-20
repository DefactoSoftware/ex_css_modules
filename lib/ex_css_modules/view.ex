defmodule ExCSSModules.View do
  @moduledoc """
  Implements the ExCSSModule functions into a view.
  """

  @doc """
  Use the ExCSSModules.View on a view which defines the JSON for CSS Modules
  as an external resource.

  To embed the stylesheet in the file set :embed_stylesheet to true.

  If adds the following functions to the View:
  - stylesheet/0 - same as ExCSSModules.stylesheet/1 with the stylesheet predefined
  - class/1 - same as ExCSSModules.class/2 with the stylesheet predefined
  - class_name/1 - same as ExCSSModules.class_name/2 with the stylesheet predefined
  - class_name/2 - same as ExCSSModules.class_name/3 with the stylesheet predefined
  - class_selector/1 - same as ExCSSModules.class_selector/2 with the stylesheet predefined
  """

  defmacro __using__(opts \\ []) do
    {filename, [file: relative_to]} = Code.eval_quoted(opts[:stylesheet], file: __CALLER__.file)
    {embed, _} = Code.eval_quoted(opts[:embed_stylesheet])
    filename = Path.expand(filename, Path.dirname(relative_to))

    quote do
      @stylesheet unquote(
                    if embed do
                      Macro.escape(ExCSSModules.read_stylesheet(filename))
                    else
                      Macro.escape(filename)
                    end
                  )

      def stylesheet_definition, do: @stylesheet

      def stylesheet, do: ExCSSModules.stylesheet(@stylesheet)

      def class(key), do: stylesheet() |> ExCSSModules.class(key)
      def class(key, value), do: stylesheet() |> ExCSSModules.class(key, value)

      def class_name(key), do: stylesheet() |> ExCSSModules.class_name(key)
      def class_name(key, value), do: stylesheet() |> ExCSSModules.class_name(key, value)

      def class_selector(key), do: stylesheet() |> ExCSSModules.class_selector(key)
    end
  end
end
