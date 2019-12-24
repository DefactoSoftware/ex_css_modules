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
  attribute. The `keys` argument is used to retrieve the class name or multiple
  class names with class_name/1.

  Returns nil for a class_name that does not exist.

  ## Examples

      iex> class(%{ "hello" => "world"}, "hello")
      {:safe, ~s(class="world")}

      iex> class(%{"hello" => "world"}, "foo")
      nil

  """
  def class(definition, keys) do
    definition
    |> class_name(keys)
    |> class_attribute()
  end

  @doc """
  If `return_class?` is truthy, reads the class definitions and maps them to a
  class attribute. When `return_class?` is falsy returns nil.

  ## Examples

      iex> class(%{ "hello" => "world"}, "hello", true)
      {:safe, ~s(class="world")}

      iex> class(%{ "hello" => "world"}, "hello", false)
      nil

  """
  def class(definition, keys, return_class?) do
    definition
    |> class_name(keys, return_class?)
    |> class_attribute()
  end

  @doc """
  Returns the class name from the definition map if the last argument is truthy.
  Returns nil if the last argument is falsy.

  ## Examples

      iex> class_name(%{"hello" => "world"}, "hello", true)
      "world"

      iex> class_name(%{"hello" => "world"}, "hello", "anything")
      "world"

      iex> class_name(%{"hello" => "world"}, "hello", false)
      nil

      iex> class_name(%{"hello" => "world"}, "hello", nil)
      nil

  """
  def class_name(_, _, false), do: nil
  def class_name(_, _, nil), do: nil
  def class_name(definition, key, _), do: class_name(definition, key)

  @doc """
  Returns the class name or class names from the definition map, concatenated as
  one string separated by spaces.

  Second argument can be a string name of the key, a tuple with `{key, boolean}`
  or a list of keys or tuples.

  ## Examples

      iex> class_name(%{"hello" => "world"}, "hello")
      "world"

      iex> class_name(%{"hello" => "world"}, "foo")
      nil

      iex> class_name(%{"hello" => "world"}, {"hello", true})
      "world"

      iex> class_name(%{"hello" => "world"}, {"hello", false})
      nil

      iex> class_name(%{"hello" => "world", "foo" => "bar"}, ["hello", "foo"])
      "world bar"

      iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", true}, {"foo", true}])
      "world bar"

      iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", true}, {"foo", false}])
      "world"

      iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", false}])
      nil

      iex> class_name(%{}, "hello")
      nil

  """
  def class_name(definition, keys) when is_list(keys) do
    keys
    |> Enum.map(&class_name(definition, &1))
    |> Enum.reject(&is_nil/1)
    |> join_class_name()
  end

  def class_name(definition, {key, return_class?}), do: class_name(definition, key, return_class?)

  def class_name(definition, key) do
    definition
    |> stylesheet()
    |> Map.get(key, nil)
  end

  @doc """
  Takes the definition and makes a class selector that can be used in CSS out of
  the keys given. Takes either a single value or a list of keys.

  ## Examples

      iex> class_selector(@example_stylesheet, "title")
      "._namespaced_title"

      iex> class_selector(@example_stylesheet, ["title", "paragraph"])
      "._namespaced_title._namespaced_paragraph"

      iex> class_selector(@example_stylesheet, "foo")
      nil

      iex> class_selector(%{ "hello" => "world"}, "hello")
      ".world"

      iex> class_selector(%{ "hello" => "world", "foo" => "bar"}, ["hello", "foo"])
      ".world.bar"

  """
  def class_selector(definition, keys) when is_list(keys) do
    keys
    |> Enum.map(&class_selector(definition, &1))
    |> Enum.reject(&is_nil/1)
    |> List.to_string()
  end

  def class_selector(definition, key), do: definition |> class_name(key) |> class_selector()

  defp class_selector(class) when is_binary(class), do: ".#{class}"
  defp class_selector(nil), do: nil

  defp class_attribute(class) when is_binary(class), do: HTML.raw(~s(class="#{class}"))
  defp class_attribute(nil), do: nil

  defp join_class_name([_ | _] = list), do: Enum.join(list, " ")
  defp join_class_name([]), do: nil
end
