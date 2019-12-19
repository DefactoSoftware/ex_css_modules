defmodule ExCSSModules do
  @moduledoc """
  CSS Modules helpers
  """
  alias __MODULE__
  alias Phoenix.HTML

  @doc """
  Reads a valid stylesheet definition. Returns a map if the stylesheet is
  already a map. Reads the file if the stylesheet is a string. Returns an empty
  map if the stylesheet does not exist.

  ## Examples

      iex> stylesheet(@example_stylesheet)
      %{
        "title" => "_namespaced_title",
        "paragraph" => "_namespaced_paragraph"
      }

      iex> stylesheet(%{"title" => "_namespaced_title", "paragraph" => "_namespaced_paragraph"})
      %{
        "title" => "_namespaced_title",
        "paragraph" => "_namespaced_paragraph"
      }

      iex> stylesheet("foobar")
      %{}

  """
  def stylesheet(definition) when is_map(definition), do: definition
  def stylesheet(definition), do: read_stylesheet(definition)

  defp read_stylesheet(filename) do
    case File.exists?(filename) do
      true ->
        (filename <> ".json")
        |> File.read!()
        |> Poison.decode!()

      false ->
        %{}
    end
  end

  @doc """
  Reads the class definitions from the definition map and maps them to a class
  attribute. The classes argument takes any argument and uses the class_name/1
  for the key.

  Returns nil for a class_name that does not exist.

  ## Examples

      iex> class(%{ "hello" => "world"}, "hello")
      {:safe, ~s(class="world")}

      iex> class(%{"hello" => "world"}, "foo")
      nil

  """
  def class(definition, classes) do
    definition
    |> class_name(classes)
    |> class_attribute()
  end

  @doc """
  If `value` is truthy, read the class definitions and maps them to a class attribute.
  When `value` is falsy return nil.

  ## Examples
    iex> class(%{ "hello" => "world"}, "hello", true)
    {:safe, ~s(class="world")}

    iex> class(%{ "hello" => "world"}, "hello", false)
    nil
  """
  def class(definition, classes, value) do
    definition
    |> class_name(classes, value)
    |> class_attribute()
  end

  @doc """
  Returns the class name from the definition map if the last argument is true.
  Returns nil if the last argument is false.

  ## Examples

      iex> class_name(%{"hello" => "world"}, "hello", true)
      "world"

      iex> class_name(%{"hello" => "world"}, "hello", false)
      nil

  """
  def class_name(definition, key, true), do: class_name(definition, key)
  def class_name(_, _, false), do: nil

  @doc """
  Returns the class name from the definition map if the second argument
  in the tuple is true.

  ## Examples
    iex> class_name(%{"hello" => "world"}, {"hello", true})
    "world"

    iex> class_name(%{"hello" => "world"}, {"hello", false})
    nil
  """
  def class_name(definition, {key, value}), do:
    class_name(definition, key, value)

  @doc """
  Returns the class name sfrom the definition map when the argument is a list
  of values or tuples.

  ## Examples
    iex> class_name(%{"hello" => "world", "foo" => "bar"}, ["hello", "foo"])
    "world bar"

    iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", true}, {"foo", true}])
    "world bar"

    iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", true}, {"foo", false}])
    "world"

    iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", false}])
    nil
  """
  def class_name(definition, keys) when is_list(keys) do
    keys
    |> Enum.map(&class_name(definition, &1))
    |> Enum.reject(&is_nil/1)
    |> join_class_name()
  end

  @doc """
  Returns the class name sfrom the definition map when the argument is a list
  of values or tuples.

  ## Examples
    iex> class_name(%{"hello" => "world"}, "hello")
    "world"

    iex> class_name(%{"hello" => "world"}, "foo")
    nil
  """
  def class_name(stylesheet, key) do
    stylesheet
    |> stylesheet()
    |> Map.get(key, nil)
  end

  @doc """
  Takes the definition and makes a class selector that can be used in CSS out of
  the classes given. Takes either a single value or a list of classes.

  ## Examples
    iex> class_selector(%{ "hello" => "world"}, "hello")
    ".world"
    iex> class_selector(%{ "hello" => "world", "foo" => "bar"}, ["hello", "foo"])
    ".world.foo"
  """
  def class_selector(definition, classes) when is_list(classes) do
    classes
    |> Enum.map(&class_selector(definition, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join("")
  end

  @doc false
  def class_selector(definition, class) do
    case class_name(definition, class) do
      nil -> nil
      value -> ".#{value}"
    end
  end

  defp class_attribute(nil), do: nil
  defp class_attribute(class), do: HTML.raw(~s(class="#{class}"))

  defp join_class_name([_ | _] = list), do: Enum.join(list, " ")
  defp join_class_name([]), do: nil
end
